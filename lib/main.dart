import 'package:cloudwalk_llm/application/app_theme_data.dart';
import 'package:cloudwalk_llm/presentation/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CLThemeData.getTheme(context),
      home: MainScreen()
    );
  }
}
