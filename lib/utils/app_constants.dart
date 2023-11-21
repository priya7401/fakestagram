import 'package:flutter/material.dart';

class AppConstants {
  static Color? primaryColor = Colors.pink[100];
}

MaterialColor swatchify(MaterialColor color, int value) {
  return MaterialColor(color[value].hashCode, <int, Color>{
    50: color[value]!,
    100: color[value]!,
    200: color[value]!,
    300: color[value]!,
    400: color[value]!,
    500: color[value]!,
    600: color[value]!,
    700: color[value]!,
    800: color[value]!,
    900: color[value]!,
  });
}

enum AppScreens { singIn, home }
