import 'package:cloudwalk_llm/application/failure.dart';
import 'package:cloudwalk_llm/data/data_sources/processor.dart';
import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:cloudwalk_llm/presentation/logic/layout_editor_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalNlp extends Processor {
  // Your existing constants remain the same...
  static const Map<String, String> colorMap = {
    'red': 'F44336',
    'blue': '2196F3',
    'green': '4CAF50',
    'yellow': 'FFEB3B',
    'orange': 'FF9800',
    'purple': '9C27B0',
    'pink': 'E91E63',
    'black': '000000',
    'white': 'ffffff',
    'grey': '9E9E9E',
    'gray': '9E9E9E',
    'transparent': '00000000',
  };

  static const Map<String, Set<String>> widgetSupportedProperties = {
    'text': {'color', 'size', 'weight', 'family', 'text'},
    'button': {'color', 'width', 'text', 'elevation'},
    'textfield': {'color', 'width', 'hint', 'border', 'radius'},
    'image': {'width', 'height', 'fit', 'url'},
  };

  @override
  Future<ScaffoldEntity> nlpProcessing(String prompt, BuildContext context) async {
    final state = context.read<LayoutEditorCubit>().state;
    final data = state.data; // state is now ScaffoldEntity directly

    final tokens = prompt.toLowerCase().trim().split(RegExp(r'\s+'));
    final action = tokens.first;

    if (data == null) {
      throw InternalFailure("No data available");
    }

    switch (action) {
      case 'add':
        return _handleAddAction(tokens, data);
      case 'remove':
        return _handleRemoveAction(tokens, data);
      case 'change':
      case 'update':
      case 'modify':
        return _handleChangeAction(tokens, data);
      default:
        throw InternalFailure("Unsupported action: $action");
    }
  }

  ScaffoldEntity _handleAddAction(List<String> tokens, ScaffoldEntity data) {
    if (tokens.length < 2) {
      throw InternalFailure("Add command requires widget type");
    }

    final widgetType = tokens[1];
    if (!['text', 'button', 'textfield', 'image'].contains(widgetType)) {
      throw InternalFailure("Unsupported widget type: $widgetType");
    }

    // Generate unique ID
    final existingWidgets = data.children.first.children!
        .where((w) => w.type == widgetType);
    final id = existingWidgets.length + 1;

    // Create new widget
    final newWidget = WidgetModel(
      type: widgetType,
      properties: WidgetModel.defaultProperties(widgetType),
      id: '$widgetType$id',
    );

    // Apply additional properties from prompt if provided
    final updatedWidget = _applyPropertiesFromTokens(newWidget, tokens.skip(2).toList());

    // Create new list with added widget (immutable approach)
    final updatedChildren = List<WidgetModel>.from(data.children.first.children!)
      ..add(updatedWidget);

    // Create new column with updated children
    final updatedColumn = WidgetModel(
      type: data.children.first.type,
      id: data.children.first.id,
      properties: data.children.first.properties,
      children: updatedChildren,
    );

    return ScaffoldEntity(
      type: data.type,
      properties: data.properties,
      children: [updatedColumn],
    );
  }

  ScaffoldEntity _handleRemoveAction(List<String> tokens, ScaffoldEntity data) {
    if (tokens.length < 2) {
      throw InternalFailure("Remove command requires target");
    }

    final target = tokens[1];
    List<WidgetModel> updatedChildren = List.from(data.children.first.children!);

    // Remove by ID: "remove button1"
    if (_isWidgetId(target)) {
      updatedChildren.removeWhere((w) => w.id == target);
    }
    // Remove by type: "remove button"
    else if (['text', 'button', 'textfield', 'image'].contains(target)) {
      if (tokens.length > 2 && _isNumber(tokens[2])) {
        final instanceNumber = int.parse(tokens[2]);
        final targetId = '$target$instanceNumber';
        updatedChildren.removeWhere((w) => w.id == targetId);
      } else {
        updatedChildren.removeWhere((w) => w.type == target);
      }
    }
    // Remove all: "remove all"
    else if (target == 'all') {
      updatedChildren.clear();
    } else {
      throw InternalFailure("Invalid remove target: $target");
    }

    // Create new column with updated children
    final updatedColumn = WidgetModel(
      type: data.children.first.type,
      id: data.children.first.id,
      properties: data.children.first.properties,
      children: updatedChildren,
    );

    // Return new ScaffoldEntity
    return ScaffoldEntity(
      type: data.type,
      properties: data.properties,
      children: [updatedColumn],
    );
  }

  ScaffoldEntity _handleChangeAction(List<String> tokens, ScaffoldEntity data) {
    if (tokens.length < 4) {
      throw InternalFailure("Change command requires target, property, and value");
    }

    // Handle background change: "change background to red"
    if (tokens[1] == 'background') {
      final colorValue = _resolveColorValue(tokens[3]);

      // Create new properties with updated background
      final updatedProperties = ScaffoldProperties(
        background: colorValue,
      );

      return ScaffoldEntity(
        type: data.type,
        properties: updatedProperties,
        children: data.children,
      );
    }

    // Handle widget-specific changes
    final target = tokens[1];
    final property = tokens[2];
    final value = tokens.length > 4 ? tokens[4] : tokens[3];

    // Find target widget index and widget
    final widgets = data.children.first.children!;
    final targetIndex = _findTargetWidgetIndex(target, widgets);

    if (targetIndex == -1) {
      throw InternalFailure("Widget not found: $target");
    }

    final targetWidget = widgets[targetIndex];

    // Validate property for widget type
    if (!widgetSupportedProperties[targetWidget.type]!.contains(property)) {
      throw InternalFailure("Property '$property' not supported for ${targetWidget.type}");
    }

    // Create updated widget with new property
    final updatedWidget = _createUpdatedWidget(targetWidget, property, value);

    // Create new children list with updated widget
    final updatedChildren = List<WidgetModel>.from(widgets);
    updatedChildren[targetIndex] = updatedWidget;

    // Create new column with updated children
    final updatedColumn = WidgetModel(
      type: data.children.first.type,
      id: data.children.first.id,
      properties: data.children.first.properties,
      children: updatedChildren,
    );

    return ScaffoldEntity(
      type: data.type,
      properties: data.properties,
      children: [updatedColumn],
    );
  }

  int _findTargetWidgetIndex(String target, List<WidgetModel> widgets) {
    // Try to find by exact ID first
    if (_isWidgetId(target)) {
      return widgets.indexWhere((w) => w.id == target);
    }

    // Try to find by type (first occurrence)
    if (['text', 'button', 'textfield', 'image'].contains(target)) {
      return widgets.indexWhere((w) => w.type == target);
    }

    return -1;
  }

  WidgetModel _createUpdatedWidget(WidgetModel widget, String property, String value) {
    WidgetProperties updatedProperties;

    switch (widget.type) {
      case 'button':
        updatedProperties = _createUpdatedButtonProperties(
            widget.properties! as ButtonProperties,
            property,
            value,
        );
        break;
      case 'text':
        updatedProperties = _createUpdatedTextProperties(
            widget.properties! as TextProperties,
            property,
            value
        );
        break;
      case 'textfield':
        updatedProperties = _createUpdatedTextFieldProperties(
            widget.properties! as TextFieldProperties,
            property,
            value
        );
        break;
      case 'image':
        updatedProperties = _createUpdatedImageProperties(
            widget.properties! as ImageProperties,
            property,
            value
        );
        break;
      default:
        throw InternalFailure("Unsupported widget type: ${widget.type}");
    }

    return WidgetModel(
      type: widget.type,
      id: widget.id,
      properties: updatedProperties,
      children: widget.children,
    );
  }

  ButtonProperties _createUpdatedButtonProperties(
      ButtonProperties props,
      String property,
      String value
      ) {
    switch (property) {
      case 'color':
        return ButtonProperties(
          text: props.text,
          width: props.width,
          padding: props.padding,
          backgroundColor: _resolveColorValue(value),
          elevation: props.elevation,
        );
      case 'width':
        return ButtonProperties(
          text: props.text,
          width: _parseDoubleValue(value),
          padding: props.padding,
          backgroundColor: props.backgroundColor,
          elevation: props.elevation,
        );
      case 'text':
        return ButtonProperties(
          text: value,
          width: props.width,
          padding: props.padding,
          backgroundColor: props.backgroundColor,
          elevation: props.elevation,
        );
      case 'elevation':
        return ButtonProperties(
          text: props.text,
          width: props.width,
          padding: props.padding,
          backgroundColor: props.backgroundColor,
          elevation: _parseDoubleValue(value),
        );
      default:
        throw InternalFailure("Unsupported button property: $property");
    }
  }

  TextProperties _createUpdatedTextProperties(
      TextProperties props,
      String property,
      String value
      ) {
    TextStyleModel? updatedStyle = props.style;

    switch (property) {
      case 'color':
        updatedStyle = TextStyleModel(
          fontSize: props.style?.fontSize,
          fontWeight: props.style?.fontWeight,
          fontFamily: props.style?.fontFamily,
          color: _resolveColorValue(value),
        );
        break;
      case 'size':
        updatedStyle = TextStyleModel(
          fontSize: _parseDoubleValue(value),
          fontWeight: props.style?.fontWeight,
          fontFamily: props.style?.fontFamily,
          color: props.style?.color,
        );
        break;
      case 'weight':
        updatedStyle = TextStyleModel(
          fontSize: props.style?.fontSize,
          fontWeight: _mapFontWeight(value),
          fontFamily: props.style?.fontFamily,
          color: props.style?.color,
        );
        break;
      case 'family':
        updatedStyle = TextStyleModel(
          fontSize: props.style?.fontSize,
          fontWeight: props.style?.fontWeight,
          fontFamily: value,
          color: props.style?.color,
        );
        break;
    }

    return TextProperties(
      text: property == 'text' ? value : props.text,
      alignment: props.alignment,
      padding: props.padding,
      style: updatedStyle,
    );
  }

  TextFieldProperties _createUpdatedTextFieldProperties(
      TextFieldProperties props,
      String property,
      String value
      ) {
    InputDecorationModel? updatedDecoration = props.decoration;

    switch (property) {
      case 'color':
        updatedDecoration = InputDecorationModel(
          fillColor: _resolveColorValue(value),
          filled: true,
          borderRadius: props.decoration?.borderRadius,
          borderSide: props.decoration?.borderSide,
          hintText: props.decoration?.hintText,
          hintStyle: props.decoration?.hintStyle,
        );
        break;
      case 'hint':
        updatedDecoration = InputDecorationModel(
          fillColor: props.decoration?.fillColor,
          filled: props.decoration?.filled,
          borderRadius: props.decoration?.borderRadius,
          borderSide: props.decoration?.borderSide,
          hintText: value,
          hintStyle: props.decoration?.hintStyle,
        );
        break;
      case 'radius':
        updatedDecoration = InputDecorationModel(
          fillColor: props.decoration?.fillColor,
          filled: props.decoration?.filled,
          borderRadius: _parseDoubleValue(value),
          borderSide: props.decoration?.borderSide,
          hintText: props.decoration?.hintText,
          hintStyle: props.decoration?.hintStyle,
        );
        break;
      default:
        throw InternalFailure("Unsupported textfield property: $property");
    }

    return TextFieldProperties(
      padding: props.padding,
      decoration: updatedDecoration,
    );
  }

  ImageProperties _createUpdatedImageProperties(
      ImageProperties props,
      String property,
      String value
      ) {
    switch (property) {
      case 'width':
        return ImageProperties(
          url: props.url,
          width: _parseDoubleValue(value),
          height: props.height,
          fit: props.fit,
        );
      case 'height':
        return ImageProperties(
          url: props.url,
          width: props.width,
          height: _parseDoubleValue(value),
          fit: props.fit,
        );
      case 'fit':
        return ImageProperties(
          url: props.url,
          width: props.width,
          height: props.height,
          fit: _mapBoxFit(value),
        );
      case 'url':
        return ImageProperties(
          url: value,
          width: props.width,
          height: props.height,
          fit: props.fit,
        );
      default:
        throw InternalFailure("Unsupported image property: $property");
    }
  }

  WidgetModel _applyPropertiesFromTokens(WidgetModel widget, List<String> tokens) {
    WidgetModel currentWidget = widget;

    for (int i = 0; i < tokens.length - 1; i++) {
      final property = tokens[i];
      final value = tokens[i + 1];

      if (widgetSupportedProperties[widget.type]!.contains(property)) {
        try {
          currentWidget = _createUpdatedWidget(currentWidget, property, value);
          i++; // Skip the value token in next iteration
        } catch (e) {
          // Continue parsing other properties if one fails
          continue;
        }
      }
    }

    return currentWidget;
  }

  // Your existing helper methods remain the same...
  bool _isWidgetId(String target) {
    final regex = RegExp(r'^(text|button|textfield|image)\d+$');
    return regex.hasMatch(target);
  }

  bool _isNumber(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  String _resolveColorValue(String value) {
    if (colorMap.containsKey(value.toLowerCase())) {
      return colorMap[value.toLowerCase()]!;
    }

    if (value.startsWith('0x')) {
      try {
        int.parse(value.substring(2), radix: 16);
        return value.substring(2);
      } catch (e) {
        throw InternalFailure("Invalid hex color: $value");
      }
    }

    try {
      int.parse(value, radix: 16);
      return value;
    } catch (e) {
      throw InternalFailure("Invalid color format: $value");
    }
  }

  double _parseDoubleValue(String value) {
    try {

      return double.parse(value);
    } catch (e) {
      throw InternalFailure("Invalid number format: $value");
    }
  }

  String _mapFontWeight(String weight) {
    final weightMap = {
      'thin': 'w100',
      'light': 'w300',
      'normal': 'w400',
      'medium': 'w500',
      'semibold': 'w600',
      'bold': 'w700',
      'extrabold': 'w800',
      'black': 'w900',
    };
    return weightMap[weight.toLowerCase()] ?? weight;
  }

  String _mapBoxFit(String fit) {
    final fitMap = {
      'fill': 'fill',
      'contain': 'contain',
      'cover': 'cover',
      'width': 'fitWidth',
      'height': 'fitHeight',
      'none': 'none',
      'scale': 'scaleDown',
    };
    return fitMap[fit.toLowerCase()] ?? 'cover';
  }
}