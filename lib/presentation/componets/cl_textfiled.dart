import 'package:cloudwalk_llm/application/cl_text_style.dart';
import 'package:cloudwalk_llm/gen/assets.gen.dart';
import 'package:cloudwalk_llm/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CLTextField extends StatefulWidget {
  final GestureTapCallback sendPrompt;
  final TextEditingController controller;

  const CLTextField({
    super.key,
    required this.sendPrompt,
    required this.controller,
  });

  @override
  State<CLTextField> createState() => _CLTextFieldState();
}

class _CLTextFieldState extends State<CLTextField> {

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {}); // Trigger rebuild when text changes
  }

  void sendPrompt() {
    // Your action when pressing the button
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: ColorValue.secondary,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  style: ClTextStyle.bodyTextStyle,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: "Enter Command",
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 17,
                      color: ColorValue.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
             if(widget.controller.value.text.isNotEmpty) Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                    onPressed: widget.sendPrompt,
                    icon: Assets.icons.wandAndSparkles.svg()),
              ),
              SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
