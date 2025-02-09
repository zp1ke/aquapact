import 'package:flutter/material.dart';

import 'theme.dart';

extension AppColorScheme on ColorScheme {
  Color get success {
    if (brightness == Brightness.light) {
      return Color(0xff006d6a);
    }
    return Color(0xff0b6b68);
  }

  Color get water {
    if (brightness == Brightness.light) {
      return Color(0xff0665de);
    }
    return Color(0xff1a6bd2);
  }
}
