import 'dart:ui';

import 'package:cloudwalk_llm/gen/colors.gen.dart';
import 'package:google_fonts/google_fonts.dart';

class ClTextStyle {
  static var bodyTextStyle = GoogleFonts.roboto(fontSize: 17);
  static var bodyUnSelectTextStyle = GoogleFonts.roboto(
    fontSize: 17,
    color: ColorValue.unSelected,
  );
  static var calloutTextStyle = GoogleFonts.roboto(fontSize: 16);
  static var title3TextStyle =
      GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold);
  static var title2TextStyle =
      GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold);
  static var title1TextStyle =
      GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.bold);
}
