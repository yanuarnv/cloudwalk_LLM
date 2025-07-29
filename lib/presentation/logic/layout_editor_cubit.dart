import 'package:cloudwalk_llm/application/failure.dart';
import 'package:cloudwalk_llm/domain/entities/scaffold_entity.dart';
import 'package:cloudwalk_llm/domain/repositories/layout_editor_repository.dart';
import 'package:cloudwalk_llm/presentation/componets/toast_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:replay_bloc/replay_bloc.dart';

part 'layout_editor_state.dart';

class LayoutEditorCubit extends ReplayCubit<LayoutState> {
  final LayoutEditorRepository _repository;

  LayoutEditorCubit(this._repository)
      : super(LayoutState(data: _getInitialData(),isLoading: false));

  void changeLayout(String prompt) async {
    emit(state.copyWith(isLoading: true));
    final data = await _repository.changeLayout(prompt, state.data!);
    data.fold(
      (l) {
        emit(state.copyWith(isLoading: false));
        if (l is ServerFailure) {
          showToastWidget(
            ToastWidget(
              msg: l.msg,
              type: ToastType.error,
            ),
            position: ToastPosition.top,
          );
        }
        if (l is InternalFailure) {}
      },
      (r) {
        emit(state.copyWith(data: r,isLoading: false));
      },
    );
  }

  void reset() {
    emit(LayoutState(data: _getInitialData()));
  }

  static ScaffoldEntity _getInitialData() {
    return ScaffoldEntity.fromJson({
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
                    "https://picsum.photos/100/100",
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
            }
          ]
        }
      ]
    });
  }
}
