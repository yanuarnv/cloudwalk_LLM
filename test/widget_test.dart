// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cloudwalk_llm/main.dart';

void main() {
  final json ="{\"type\":\"scaffold\",\"id\":\"scaffold1\",\"properties\":{\"background\":\"ff0000\"},\"children\":[{\"type\":\"column\",\"id\":\"column1\",\"children\":[{\"type\":\"image\",\"id\":\"image1\",\"properties\":{\"url\":\"https://img.icons8.com/?size=48&id=iGqse5v20iex&format=png\",\"width\":100,\"height\":100,\"fit\":\"cover\"}},{\"type\":\"text\",\"id\":\"text1\",\"properties\":{\"text\":\"Welcome Back\",\"style\":{\"fontSize\":24,\"fontWeight\":\"w700\",\"fontFamily\":\"Inter\"}}},{\"type\":\"textfield\",\"id\":\"textfield1\",\"properties\":{\"padding\":{\"left\":16,\"right\":16,\"top\":16},\"decoration\":{\"fillColor\":\"E8EDF5\",\"filled\":true,\"borderRadius\":12,\"borderSide\":\"\",\"hintText\":\"Username\",\"hintStyle\":{\"fontSize\":17,\"color\":\"4A709C\",\"fontFamily\":\"Inter\"}}}},{\"type\":\"textfield\",\"id\":\"textfield2\",\"properties\":{\"padding\":{\"left\":16,\"right\":16,\"top\":16},\"decoration\":{\"fillColor\":\"E8EDF5\",\"filled\":true,\"borderRadius\":12,\"borderSide\":\"\",\"hintText\":\"Password\",\"hintStyle\":{\"fontSize\":17,\"color\":\"4A709C\",\"fontFamily\":\"Inter\"}}}},{\"type\":\"text\",\"id\":\"text2\",\"properties\":{\"text\":\"Forgot Password?\",\"alignment\":\"centerLeft\",\"padding\":{\"left\":16,\"top\":16},\"style\":{\"fontSize\":17,\"color\":\"4A709C\",\"fontFamily\":\"Inter\"}}},{\"type\":\"button\",\"id\":\"button1\",\"properties\":{\"text\":\"Login\",\"padding\":{\"top\":16,\"left\":16,\"right\":16},\"backgroundColor\":\"0D78F2\",\"elevation\":0.0}},{\"type\":\"text\",\"id\":\"text3\",\"properties\":{\"text\":\"New User Sign Up\",\"alignment\":\"center\",\"padding\":{\"left\":16,\"top\":16},\"style\":{\"fontSize\":17,\"color\":\"000000\",\"fontWeight\":\"w700\",\"fontFamily\":\"Inter\"}}}]}]}";
 final decodeJson = jsonDecode(json);
  final model = ScaffoldEntity.fromJson(decodeJson);
  print(model.properties?.background);
}
