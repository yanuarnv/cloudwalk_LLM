import 'package:cloudwalk_llm/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ToastType { error, warning }

class ToastWidget extends StatelessWidget {
  final String msg;
  final ToastType type;

  const ToastWidget({super.key, required this.msg, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ToastType.error:
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
              const SizedBox(
                width: 12,
              ),
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
      case ToastType.warning:
        return Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 21),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.icons.exclamationmarkTriangle.svg(
                colorFilter: ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  msg,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }
}
