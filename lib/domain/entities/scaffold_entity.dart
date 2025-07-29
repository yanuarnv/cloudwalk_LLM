import 'dart:convert';

class ScaffoldEntity {
  final String type;
  final ScaffoldProperties? properties;
  final List<WidgetModel> children;

  ScaffoldEntity({
    required this.type,
    this.properties,
    required this.children,
  });

  factory ScaffoldEntity.fromJson(Map<String, dynamic> json) {
    return ScaffoldEntity(
      type: json['type'] ?? '',
      properties: json['properties'] != null
          ? ScaffoldProperties.fromJson(json['properties'])
          : null,
      children: (json['children'] as List<dynamic>?)
          ?.map((child) => WidgetModel.fromJson(child))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'children': children.map((child) => child.toJson()).toList(),
    };

    if (properties != null) {
      data['properties'] = properties!.toJson();
    }

    return data;
  }

  static ScaffoldEntity fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ScaffoldEntity.fromJson(json);
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

class ScaffoldProperties {
  final dynamic background;
  final Map<String, dynamic>? appBar;

  ScaffoldProperties({this.background, this.appBar});

  factory ScaffoldProperties.fromJson(Map<String, dynamic> json) {
    return ScaffoldProperties(
      background: json['background'],
      appBar: json['appBar'] is Map ? Map<String, dynamic>.from(json['appBar']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (background != null) {
      data['background'] = background is String
          ? background
          : background.toString();
    }

    if (appBar != null) {
      data['appBar'] = Map<String, dynamic>.from(appBar!);
    }

    return data;
  }
}

class WidgetModel {
  final String type;
  final String id;
  final WidgetProperties? properties;
  final List<WidgetModel>? children;

  WidgetModel({
    required this.type,
    required this.id,
    this.properties,
    this.children,
  });

  factory WidgetModel.fromJson(Map<String, dynamic> json) {
    return WidgetModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      properties: json['properties'] != null
          ? WidgetProperties.fromJson(
          json['properties'] is Map
              ? Map<String, dynamic>.from(json['properties'])
              : {},
          json['type']?.toString() ?? '')
          : null,
      children: (json['children'] as List<dynamic>?)
          ?.map((child) => WidgetModel.fromJson(child))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'id': id,
    };

    if (properties != null) {
      data['properties'] = properties!.toJson();
    }

    if (children != null && children!.isNotEmpty) {
      data['children'] = children!.map((child) => child.toJson()).toList();
    }

    return data;
  }

  static WidgetProperties defaultProperties(String type) {
    switch (type) {
      case 'image':
        return ImageProperties(
            url: "https://img.icons8.com/?size=48&id=iGqse5s20iex&format=png",
            width: 100,
            height: 100,
            fit: "cover"
        );
      case 'text':
        return TextProperties(
          text: "this is text",
          alignment: "center",
          style: TextStyleModel.defaultStyle,
        );
      case 'textfield':
        return TextFieldProperties(
          padding: PaddingModel(left: 16),
          decoration: InputDecorationModel(
            filled: true,
            fillColor: "E8EDF5",
            hintText: "this is text hint",
            borderSide: "none",
            borderRadius: 12,
            hintStyle: TextStyleModel(
              fontSize: 17,
              fontFamily: "Inter",
              fontWeight: "normal",
              color: "4A709C",
            ),
          ),
        );
      case 'button':
        return ButtonProperties();
      default:
        return TextProperties(
          text: "Unknown Widget",
          alignment: "center",
          style: TextStyleModel(
            fontSize: 17,
            fontWeight: "normal",
            color: "FF0000",
          ),
        );
    }
  }
}

abstract class WidgetProperties {
  Map<String, dynamic> toJson();

  static WidgetProperties fromJson(Map<String, dynamic> json, String type) {
    try {
      switch (type) {
        case 'image':
          return ImageProperties.fromJson(json);
        case 'text':
          return TextProperties.fromJson(json);
        case 'textfield':
          return TextFieldProperties.fromJson(json);
        case 'button':
          return ButtonProperties.fromJson(json);
        case 'drawer':
          return DrawerProperties();
        case 'listTile':
          return ListTileProperties.fromJson(json);
        case 'appBar':
          return AppBarProperties.fromJson(json);
        case 'bottomNavigationBar':
          return BottomNavigationBarProperties();
        case 'bottomNavigationBarItem':
          return BottomNavigationBarItemProperties.fromJson(json);
        default:
          return GenericProperties.fromJson(json);
      }
    } catch (e) {
      return GenericProperties.fromJson(json);
    }
  }
}

class ImageProperties extends WidgetProperties {
  final String? url;
  final double? width;
  final double? height;
  final String? fit;

