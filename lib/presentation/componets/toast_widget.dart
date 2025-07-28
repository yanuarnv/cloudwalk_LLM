import 'package:cloudwalk_llm/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToastWidget extends StatelessWidget {
  final String msg;

  const ToastWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(horizontal: 21),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.icons.exclamationmarkTriangle.svg(),
          const SizedBox(width: 12,),
          Expanded(
            child: Text(
              msg,
              style: GoogleFonts.inter(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
