import 'package:flutter/material.dart';

class AppThemeModel {

  static double paddingLeft = 30;
  static double paddingRight = 30;

  static Color themeBackgroundColor = const Color(0xFFFFFFFF);
  static Color themeColorSecondary = const Color(0xFF242525);
  static Color themeColorPrimary = const Color(0xFFFF0000);
  static Color backgroundTabColor = const Color(0xFFF8F8F8);
  static Color tabBarLabel = const Color(0xFF737373);

  ///TEXT STYLE DEFAULT
  static TextStyle styleDefault = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    fontFamily: '',
    color: themeColorSecondary,

  );

  static ThemeData themeApp = ThemeData(
    primaryColor: themeColorPrimary,
    scaffoldBackgroundColor: themeBackgroundColor,
    textSelectionTheme: TextSelectionThemeData(
      selectionHandleColor: themeColorPrimary,
      selectionColor: themeColorPrimary,
      cursorColor: themeColorPrimary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: themeColorSecondary),
    ),
  );

  factory AppThemeModel() => AppThemeModel._internal();
  AppThemeModel._internal();
}
