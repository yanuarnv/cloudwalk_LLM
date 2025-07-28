import 'package:cloudwalk_llm/application/cl_text_style.dart';
import 'package:cloudwalk_llm/domain/repositories/layout_editor_repository.dart';
import 'package:cloudwalk_llm/gen/assets.gen.dart';
import 'package:cloudwalk_llm/helpers/layout_builder.dart';
import 'package:cloudwalk_llm/presentation/componets/toast_widget.dart';
import 'package:cloudwalk_llm/presentation/logic/layout_editor_cubit.dart';
import 'package:cloudwalk_llm/presentation/ui/preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cloudwalk_llm/gen/colors.gen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';

import '../componets/cl_textfiled.dart';

enum Menu { preview, undo, redo, reset }

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final promtController = TextEditingController();
  final _showIdWidget = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutEditorCubit(
        RepositoryProvider.of<LayoutEditorRepository>(context),
      ),
      child: BlocBuilder<LayoutEditorCubit, LayoutState>(
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
                  _showIdWidget.value = !_showIdWidget.value;
                },
                icon: ValueListenableBuilder(
                    valueListenable: _showIdWidget,
                    builder: (context, value, _) {
                      return value
                          ? Assets.icons.lightbulbMaxFill.svg(
                              colorFilter: ColorFilter.mode(
                                  ColorValue.primary, BlendMode.srcIn),
                            )
                          : Assets.icons.lightbulbMax.svg(
                              colorFilter: ColorFilter.mode(
                                  ColorValue.primary, BlendMode.srcIn),
                            );
                    }),
              ),
              actions: [
                _buildActionMenu(context),
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
                CustomLayoutBuilder(
                        showWidgetIdListenable: _showIdWidget,
                        userAction: false)
                    .buildFromScaffoldEntity(state.data!),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CLTextField(
                    controller: promtController,
                    sendPrompt: () {
                      FocusScope.of(context).unfocus();
                      context
                          .read<LayoutEditorCubit>()
                          .changeLayout(promtController.text, context);
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

  Padding _buildActionMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: PopupMenuButton<Menu>(
        onSelected: (value) {
          switch (value) {
            case Menu.preview:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PreviewScreen(
                    showWidgetIdListenable: _showIdWidget,
                    blocProvider: context,
                  ),
                ),
              );
              break;
            case Menu.undo:
              if (context.read<LayoutEditorCubit>().canUndo) {
                context.read<LayoutEditorCubit>().undo();
              } else {
                showToastWidget(
                  ToastWidget(
                    msg: "No Undo History",
                    type: ToastType.warning,
                  ),
                  position: ToastPosition.top,
                );
              }
              break;
            case Menu.redo:
              if (context.read<LayoutEditorCubit>().canRedo) {
                context.read<LayoutEditorCubit>().redo();
              } else {
                showToastWidget(
                  ToastWidget(
                    msg: "No Redo History",
                    type: ToastType.warning,
                  ),
                  position: ToastPosition.top,
                );
              }
            default:
              _showResetDialog(context);
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<Menu>(
            value: Menu.preview,
            child: ListTile(
              trailing: Icon(Icons.visibility_outlined),
              title: Text(
                "Preview Layout  ",
                style: ClTextStyle.bodyTextStyle,
              ),
            ),
          ),
          PopupMenuItem<Menu>(
            value: Menu.undo,
            child: ListTile(
              trailing: Icon(Icons.undo),
              title: Text(
                "Undo",
                style: ClTextStyle.bodyTextStyle,
              ),
            ),
          ),
          PopupMenuItem<Menu>(
            value: Menu.redo,
            child: ListTile(
              trailing: Icon(Icons.redo),
              title: Text(
                "Redo",
                style: ClTextStyle.bodyTextStyle,
              ),
            ),
          ),
          PopupMenuItem<Menu>(
            value: Menu.reset,
            child: ListTile(
              trailing: Icon(Icons.restart_alt),
              title: Text(
                "Reset",
                style: ClTextStyle.bodyTextStyle,
              ),
            ),
          ),
        ],
        icon: Assets.icons.ellipsisCircle.svg(
          colorFilter: ColorFilter.mode(ColorValue.primary, BlendMode.srcIn),
        ),
      ),
    );
  }

  Future<void> _showResetDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) {
        return AlertDialog(
          title: const Text('Reset Layout?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'This action will restore the layout to its default state. Any unsaved changes will be lost.Are you sure you want to continue?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                context.read<LayoutEditorCubit>().reset();
                context.read<LayoutEditorCubit>().clearHistory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
