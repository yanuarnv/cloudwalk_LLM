// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cloudwalk_llm/main.dart';

void main() {
  final data = {
    "type": "scaffold",
    "properties": {
      "background": "0xffffffff"
    },
    "children": [
      {
        "type": "column",
        "children": [
          {
            "type": "image",
            "properties": {
              "url": "https://img.icons8.com/?size=48&id=iGqse5s20iex&format=png",
              "width": 100,
              "height": 100,
              "fit": "cover"
            }
          },
          {
            "type": "text",
            "properties": {
              "text": "Welcome Back",
              "style": {
                "fontSize": 24,
                "fontWeight": "w700",
                "fontFamily": "Inter"
              }
            }
          },
          {
            "type": "textfield",
            "properties": {
              "padding": {
                "left": 16,
                "right": 16,
                "top": 16
              },
              "decoration": {
                "fillColor": "0xffE8EDF5",
                "filled": true,
                "borderRadius": 12,
                "borderSide": "none",
                "hintText": "Username",
                "hintStyle": {
                  "fontSize": 17,
                  "color": "0xff4A709C",
                  "fontFamily": "Inter"
                }
              }
            }
          },
          {
            "type": "textfield",
            "properties": {
              "padding": {
                "left": 16,
                "right": 16,
                "top": 16
              },
              "decoration": {
                "fillColor": "0xffE8EDF5",
                "filled": true,
                "borderRadius": 12,
                "borderSide": "none",
                "hintText": "Password",
                "hintStyle": {
                  "fontSize": 17,
                  "color": "0xff4A709C",
                  "fontFamily": "Inter"
                }
              }
            }
          },
          {
            "type": "text",
            "properties": {
              "text": "Forgot Password?",
              "alignment": "centerLeft",
              "padding": {
                "left": 16,
                "top": 16
              },
              "style": {
                "fontSize": 17,
                "color": "0xff4A709C",
                "fontFamily": "Inter"
              }
            }
          },
          {
            "type": "button",
            "properties": {
              "text": "Login",
              "padding": {
                "top": 16,
                "left": 16,
                "right": 16
              },
              "backgroundColor": "0xff0D78F2",
              "elevation": 0
            }
          },
          {
            "type": "text",
            "properties": {
              "text": "New User Sign Up",
              "alignment": "center",
              "padding": {
                "left": 16,
                "top": 16
              },
              "style": {
                "fontSize": 17,
                "color": "0xff000000",
                "fontWeight": "w700",
                "fontFamily": "Inter"
              }
            }
          }
        ]
      }
    ]
  };
  final parser = ScaffoldEntity.fromJson(data);
}
