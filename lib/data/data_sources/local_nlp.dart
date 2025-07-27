import 'package:cloudwalk_llm/application/failure.dart';
import 'package:cloudwalk_llm/data/data_sources/processor.dart';
import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:cloudwalk_llm/presentation/logic/layout_editor_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class LocalNlp extends Processor {
//   @override
//   Future<ScaffoldEntity> nlpProcessing(
//       String prompt, BuildContext context) async {
//     final state = context.read<LayoutEditorBloc>().state;
//     final data = state.data;
//     // todo: create if else to parse prompt into
//     // case 1 : action + widget + style + value
//     // case 2 : action + style + value
//     // solution case 1
//     final tokens = prompt.split(' ');
//     final action = tokens.first;
//
//     final widgetType = tokens.length > 1 &&
//             ['text', 'button', 'textfield', 'image'].contains(tokens[1])
//         ? tokens[1]
//         : null;
//
//     switch (action) {
//       case 'add':
//         if (widgetType != null) {
//           final list =
//               data!.children.first.children!.where((w) => w.type == widgetType);
//           final id = list.length + 1;
//           final widget = WidgetModel(
//             type: widgetType,
//             properties: WidgetModel.defaultProperties(widgetType),
//             id: '$widgetType${id.toString()}',
//           );
//           data.children.first.children!.add(widget);
//         }
//         return data!;
//       case 'remove':
//         data!.children.first.children!.removeWhere(
//           (w) => w.type == widgetType,
//         );
//         return data;
//       case 'change':
//         // Example: change background to red
//         if (tokens[1] == 'background') {
//           data!.properties!.background = tokens[3];
//           return data;
//         } else {
//           // Example: change button color to red
//           var widgetList = data!.children.first.children!
//               .where((widget) => widget.type == tokens[1]);
//           if (widgetList.isNotEmpty) {
//             final widget = widgetList.first;
//             if (tokens[2] == 'color') {
//               _changeBackground(widget, tokens[4]);
//               return data;
//             } else {
//               throw InternalFailure("Style not support");
//             }
//           } else {
//             throw InternalFailure("Widget not found");
//           }
//         }
//       default:
//         throw InternalFailure("Unsupported prompt: $prompt");
//     }
//   }
//
//   WidgetModel _changeBackground(WidgetModel widget, String color) {
//     try {
//       int.parse(color);
//     } catch (e) {
//       throw InternalFailure("Color not support");
//     }
//     switch (widget.type) {
//       case 'button':
//         (widget.properties! as ButtonProperties).backgroundColor = color;
//         return widget;
//       case 'textfield':
//         (widget.properties! as TextFieldProperties).decoration!.filled = true;
//         (widget.properties! as TextFieldProperties).decoration!.fillColor =
//             color;
//         return widget;
//       case 'text':
//         (widget.properties! as TextProperties).style!.color = color;
//         return widget;
//       default:
//         throw InternalFailure("Unsupported prompt");
//     }
//   }
// }
class LocalNlp extends Processor {
  // Supported colors map for better validation
  static const Map<String, String> colorMap = {
    'red': '0xffF44336',
    'blue': '0xff2196F3',
    'green': '0xff4CAF50',
    'yellow': '0xffFFEB3B',
    'orange': '0xffFF9800',
    'purple': '0xff9C27B0',
    'pink': '0xffE91E63',
    'black': '0xff000000',
    'white': '0xffffffff',
    'grey': '0xff9E9E9E',
    'gray': '0xff9E9E9E',
    'transparent': '0x00000000',
  };

  // Widget-specific supported properties
  static const Map<String, Set<String>> widgetSupportedProperties = {
    'text': {'color', 'size', 'weight', 'family', 'text'},
    'button': {'color', 'width', 'text', 'elevation'},
    'textfield': {'color', 'width', 'hint', 'border', 'radius'},
    'image': {'width', 'height', 'fit', 'url'},
  };

  @override
  Future<ScaffoldEntity> nlpProcessing(
      String prompt, BuildContext context) async {
    final state = context.read<LayoutEditorBloc>().state;
    final data = state.data;

    if (data == null) {
      throw InternalFailure("No data available");
    }

    try {
      final tokens = prompt.toLowerCase().trim().split(RegExp(r'\s+'));
      final action = tokens.first;

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
    } catch (e) {
      throw InternalFailure("Failed to process prompt: ${e.toString()}");
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

    final widget = WidgetModel(
      type: widgetType,
      properties: WidgetModel.defaultProperties(widgetType),
      id: '$widgetType$id',
    );

    // Apply additional properties from prompt if provided
    _applyPropertiesFromTokens(widget, tokens.skip(2).toList());

    data.children.first.children!.add(widget);
    return data;
  }

  ScaffoldEntity _handleRemoveAction(List<String> tokens, ScaffoldEntity data) {
    if (tokens.length < 2) {
      throw InternalFailure("Remove command requires target");
    }

    final target = tokens[1];

    // Remove by ID: "remove button1"
    if (_isWidgetId(target)) {
      data.children.first.children!.removeWhere((w) => w.id == target);
      return data;
    }

    // Remove by type: "remove button"
    if (['text', 'button', 'textfield', 'image'].contains(target)) {
      // Check if specific instance mentioned: "remove button 2"
      if (tokens.length > 2 && _isNumber(tokens[2])) {
        final instanceNumber = int.parse(tokens[2]);
        final targetId = '$target$instanceNumber';
        data.children.first.children!.removeWhere((w) => w.id == targetId);
      } else {
        // Remove all widgets of this type
        data.children.first.children!.removeWhere((w) => w.type == target);
      }
      return data;
    }

    // Remove all: "remove all"
    if (target == 'all') {
      data.children.first.children!.clear();
      return data;
    }

    throw InternalFailure("Invalid remove target: $target");
  }

  ScaffoldEntity _handleChangeAction(List<String> tokens, ScaffoldEntity data) {
    if (tokens.length < 4) {
      throw InternalFailure("Change command requires target, property, and value");
    }

    // Handle background change: "change background to red"
    if (tokens[1] == 'background') {
      final colorValue = _resolveColorValue(tokens[3]);
      data.properties!.background = colorValue;
      return data;
    }

    // Handle widget-specific changes
    final target = tokens[1];
    final property = tokens[2];
    final value = tokens.length > 4 ? tokens[4] : tokens[3]; // Handle "to" keyword

    // Find target widget
    WidgetModel? targetWidget = _findTargetWidget(target, data);
    if (targetWidget == null) {
      throw InternalFailure("Widget not found: $target");
    }

    // Validate property for widget type
    if (!widgetSupportedProperties[targetWidget.type]!.contains(property)) {
      throw InternalFailure(
          "Property '$property' not supported for ${targetWidget.type}");
    }

    // Apply the change
    _updateWidgetProperty(targetWidget, property, value);
    return data;
  }

  WidgetModel? _findTargetWidget(String target, ScaffoldEntity data) {
    final widgets = data.children.first.children!;

    // Try to find by exact ID first: "button1", "text2"
    if (_isWidgetId(target)) {
      return widgets.firstWhere(
            (w) => w.id == target,
        orElse: () => throw InternalFailure("Widget with ID '$target' not found"),
      );
    }

    // Try to find by type (first occurrence): "button", "text"
    if (['text', 'button', 'textfield', 'image'].contains(target)) {
      final typeWidgets = widgets.where((w) => w.type == target).toList();
      if (typeWidgets.isNotEmpty) {
        return typeWidgets.first;
      }
    }

    return null;
  }

  void _updateWidgetProperty(WidgetModel widget, String property, String value) {
    switch (widget.type) {
      case 'button':
        _updateButtonProperty(widget, property, value);
        break;
      case 'text':
        _updateTextProperty(widget, property, value);
        break;
      case 'textfield':
        _updateTextFieldProperty(widget, property, value);
        break;
      case 'image':
        _updateImageProperty(widget, property, value);
        break;
      default:
        throw InternalFailure("Unsupported widget type: ${widget.type}");
    }
  }

  void _updateButtonProperty(WidgetModel widget, String property, String value) {
    final props = widget.properties! as ButtonProperties;

    switch (property) {
      case 'color':
        final colorValue = _resolveColorValue(value);
        props.backgroundColor = colorValue;
        break;
      case 'width':
        final width = _parseDoubleValue(value);
        // Note: ButtonProperties might need width property added
        // For now, we could wrap in container or extend ButtonProperties
        throw InternalFailure("Width property for button needs implementation in ButtonProperties");
      case 'text':
        props.text = value;
        break;
      case 'elevation':
        final elevation = _parseDoubleValue(value);
        props.elevation = elevation;
        break;
      default:
        throw InternalFailure("Unsupported button property: $property");
    }
  }

  void _updateTextProperty(WidgetModel widget, String property, String value) {
    final props = widget.properties! as TextProperties;

    switch (property) {
      case 'color':
        final colorValue = _resolveColorValue(value);
        props.style ??= TextStyleModel();
        props.style!.color = colorValue;
        break;
      case 'size':
        final fontSize = _parseDoubleValue(value);
        props.style ??= TextStyleModel();
        props.style!.fontSize = fontSize;
        break;
      case 'weight':
        props.style ??= TextStyleModel();
        props.style!.fontWeight = _mapFontWeight(value);
        break;
      case 'family':
        props.style ??= TextStyleModel();
        props.style!.fontFamily = value;
        break;
      case 'text':
        props.text = value;
        break;
      default:
        throw InternalFailure("Unsupported text property: $property");
    }
  }

  void _updateTextFieldProperty(WidgetModel widget, String property, String value) {
    final props = widget.properties! as TextFieldProperties;

    switch (property) {
      case 'color':
        final colorValue = _resolveColorValue(value);
        props.decoration ??= InputDecorationModel();
        props.decoration!.filled = true;
        props.decoration!.fillColor = colorValue;
        break;
      case 'width':
      // Note: TextFieldProperties might need width property added
      // Could be handled by wrapping in SizedBox or Container
        throw InternalFailure("Width property for textfield needs implementation");
      case 'hint':
        props.decoration ??= InputDecorationModel();
        props.decoration!.hintText = value;
        break;
      case 'border':
        props.decoration ??= InputDecorationModel();
        props.decoration!.borderSide = value;
        break;
      case 'radius':
        final radius = _parseDoubleValue(value);
        props.decoration ??= InputDecorationModel();
        props.decoration!.borderRadius = radius;
        break;
      default:
        throw InternalFailure("Unsupported textfield property: $property");
    }
  }

  void _updateImageProperty(WidgetModel widget, String property, String value) {
    final props = widget.properties! as ImageProperties;

    switch (property) {
      case 'width':
        final width = _parseDoubleValue(value);
        props.width = width;
        break;
      case 'height':
        final height = _parseDoubleValue(value);
        props.height = height;
        break;
      case 'fit':
        props.fit = _mapBoxFit(value);
        break;
      case 'url':
        props.url = value;
        break;
      default:
        throw InternalFailure("Unsupported image property: $property");
    }
  }

  void _applyPropertiesFromTokens(WidgetModel widget, List<String> tokens) {
    // Parse additional properties from add command
    // Example: "add button text Login color blue width 200"
    for (int i = 0; i < tokens.length - 1; i++) {
      final property = tokens[i];
      final value = tokens[i + 1];

      if (widgetSupportedProperties[widget.type]!.contains(property)) {
        try {
          _updateWidgetProperty(widget, property, value);
          i++; // Skip the value token in next iteration
        } catch (e) {
          // Continue parsing other properties if one fails
          continue;
        }
      }
    }
  }

  // Helper methods
  bool _isWidgetId(String target) {
    // Check if target matches pattern like "button1", "text2", etc.
    final regex = RegExp(r'^(text|button|textfield|image)\d+$');
    return regex.hasMatch(target);
  }

  bool _isNumber(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  String _resolveColorValue(String value) {
    // Check named colors first
    if (colorMap.containsKey(value.toLowerCase())) {
      return colorMap[value.toLowerCase()]!;
    }

    // Check if it's already a hex color
    if (value.startsWith('0x')) {
      try {
        int.parse(value.substring(2), radix: 16);
        return value;
      } catch (e) {
        throw InternalFailure("Invalid hex color: $value");
      }
    }

    // Try to parse as number (assuming it's a hex without 0x prefix)
    try {
      int.parse(value, radix: 16);
      return '0xff$value';
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

