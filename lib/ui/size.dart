import 'package:flutter/material.dart';

class AppSize {
  const AppSize._();

  static const spacingMedium = 12.0;
  static const spacingLarge = 24.0;
  static const spacing4Xl = spacingLarge * 4;

  static final padding2_4Xl = EdgeInsets.symmetric(
    horizontal: spacingLarge * 2,
    vertical: spacingLarge * 4,
  );
}
