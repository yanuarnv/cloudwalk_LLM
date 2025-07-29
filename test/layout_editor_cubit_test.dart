import 'package:bloc_test/bloc_test.dart';
import 'package:cloudwalk_llm/data/data_sources/llm_local_datasources.dart';
import 'package:cloudwalk_llm/Infrastructure/processor.dart';
import 'package:cloudwalk_llm/data/repositories/layout_editor_repository_impl.dart';
import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:cloudwalk_llm/domain/repositories/layout_editor_repository.dart';
import 'package:cloudwalk_llm/presentation/logic/layout_editor_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late LayoutEditorRepository repository;
  late LayoutEditorCubit cubit;
  late LlmLocalDatasources processor;
  late ScaffoldEntity initialState;

  setUpAll(() {
    processor = LlmLocalDatasources();
    repository = LayoutEditorRepositoryImpl(processor);
    cubit = LayoutEditorCubit(repository);
    initialState = ScaffoldEntity.fromJson({
      "type": "scaffold",
      "id": "scaffold1",
      "properties": {"background": "ffffff"},
      "children": [
        {
          "type": "column",
          "id": "column1",
          "children": [
            {
              "type": "image",
              "id": "image1",
              "properties": {
                "url":
                    "https://img.icons8.com/?size=48&id=iGqse5s20iex&format=png",
                "width": 100,
                "height": 100,
                "fit": "cover"
              }
            },
            {
              "type": "text",
              "id": "text1",
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
              "id": "textfield1",
              "properties": {
                "padding": {"left": 16, "right": 16, "top": 16},
                "decoration": {
                  "fillColor": "E8EDF5",
                  "filled": true,
                  "borderRadius": 12,
                  "borderSide": "",
                  "hintText": "Username",
                  "hintStyle": {
                    "fontSize": 17,
                    "color": "4A709C",
                    "fontFamily": "Inter"
                  }
                }
              }
            },
            {
              "type": "textfield",
              "id": "textfield2",
              "properties": {
                "padding": {"left": 16, "right": 16, "top": 16},
                "decoration": {
                  "fillColor": "E8EDF5",
                  "filled": true,
                  "borderRadius": 12,
                  "borderSide": "",
                  "hintText": "Password",
                  "hintStyle": {
                    "fontSize": 17,
                    "color": "4A709C",
                    "fontFamily": "Inter"
                  }
                }
              }
            },
            {
              "type": "text",
              "id": "text2",
              "properties": {
                "text": "Forgot Password?",
                "alignment": "centerLeft",
                "padding": {"left": 16, "top": 16},
                "style": {
                  "fontSize": 17,
                  "color": "4A709C",
                  "fontFamily": "Inter"
                }
              }
            },
            {
              "type": "button",
              "id": "button1",
              "properties": {
                "text": "Login",
                "padding": {"top": 16, "left": 16, "right": 16},
                "backgroundColor": "0D78F2",
                "elevation": 0.0
              }
            },
            {
              "type": "text",
              "id": "text3",
              "properties": {
                "text": "New User Sign Up",
                "alignment": "center",
                "padding": {"left": 16, "top": 16},
                "style": {
                  "fontSize": 17,
                  "color": "000000",
                  "fontWeight": "w700",
                  "fontFamily": "Inter"
                }
              }
            },
          ]
        }
      ]
    });
  });

  group("Testing Cubit Logic", () {
    test("Ensure Initial State", () {
      expect(cubit.state.data != null, true);
    });

    test("Ensure state data is immutable", () async {
      final result = await processor.nlpProcessing("add button", initialState);
      expect(result, isNot(equals(initialState)));
    });
  });
}