  ImageProperties({
    this.url,
    this.width,
    this.height,
    this.fit,
  });

  factory ImageProperties.fromJson(Map<String, dynamic> json) {
    return ImageProperties(
      url: json['url']?.toString(),
      width: _parseDouble(json['width']),
      height: _parseDouble(json['height']),
      fit: json['fit']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (url != null) data['url'] = url;
    if (width != null) data['width'] = width;
    if (height != null) data['height'] = height;
    if (fit != null) data['fit'] = fit;

    return data;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class TextProperties extends WidgetProperties {
  final String? text;
  final String? alignment;
  final PaddingModel? padding;
  final TextStyleModel? style;

  TextProperties({
    this.text,
    this.alignment,
    this.padding,
    this.style,
  });

  factory TextProperties.fromJson(Map<String, dynamic> json) {
    return TextProperties(
      text: json['text']?.toString(),
      alignment: json['alignment']?.toString(),
      padding: json['padding'] is Map
          ? PaddingModel.fromJson(Map<String, dynamic>.from(json['padding']))
          : null,
      style: json['style'] is Map
          ? TextStyleModel.fromJson(Map<String, dynamic>.from(json['style']))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (text != null) data['text'] = text;
    if (alignment != null) data['alignment'] = alignment;
    if (padding != null) data['padding'] = padding!.toJson();
    if (style != null) data['style'] = style!.toJson();

    return data;
  }
}

class TextFieldProperties extends WidgetProperties {
  final PaddingModel? padding;
  final InputDecorationModel? decoration;

  TextFieldProperties({
    this.padding,
    this.decoration,
  });

  factory TextFieldProperties.fromJson(Map<String, dynamic> json) {
    return TextFieldProperties(
      padding: json['padding'] is Map
          ? PaddingModel.fromJson(Map<String, dynamic>.from(json['padding']))
          : null,
      decoration: json['decoration'] is Map
          ? InputDecorationModel.fromJson(Map<String, dynamic>.from(json['decoration']))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (padding != null) data['padding'] = padding!.toJson();
    if (decoration != null) data['decoration'] = decoration!.toJson();

    return data;
  }
}

class ButtonProperties extends WidgetProperties {
  final String? text;
  final double width;
  final PaddingModel? padding;
  final dynamic backgroundColor;
  final double? elevation;
  final WidgetModel? child;

  ButtonProperties({
    this.text = "Text",
    this.width = double.infinity,
    this.padding,
    this.backgroundColor = "0D78F2",
    this.elevation = 0.0,
    this.child,
  });

  factory ButtonProperties.fromJson(Map<String, dynamic> json) {
    return ButtonProperties(
      text: json['text']?.toString(),
      padding: json['padding'] is Map
          ? PaddingModel.fromJson(Map<String, dynamic>.from(json['padding']))
          : null,
      backgroundColor: json['backgroundColor'],
      elevation: _parseDouble(json['elevation']),
      child: json['child'] is Map
          ? WidgetModel.fromJson(Map<String, dynamic>.from(json['child']))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'width': width,
    };

    if (text != null) data['text'] = text;
    if (padding != null) data['padding'] = padding!.toJson();
    if (backgroundColor != null) data['backgroundColor'] = backgroundColor;
    if (elevation != null) data['elevation'] = elevation;
    if (child != null) data['child'] = child!.toJson();

    return data;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class GenericProperties extends WidgetProperties {
  final Map<String, dynamic> properties;

  GenericProperties({required this.properties});

  factory GenericProperties.fromJson(Map<String, dynamic> json) {
    return GenericProperties(
      properties: json is Map ? Map<String, dynamic>.from(json) : {},
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(properties);
  }
}

class PaddingModel {
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  PaddingModel({
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  factory PaddingModel.fromJson(Map<String, dynamic> json) {
    return PaddingModel(
      left: _parseDouble(json['left']),
      right: _parseDouble(json['right']),
      top: _parseDouble(json['top']),
      bottom: _parseDouble(json['bottom']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (left != null) data['left'] = left;
    if (right != null) data['right'] = right;
    if (top != null) data['top'] = top;
    if (bottom != null) data['bottom'] = bottom;

    return data;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class TextStyleModel {
  final double? fontSize;
  final String? fontWeight;
  final String? fontFamily;
  final dynamic color;

  TextStyleModel({
    this.fontSize,
    this.fontWeight,
    this.fontFamily = "inter",
    this.color,
  });

  factory TextStyleModel.fromJson(Map<String, dynamic> json) {
    return TextStyleModel(
      fontSize: _parseDouble(json['fontSize']),
      fontWeight: json['fontWeight']?.toString(),
      fontFamily: json['fontFamily']?.toString(),
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'fontFamily': fontFamily ?? "inter",
    };

    if (fontSize != null) data['fontSize'] = fontSize;
    if (fontWeight != null) data['fontWeight'] = fontWeight;
    if (color != null) data['color'] = color;

    return data;
  }

  static TextStyleModel get defaultStyle => TextStyleModel(
    fontSize: 14,
    fontWeight: "normal",
    fontFamily: "Inter",
    color: "000000",
  );

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class InputDecorationModel {
  final dynamic fillColor;
  final bool? filled;
  final double? borderRadius;
  final String? borderSide;
  final String? hintText;
  final TextStyleModel? hintStyle;

  InputDecorationModel({
    this.fillColor,
    this.filled,
    this.borderRadius,
    this.borderSide,
    this.hintText,
    this.hintStyle,
  });

  factory InputDecorationModel.fromJson(Map<String, dynamic> json) {
    return InputDecorationModel(
      fillColor: json['fillColor'],
      filled: json['filled'] is bool ? json['filled'] : null,
      borderRadius: _parseDouble(json['borderRadius']),
      borderSide: json['borderSide']?.toString(),
      hintText: json['hintText']?.toString(),
      hintStyle: json['hintStyle'] is Map
          ? TextStyleModel.fromJson(Map<String, dynamic>.from(json['hintStyle']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (fillColor != null) data['fillColor'] = fillColor;
    if (filled != null) data['filled'] = filled;
    if (borderRadius != null) data['borderRadius'] = borderRadius;
    if (borderSide != null) data['borderSide'] = borderSide;
    if (hintText != null) data['hintText'] = hintText;
    if (hintStyle != null) data['hintStyle'] = hintStyle!.toJson();

    return data;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class DrawerProperties extends WidgetProperties {
  @override
  Map<String, dynamic> toJson() => {};
}

class ListTileProperties extends WidgetProperties {
  final String? title;
  final String? leading;

  ListTileProperties({this.title, this.leading});

  factory ListTileProperties.fromJson(Map<String, dynamic> json) {
    return ListTileProperties(
      title: json['title']?.toString(),
      leading: json['leading']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (leading != null) data['leading'] = leading;

    return data;
  }
}

class AppBarProperties extends WidgetProperties {
  final dynamic backgroundColor;
  final dynamic foregroundColor;
  final WidgetModel? title;

  AppBarProperties({
    this.backgroundColor,
    this.foregroundColor,
    this.title,
  });

  factory AppBarProperties.fromJson(Map<String, dynamic> json) {
    return AppBarProperties(
      backgroundColor: json['backgroundColor'],
      foregroundColor: json['foregroundColor'],
      title: json['title'] is Map
          ? WidgetModel.fromJson(Map<String, dynamic>.from(json['title']))
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (backgroundColor != null) data['backgroundColor'] = backgroundColor;
    if (foregroundColor != null) data['foregroundColor'] = foregroundColor;
    if (title != null) data['title'] = title!.toJson();

    return data;
  }
}

class BottomNavigationBarProperties extends WidgetProperties {
  @override
  Map<String, dynamic> toJson() => {};
}

class BottomNavigationBarItemProperties extends WidgetProperties {
  final String? icon;
  final String? label;

  BottomNavigationBarItemProperties({this.icon, this.label});

  factory BottomNavigationBarItemProperties.fromJson(Map<String, dynamic> json) {
    return BottomNavigationBarItemProperties(
      icon: json['icon']?.toString(),
      label: json['label']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (icon != null) data['icon'] = icon;
    if (label != null) data['label'] = label;

    return data;
  }
}