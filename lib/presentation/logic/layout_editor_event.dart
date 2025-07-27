part of 'layout_editor_bloc.dart';


abstract class LayoutEditorEvent extends ReplayEvent{
}

class ChangeLayout extends LayoutEditorEvent {
  final String prompt;
  final BuildContext context;
  ChangeLayout(this.prompt, this.context);
}

