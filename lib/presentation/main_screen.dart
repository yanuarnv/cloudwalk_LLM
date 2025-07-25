import 'package:cloudwalk_llm/application/cl_text_style.dart';
import 'package:cloudwalk_llm/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloudwalk_llm/gen/colors.gen.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Prompt Layout Editor'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            print("clikded");
          },
          icon: Assets.icons.lightbulbMax.svg(
            colorFilter: ColorFilter.mode(ColorValue.primary, BlendMode.srcIn),
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
      body: Column(
        children: [
          Image.network(
            "https://img.icons8.com/?size=48&id=iGqse5s20iex&format=png",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Text(
            "Welcome Back",
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: TextField(
              decoration: InputDecoration(
                fillColor: Color(0xffE8EDF5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Username",
                hintStyle:
                    GoogleFonts.inter(fontSize: 17, color: Color(0xff4A709C)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
            ),
            child: TextField(
              decoration: InputDecoration(
                fillColor: Color(0xffE8EDF5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: "Password",
                hintStyle:
                    GoogleFonts.inter(fontSize: 17, color: Color(0xff4A709C)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
              ),
              child: Text(
                "Forgot Password?",
                style:
                    GoogleFonts.inter(fontSize: 17, color: Color(0xff4A709C)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Color(0xff0D78F2)),
              onPressed: () {},
              child: Text(
                "Login",
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 16,
              ),
              child: Text(
                "New User Sign Up",
                style: GoogleFonts.inter(
                  fontSize: 17,
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
