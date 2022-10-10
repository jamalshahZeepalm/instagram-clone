

import 'package:flutter/material.dart';

import 'colors.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: CustomColors.mobileBackgroundColor,
    drawerTheme: DrawerThemeData(
      backgroundColor: CustomColors.mobileBackgroundColor,
    ),
     
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.transparent),
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
 
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    scaffoldBackgroundColor: CustomColors.mobileBackgroundColor,
    drawerTheme: DrawerThemeData(
      backgroundColor: CustomColors.mobileBackgroundColor,
    ),
    colorScheme: const ColorScheme.dark(),
  );
}