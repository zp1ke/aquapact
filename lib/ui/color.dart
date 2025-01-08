import 'package:flutter/material.dart';

import 'theme.dart';

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

/// Success Color
const _successColor = ExtendedColor(
  seed: Color(0xff006d6a),
  value: Color(0xff006c76),
  light: ColorFamily(
    color: Color(0xff006972),
    onColor: Color(0xffffffff),
    colorContainer: Color(0xff9df0fb),
    onColorContainer: Color(0xff001f23),
  ),
  lightMediumContrast: ColorFamily(
    color: Color(0xff006972),
    onColor: Color(0xffffffff),
    colorContainer: Color(0xff9df0fb),
    onColorContainer: Color(0xff001f23),
  ),
  lightHighContrast: ColorFamily(
    color: Color(0xff006972),
    onColor: Color(0xffffffff),
    colorContainer: Color(0xff9df0fb),
    onColorContainer: Color(0xff001f23),
  ),
  dark: ColorFamily(
    color: Color(0xff81d3df),
    onColor: Color(0xff00363c),
    colorContainer: Color(0xff004f56),
    onColorContainer: Color(0xff9df0fb),
  ),
  darkMediumContrast: ColorFamily(
    color: Color(0xff81d3df),
    onColor: Color(0xff00363c),
    colorContainer: Color(0xff004f56),
    onColorContainer: Color(0xff9df0fb),
  ),
  darkHighContrast: ColorFamily(
    color: Color(0xff81d3df),
    onColor: Color(0xff00363c),
    colorContainer: Color(0xff004f56),
    onColorContainer: Color(0xff9df0fb),
  ),
);

extension AppColorScheme on ColorScheme {
  ColorFamily get success {
    if (brightness == Brightness.light) {
      if (this == AppTheme.lightScheme()) {
        return _successColor.light;
      }
      if (this == AppTheme.lightMediumContrastScheme()) {
        return _successColor.lightMediumContrast;
      }
      return _successColor.lightHighContrast;
    }
    if (this == AppTheme.darkScheme()) {
      return _successColor.dark;
    }
    if (this == AppTheme.darkMediumContrastScheme()) {
      return _successColor.darkMediumContrast;
    }
    return _successColor.darkHighContrast;
  }
}
