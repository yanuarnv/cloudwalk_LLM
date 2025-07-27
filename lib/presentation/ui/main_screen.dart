import 'package:cloudwalk_llm/application/cl_text_style.dart';
import 'package:cloudwalk_llm/domain/repositories/layout_editor_repository.dart';
import 'package:cloudwalk_llm/gen/assets.gen.dart';
import 'package:cloudwalk_llm/presentation/logic/layout_editor_bloc.dart';
import 'package:cloudwalk_llm/presentation/ui/preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloudwalk_llm/gen/colors.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../componets/cl_textfiled.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final promtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutEditorBloc(
        RepositoryProvider.of<LayoutEditorRepository>(context),
      ),
      child: BlocBuilder<LayoutEditorBloc, LayoutState>(
          builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Prompt Layout Editor'),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  print("clikded");
                },
                icon: Assets.icons.lightbulbMax.svg(
                  colorFilter:
                      ColorFilter.mode(ColorValue.primary, BlendMode.srcIn),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    print("clikded");
                  },
                  icon: Assets.icons.ellipsisCircle.svg(
                    colorFilter:
                        ColorFilter.mode(ColorValue.primary, BlendMode.srcIn),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.2),
                  height: 0.5,
                ),
              ),
            ),
            body: Stack(
              children: [
                PreviewScreen(),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CLTextField(
                    controller: promtController,
                    sendPrompt: () {
                      FocusScope.of(context).unfocus();
                      context.read<LayoutEditorBloc>().add(
                            ChangeLayout(
                              promtController.text,
                              context,
                            ),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
