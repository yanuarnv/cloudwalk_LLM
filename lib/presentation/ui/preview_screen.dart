import 'package:cloudwalk_llm/gen/assets.gen.dart';
import 'package:cloudwalk_llm/gen/colors.gen.dart';
import 'package:cloudwalk_llm/helpers/layout_builder.dart';
import 'package:cloudwalk_llm/presentation/logic/layout_editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutEditorBloc, LayoutState>(
        builder: (context, state) {
      if (state.isLoading) {
        return Center(
          child: Text("Loading....."),
        );
      } else {
        print(state.data?.children.first.children?.last.toJson());
        return CustomLayoutBuilder.buildFromScaffoldEntity(state.data!);
      }
    });
  }
}

