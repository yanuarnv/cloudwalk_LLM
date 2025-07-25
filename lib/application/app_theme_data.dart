import 'package:cloudwalk_llm/application/cl_text_style.dart';
import 'package:cloudwalk_llm/gen/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CLThemeData {
  static ThemeData getTheme(BuildContext context) {
    const Color primaryColor = ColorValue.primary;
    final Map<int, Color> primaryColorMap = {
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    };
    final MaterialColor primaryMaterialColor =
    MaterialColor(primaryColor.value, primaryColorMap);

    return ThemeData(
        primaryColor: primaryColor,
        primarySwatch: primaryMaterialColor,
        scaffoldBackgroundColor: const Color(0xffF5F5F5),
        canvasColor: const Color(0xffF5F5F5),
        brightness: Brightness.light,
        iconTheme: IconThemeData(size: 21),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedLabelStyle:
            GoogleFonts.poppins(fontSize: 16, color: ColorValue.primary),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 16,
            ),
            selectedIconTheme: const IconThemeData(color: ColorValue.primary),
            unselectedIconTheme: const IconThemeData(color: Colors.black)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 45),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ))),
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: ClTextStyle.bodyTextStyle,
          unselectedLabelStyle: ClTextStyle.bodyUnSelectTextStyle,
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white, size: 21),
          elevation: 0,
          backgroundColor: Colors.white,
          titleTextStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: Colors.black
          ),
          toolbarTextStyle:ClTextStyle.bodyTextStyle,
        ),
        textTheme: GoogleFonts.robotoTextTheme());
  }
}