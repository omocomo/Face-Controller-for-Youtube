import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:face_controller_for_youtube/screens/home_page.dart';
import 'package:face_controller_for_youtube/utils/theme_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    // 테마(밝음/어두움) 설정
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FACE CONTROLLER',
      theme: lightThemeData,
      darkTheme: darkThemeData,
      debugShowCheckedModeBanner: false,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: HomePage(0),
    );
  }
}