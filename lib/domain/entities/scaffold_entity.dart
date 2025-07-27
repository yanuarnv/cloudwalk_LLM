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
    return {
      'type': type,
      'properties': properties?.toJson(),
      'children': children.map((child) => child.toJson()).toList(),
    };
  }

  static ScaffoldEntity fromJsonString(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return ScaffoldEntity.fromJson(json);
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}

// Scaffold Properties Model
class ScaffoldProperties {
  String background;

  ScaffoldProperties({this.background = 'ffffff'});

  factory ScaffoldProperties.fromJson(Map<String, dynamic> json) {
    return ScaffoldProperties(
      background: json['background'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'background': background,
    };
  }
}

// Base Widget Model
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
      id: json['id'],
      type: json['type'],
      properties: json['properties'] != null
          ? WidgetProperties.fromJson(json['properties'], json['type'])
          : null,
      children: (json['children'] as List<dynamic>?)
          ?.map((child) => WidgetModel.fromJson(child))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'type': type,
      'id':id
    };

    if (properties != null) {
      result['properties'] = properties!.toJson();
    }

    if (children != null) {
      result['children'] = children!.map((child) => child.toJson()).toList();
    }

    return result;
  }

  static WidgetProperties defaultProperties(String type) {
    switch (type) {
      case 'image':
        return ImageProperties(
            url: "https://img.icons8.com/?size=48&id=iGqse5s20iex&format=png",
            width: 100,
            height: 100,
            fit: "cover");
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
              )),
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

// Widget Properties Base Class
abstract class WidgetProperties {
  Map<String, dynamic> toJson();

  static WidgetProperties fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'image':
        return ImageProperties.fromJson(json);
      case 'text':
        return TextProperties.fromJson(json);
      case 'textfield':
        return TextFieldProperties.fromJson(json);
      case 'button':
        return ButtonProperties.fromJson(json);
      default:
        return GenericProperties.fromJson(json);
    }
  }
}

// Image Properties
class ImageProperties extends WidgetProperties {
   String? url;
   double? width;
   double? height;
   String? fit;

  ImageProperties({
    this.url,
    this.width,
    this.height,
    this.fit,
  });

  factory ImageProperties.fromJson(Map<String, dynamic> json) {
    return ImageProperties(
      url: json['url'],
      width: json['width']?.toDouble(),
      height: json['height']?.toDouble(),
      fit: json['fit'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
      'fit': fit,
    };
  }
}

// Text Properties
class TextProperties extends WidgetProperties {
  String? text;
  String? alignment;
  PaddingModel? padding;
  TextStyleModel? style;

  TextProperties({
    this.text,
    this.alignment,
    this.padding,
    this.style,
  });

  factory TextProperties.fromJson(Map<String, dynamic> json) {
    return TextProperties(
      text: json['text'],
      alignment: json['alignment'],
      padding: json['padding'] != null
          ? PaddingModel.fromJson(json['padding'])
          : null,
      style: json['style'] != null
          ? TextStyleModel.fromJson(json['style'])
          : TextStyleModel.defaultStyle,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'alignment': alignment,
      'padding': padding?.toJson(),
      'style': style?.toJson(),
    };
  }
}

// TextField Properties
class TextFieldProperties extends WidgetProperties {
  PaddingModel? padding;
  InputDecorationModel? decoration;

  TextFieldProperties({
    this.padding,
    this.decoration,
  });

  factory TextFieldProperties.fromJson(Map<String, dynamic> json) {
    return TextFieldProperties(
      padding: json['padding'] != null
          ? PaddingModel.fromJson(json['padding'])
          : null,
      decoration: json['decoration'] != null
          ? InputDecorationModel.fromJson(json['decoration'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'padding': padding?.toJson(),
      'decoration': decoration?.toJson(),
    };
  }
}

// Button Properties
class ButtonProperties extends WidgetProperties {
  String? text;
  PaddingModel? padding;
  String? backgroundColor;
  double? elevation;

  ButtonProperties({
    this.text = "Text",
    this.padding,
    this.backgroundColor = "0D78F2",
    this.elevation = 0.0,
  });

  factory ButtonProperties.fromJson(Map<String, dynamic> json) {
    return ButtonProperties(
      text: json['text'],
      padding: json['padding'] != null
          ? PaddingModel.fromJson(json['padding'])
          : null,
      backgroundColor: json['backgroundColor'],
      elevation: json['elevation'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'padding': padding?.toJson(),
      'backgroundColor': backgroundColor,
      'elevation': elevation,
    };
  }
}

// Generic Properties for unknown types
class GenericProperties extends WidgetProperties {
  final Map<String, dynamic> properties;

  GenericProperties({required this.properties});

  factory GenericProperties.fromJson(Map<String, dynamic> json) {
    return GenericProperties(properties: json);
  }

  @override
  Map<String, dynamic> toJson() {
    return properties;
  }
}

// Supporting Models
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
      left: json['left']?.toDouble(),
      right: json['right']?.toDouble(),
      top: json['top']?.toDouble(),
      bottom: json['bottom']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'right': right,
      'top': top,
      'bottom': bottom,
    };
  }
}

class TextStyleModel {
  double? fontSize;
  String? fontWeight;
  String? fontFamily;
  String? color;

  TextStyleModel({
    this.fontSize,
    this.fontWeight,
    this.fontFamily = "inter",
    this.color,
  });

  factory TextStyleModel.fromJson(Map<String, dynamic> json) {
    return TextStyleModel(
      fontSize: json['fontSize']?.toDouble(),
      fontWeight: json['fontWeight'],
      fontFamily: json['fontFamily'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'fontFamily': fontFamily,
      'color': color,
    };
  }

  static TextStyleModel get defaultStyle => TextStyleModel(
        fontSize: 14,
        fontWeight: "normal",
        fontFamily: "Inter",
        color: "000000",
      );
}

class InputDecorationModel {
  String? fillColor;
  bool? filled;
  double? borderRadius;
  String? borderSide;
  String? hintText;
  TextStyleModel? hintStyle;

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
      filled: json['filled'],
      borderRadius: json['borderRadius']?.toDouble(),
      borderSide: json['borderSide'],
      hintText: json['hintText'],
      hintStyle: json['hintStyle'] != null
          ? TextStyleModel.fromJson(json['hintStyle'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fillColor': fillColor,
      'filled': filled,
      'borderRadius': borderRadius,
      'borderSide': borderSide,
      'hintText': hintText,
      'hintStyle': hintStyle?.toJson(),
    };
  }

  static InputDecorationModel get defaultStyle => InputDecorationModel(
        fillColor: "E8EDF5",
        filled: true,
        borderRadius: 12,
        borderSide: "none",
        hintText: "this is text hint",
        hintStyle: TextStyleModel(
            fontWeight: "normal",
            fontSize: 17,
            color: "4A709C",
            fontFamily: "inter"),
      );
}
