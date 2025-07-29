import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:flutter/material.dart';

class CustomLayoutBuilder {
  final bool userAction;
  final ValueNotifier<bool> showWidgetIdListenable;

  CustomLayoutBuilder({
    required this.showWidgetIdListenable,
    required this.userAction,
  });

  /// Build Flutter widget from ScaffoldEntity
  Widget buildFromScaffoldEntity(ScaffoldEntity scaffoldEntity) {
    return _buildScaffold(scaffoldEntity);
  }

  Widget _buildScaffold(ScaffoldEntity scaffoldEntity) {
    Color? backgroundColor;
    if (scaffoldEntity.properties?.background != null) {
      backgroundColor = _parseColor(scaffoldEntity.properties!.background!);
    }

    // Find special scaffold children
    WidgetModel? drawer;
    WidgetModel? appBar;
    WidgetModel? bottomNavigationBar;
    List<WidgetModel> bodyChildren = [];

    for (var child in scaffoldEntity.children) {
      switch (child.type) {
        case 'drawer':
          drawer = child;
          break;
        case 'appBar':
          appBar = child;
          break;
        case 'bottomNavigationBar':
          bottomNavigationBar = child;
          break;
        default:
          bodyChildren.add(child);
      }
    }

    Widget? body;
    if (bodyChildren.isNotEmpty) {
      if (bodyChildren.length == 1) {
        body = _buildWidgetModel(bodyChildren[0]);
      } else {
        body = Column(
          children: bodyChildren.map((child) => _buildWidgetModel(child)).toList(),
        );
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: drawer != null ? _buildDrawer(drawer) : null,
      appBar: appBar != null ? _buildAppBar(appBar) : null,
      bottomNavigationBar: bottomNavigationBar != null
          ? _buildBottomNavigationBar(bottomNavigationBar)
          : null,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: SafeArea(
            child: body ?? Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetModel(WidgetModel widgetModel) {
    Widget widget;

    switch (widgetModel.type) {
      case 'column':
        widget = _buildColumn(widgetModel);
        break;
      case 'row':
        widget = _buildRow(widgetModel);
        break;
      case 'text':
        widget = _buildText(widgetModel);
        break;
      case 'textfield':
        widget = _buildTextField(widgetModel);
        break;
      case 'button':
        widget = _buildButton(widgetModel);
        break;
      case 'image':
        widget = _buildImage(widgetModel);
        break;
      case 'container':
        widget = _buildContainer(widgetModel);
        break;
      case 'listTile':
        widget = _buildListTile(widgetModel);
        break;
      default:
        widget = Container(
          padding: const EdgeInsets.all(8),
          child: Text('Unknown widget type: ${widgetModel.type}'),
        );
    }

    return _wrapWithIdOverlay(widget, widgetModel);
  }
  /// Wraps any widget with an ID overlay that can be toggled
  Widget _wrapWithIdOverlay(Widget child, WidgetModel widgetModel) {
    return ValueListenableBuilder<bool>(
      valueListenable: showWidgetIdListenable,
      builder: (context, showWidgetId, _) {
        if (showWidgetId == true && widgetModel.type != 'column') {
          return Stack(
            children: [
              child,
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffA8A8FF).withOpacity(0.3),
                    border: Border.all(
                      color: const Color(0xffA8A8FF),
                      width: 1,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xffC5FAFF),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: Text(
                        widgetModel.id ?? 'no-id',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return child;
      },
    );
  }

  Widget _buildColumn(WidgetModel widgetModel) {
    final List<Widget> childWidgets = widgetModel.children
            ?.map((child) => _buildWidgetModel(child))
            .toList() ??
        [];

    // Extract column-specific properties from GenericProperties if available
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;

    if (widgetModel.properties is GenericProperties) {
      final props = (widgetModel.properties as GenericProperties).properties;

      if (props['mainAxisAlignment'] != null) {
        mainAxisAlignment = _parseMainAxisAlignment(props['mainAxisAlignment']);
      }

      if (props['crossAxisAlignment'] != null) {
        crossAxisAlignment =
            _parseCrossAxisAlignment(props['crossAxisAlignment']);
      }
    }

    Widget column = Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: childWidgets,
    );

    return _applyGenericPadding(column, widgetModel.properties);
  }

  Widget _buildRow(WidgetModel widgetModel) {
    final List<Widget> childWidgets = widgetModel.children
            ?.map((child) => _buildWidgetModel(child))
            .toList() ??
        [];

    // Extract row-specific properties from GenericProperties if available
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start;
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;

    if (widgetModel.properties is GenericProperties) {
      final props = (widgetModel.properties as GenericProperties).properties;

      if (props['mainAxisAlignment'] != null) {
        mainAxisAlignment = _parseMainAxisAlignment(props['mainAxisAlignment']);
      }

      if (props['crossAxisAlignment'] != null) {
        crossAxisAlignment =
            _parseCrossAxisAlignment(props['crossAxisAlignment']);
      }
    }

    Widget row = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: childWidgets,
    );

    return _applyGenericPadding(row, widgetModel.properties);
  }

  static Widget _buildText(WidgetModel widgetModel) {
    final textProps = widgetModel.properties as TextProperties?;

    final String text = textProps?.text ?? '';

    TextStyle textStyle = const TextStyle();

    if (textProps?.style != null) {
      textStyle = TextStyle(
        fontSize: textProps!.style!.fontSize,
        fontWeight: _parseFontWeight(textProps.style!.fontWeight),
        color: textProps.style!.color != null
            ? _parseColor(textProps.style!.color!)
            : null,
        fontFamily: textProps.style!.fontFamily,
      );
    }

    Widget textWidget = Text(
      text,
      style: textStyle,
      key: widgetModel.id != null ? Key(widgetModel.id!) : null,
    );

    // Apply alignment
    if (textProps?.alignment != null) {
      Alignment alignmentValue = _parseAlignment(textProps!.alignment!);
      textWidget = Align(
        alignment: alignmentValue,
        child: textWidget,
      );
    }

    return _applyPadding(textWidget, textProps?.padding);
  }

   Widget _buildTextField(WidgetModel widgetModel) {
    final textFieldProps = widgetModel.properties as TextFieldProperties?;

    InputDecoration inputDecoration = const InputDecoration();

    if (textFieldProps?.decoration != null) {
      final decoration = textFieldProps!.decoration;

      if (decoration != null) {
        inputDecoration = InputDecoration(
          enabled: userAction,
          hintText: decoration.hintText,
          hintStyle: decoration.hintStyle != null
              ? TextStyle(
                  fontSize: decoration.hintStyle!.fontSize,
                  color: decoration.hintStyle!.color != null
                      ? _parseColor(decoration.hintStyle!.color!)
                      : null,
                  fontFamily: decoration.hintStyle!.fontFamily,
                  fontWeight:
                      _parseFontWeight(decoration.hintStyle!.fontWeight),
                )
              : null,
          filled: decoration.filled ?? false,
          fillColor: decoration.fillColor != null
              ? _parseColor(decoration.fillColor!)
              : null,
          border: _buildInputBorder(decoration),
          enabledBorder: _buildInputBorder(decoration),
          focusedBorder: _buildInputBorder(decoration),
          errorBorder: _buildInputBorder(decoration),
          focusedErrorBorder: _buildInputBorder(decoration),
        );
      }
    }

    Widget textField = TextField(
      decoration: inputDecoration,
      key: widgetModel.id != null ? Key(widgetModel.id!) : null,
    );

    return _applyPadding(textField, textFieldProps?.padding);
  }

  static InputBorder _buildInputBorder(InputDecorationModel decoration) {
    final borderRadius = decoration.borderRadius ?? 0;

    if (decoration.borderSide == 'none') {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      );
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: Colors.grey),
    );
  }

  static Widget _buildButton(WidgetModel widgetModel) {
    final buttonProps = widgetModel.properties as ButtonProperties?;

    final String text = buttonProps?.text ?? 'Button';
    final Color? backgroundColor = buttonProps?.backgroundColor != null
        ? _parseColor(buttonProps!.backgroundColor!)
        : null;
    final double elevation = buttonProps?.elevation ?? 2.0;

    Widget button = SizedBox(
      width: buttonProps?.width ?? double.infinity,
      // Make button full width by default
      child: ElevatedButton(
        onPressed: () {
          // Add your button action here
          print('Button pressed: $text (ID: ${widgetModel.id})');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: elevation,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    // Add key for identification
    if (widgetModel.id != null) {
      button = KeyedSubtree(
        key: Key(widgetModel.id!),
        child: button,
      );
    }

    return _applyPadding(button, buttonProps?.padding);
  }

  static Widget _buildImage(WidgetModel widgetModel) {
    final imageProps = widgetModel.properties as ImageProperties?;

    final String? url = imageProps?.url;
    final double? width = imageProps?.width;
    final double? height = imageProps?.height;
    final String? fit = imageProps?.fit;
    print("image url $url");
    if (url == null || url.isEmpty) {
      return Container(
        width: width ?? 100,
        height: height ?? 100,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image, size: 50, color: Colors.grey),
        key: widgetModel.id != null ? Key(widgetModel.id!) : null,
      );
    }

    BoxFit boxFit = BoxFit.cover;
    if (fit != null) {
      boxFit = _parseBoxFit(fit);
    }

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: boxFit,
        key: widgetModel.id != null ? Key(widgetModel.id!) : null,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;

          return Container(
            width: width ?? 100,
            height: height ?? 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? 100,
            height: height ?? 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      ),
    );

    return image;
  }

  Widget _buildContainer(WidgetModel widgetModel) {
    final List<Widget> childWidgets = widgetModel.children
            ?.map((child) => _buildWidgetModel(child))
            .toList() ??
        [];

    Widget? child;
    if (childWidgets.isNotEmpty) {
      if (childWidgets.length == 1) {
        child = childWidgets[0];
      } else {
        child = Column(children: childWidgets);
      }
    }

    // Extract container-specific properties
    Color? backgroundColor;
    double? width;
    double? height;
    EdgeInsets? margin;
    BorderRadius? borderRadius;

    if (widgetModel.properties is GenericProperties) {
      final props = (widgetModel.properties as GenericProperties).properties;

      if (props['backgroundColor'] != null) {
        backgroundColor = _parseColor(props['backgroundColor']);
      }
      if (props['width'] != null) {
        width = _parseDouble(props['width']);
      }
      if (props['height'] != null) {
        height = _parseDouble(props['height']);
      }
      if (props['margin'] != null) {
        margin = _parseEdgeInsets(props['margin']);
      }
      if (props['borderRadius'] != null) {
        borderRadius =
            BorderRadius.circular(_parseDouble(props['borderRadius']) ?? 0);
      }
    }

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
      key: widgetModel.id != null ? Key(widgetModel.id!) : null,
    );

    return _applyGenericPadding(container, widgetModel.properties);
  }

  // Helper methods
  static Widget _applyPadding(Widget widget, PaddingModel? padding) {
    if (padding == null) return widget;

    return Padding(
      padding: EdgeInsets.only(
        left: padding.left ?? 0,
        right: padding.right ?? 0,
        top: padding.top ?? 0,
        bottom: padding.bottom ?? 0,
      ),
      child: widget,
    );
  }

  static Widget _applyGenericPadding(
      Widget widget, WidgetProperties? properties) {
    // Try to extract padding from generic properties if available
    if (properties is GenericProperties) {
      final paddingData = properties.properties['padding'];
      if (paddingData != null) {
        final padding = PaddingModel.fromJson(paddingData);
        return _applyPadding(widget, padding);
      }
    }
    return widget;
  }

  static Widget _applyWidthConstraint(Widget widget, WidgetModel widgetModel) {
    // Check if width is specified in properties for supported widgets
    double? width;

    if (widgetModel.properties is GenericProperties) {
      final props = (widgetModel.properties as GenericProperties).properties;
      if (props['width'] != null) {
        width = _parseDouble(props['width']);
      }
    }

    // Apply width constraint for supported widget types
    if (width != null &&
        ['button', 'textfield', 'container'].contains(widgetModel.type)) {
      return SizedBox(
        width: width,
        child: widget,
      );
    }

    return widget;
  }

  static Color _parseColor(String colorValue) {
    try {
      // Handle different color formats
      if (colorValue.startsWith('0x')) {
        return Color(int.parse(colorValue));
      } else if (colorValue.startsWith('#')) {
        return Color(int.parse('0xff${colorValue.substring(1)}'));
      } else {
        // Assume it's hex without prefix
        return Color(int.parse('0xff$colorValue'));
      }
    } catch (e) {
      // Fallback to black if parsing fails
      return Colors.black;
    }
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static EdgeInsets? _parseEdgeInsets(dynamic value) {
    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: _parseDouble(value['left']) ?? 0,
        right: _parseDouble(value['right']) ?? 0,
        top: _parseDouble(value['top']) ?? 0,
        bottom: _parseDouble(value['bottom']) ?? 0,
      );
    }

    // If it's a single number, apply to all sides
    final doubleValue = _parseDouble(value);
    if (doubleValue != null) {
      return EdgeInsets.all(doubleValue);
    }

    return null;
  }

  static MainAxisAlignment _parseMainAxisAlignment(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spacebetween':
      case 'space-between':
        return MainAxisAlignment.spaceBetween;
      case 'spacearound':
      case 'space-around':
        return MainAxisAlignment.spaceAround;
      case 'spaceevenly':
      case 'space-evenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment _parseCrossAxisAlignment(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.center;
    }
  }

  static FontWeight _parseFontWeight(String? fontWeight) {
    if (fontWeight == null) return FontWeight.normal;

    switch (fontWeight.toLowerCase()) {
      case 'w100':
      case 'thin':
        return FontWeight.w100;
      case 'w200':
      case 'extralight':
        return FontWeight.w200;
      case 'w300':
      case 'light':
        return FontWeight.w300;
      case 'w400':
      case 'normal':
        return FontWeight.w400;
      case 'w500':
      case 'medium':
        return FontWeight.w500;
      case 'w600':
      case 'semibold':
        return FontWeight.w600;
      case 'w700':
      case 'bold':
        return FontWeight.w700;
      case 'w800':
      case 'extrabold':
        return FontWeight.w800;
      case 'w900':
      case 'black':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  static Alignment _parseAlignment(String alignment) {
    switch (alignment.toLowerCase()) {
      case 'center':
        return Alignment.center;
      case 'centerleft':
      case 'center-left':
        return Alignment.centerLeft;
      case 'centerright':
      case 'center-right':
        return Alignment.centerRight;
      case 'topcenter':
      case 'top-center':
        return Alignment.topCenter;
      case 'topleft':
      case 'top-left':
        return Alignment.topLeft;
      case 'topright':
      case 'top-right':
        return Alignment.topRight;
      case 'bottomcenter':
      case 'bottom-center':
        return Alignment.bottomCenter;
      case 'bottomleft':
      case 'bottom-left':
        return Alignment.bottomLeft;
      case 'bottomright':
      case 'bottom-right':
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }

  static BoxFit _parseBoxFit(String fit) {
    switch (fit.toLowerCase()) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitwidth':
      case 'fit-width':
        return BoxFit.fitWidth;
      case 'fitheight':
      case 'fit-height':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaledown':
      case 'scale-down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }


  Widget _buildDrawer(WidgetModel drawerModel) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: drawerModel.children?.map((child) {
          if (child.type == 'listTile') {
            return _buildListTile(child);
          }
          return _buildWidgetModel(child);
        }).toList() ?? [],
      ),
    );
  }

  Widget _buildListTile(WidgetModel listTileModel) {
    final props = listTileModel.properties as ListTileProperties?;

    return ListTile(
      leading: props?.leading != null
          ? Image.network(props!.leading!, width: 24, height: 24)
          : null,
      title: Text(props?.title ?? ''),
      onTap: () {
        // Handle list tile tap
      },
    );
  }

  PreferredSizeWidget _buildAppBar(WidgetModel appBarModel) {
    final props = appBarModel.properties as AppBarProperties?;

    Color? backgroundColor;
    Color? foregroundColor;

    if (props?.backgroundColor != null) {
      backgroundColor = _parseColor(props!.backgroundColor!);
    }
    if (props?.foregroundColor != null) {
      foregroundColor = _parseColor(props!.foregroundColor!);
    }

    Widget? title;
    if (appBarModel.children?.isNotEmpty ?? false) {
      title = _buildWidgetModel(appBarModel.children![0]);
    }

    return AppBar(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      title: title,
    );
  }

  Widget _buildBottomNavigationBar(WidgetModel bottomNavModel) {
    final items = bottomNavModel.children?.map((child) {
      if (child.type == 'bottomNavigationBarItem') {
        return _buildBottomNavigationBarItem(child);
      }
      return BottomNavigationBarItem(
        icon: Icon(Icons.error),
        label: 'Unknown',
      );
    }).toList() ?? [];

    return BottomNavigationBar(
      items: items,
      currentIndex: 0,
      onTap: (index) {
        // Handle navigation
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(WidgetModel itemModel) {
    final props = itemModel.properties as BottomNavigationBarItemProperties?;

    return BottomNavigationBarItem(
      icon: props?.icon != null
          ? Image.network(props!.icon!, width: 24, height: 24)
          : Icon(Icons.error),
      label: props?.label,
    );
  }
}
