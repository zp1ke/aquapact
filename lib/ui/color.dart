import 'package:flutter/material.dart';

extension AppColorScheme on ColorScheme {
  Color get water {
    if (brightness == Brightness.light) {
      return Color(0xff1c81d1);
    }
    return Color(0xff318ad1);
  }

  Color get deepWater {
    if (brightness == Brightness.light) {
      return Color(0xff0665de);
    }
    return Color(0xff1a6bd2);
  }

  Color get warning {
    if (brightness == Brightness.light) {
      return Color(0xffc67b1a);
    }
    return Color(0xffcc8b38);
  }
}
