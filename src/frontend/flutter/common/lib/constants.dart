library common;

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(

    colorScheme: ColorScheme.fromSeed(brightness: Brightness.light,seedColor: Colors.blue)
  );

  static void setBrightness(Brightness brigthness){
    theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(brightness: brigthness,seedColor: Colors.blue)
    );
  }

}
