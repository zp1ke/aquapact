import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final TextTheme textTheme;

  AppTheme(BuildContext context) : textTheme = _createTextTheme(context) {
    GoogleFonts.config.allowRuntimeFetching = false;
  }

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff36618e),
      surfaceTint: Color(0xff36618e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd2e4ff),
      onPrimaryContainer: Color(0xff001d36),
      secondary: Color(0xff535f70),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd7e3f8),
      onSecondaryContainer: Color(0xff101c2b),
      tertiary: Color(0xff6b5778),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff3daff),
      onTertiaryContainer: Color(0xff251431),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff43474e),
      outline: Color(0xff73777f),
      outlineVariant: Color(0xffc3c6cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3135),
      inversePrimary: Color(0xffa1cafd),
      primaryFixed: Color(0xffd2e4ff),
      onPrimaryFixed: Color(0xff001d36),
      primaryFixedDim: Color(0xffa1cafd),
      onPrimaryFixedVariant: Color(0xff1a4975),
      secondaryFixed: Color(0xffd7e3f8),
      onSecondaryFixed: Color(0xff101c2b),
      secondaryFixedDim: Color(0xffbbc7db),
      onSecondaryFixedVariant: Color(0xff3b4858),
      tertiaryFixed: Color(0xfff3daff),
      onTertiaryFixed: Color(0xff251431),
      tertiaryFixedDim: Color(0xffd7bee4),
      onTertiaryFixedVariant: Color(0xff523f5f),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff154571),
      surfaceTint: Color(0xff36618e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4e77a6),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff384454),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff697587),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4e3b5b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff826d8f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff3f434a),
      outline: Color(0xff5b5f67),
      outlineVariant: Color(0xff777b83),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3135),
      inversePrimary: Color(0xffa1cafd),
      primaryFixed: Color(0xff4e77a6),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff345e8c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff697587),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff515d6e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff826d8f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff695475),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002341),
      surfaceTint: Color(0xff36618e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff154571),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff172332),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff384454),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2c1b38),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4e3b5b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff20242b),
      outline: Color(0xff3f434a),
      outlineVariant: Color(0xff3f434a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3135),
      inversePrimary: Color(0xffe2edff),
      primaryFixed: Color(0xff154571),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff002e53),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff384454),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff212e3d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4e3b5b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff372544),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa1cafd),
      surfaceTint: Color(0xffa1cafd),
      onPrimary: Color(0xff003259),
      primaryContainer: Color(0xff1a4975),
      onPrimaryContainer: Color(0xffd2e4ff),
      secondary: Color(0xffbbc7db),
      onSecondary: Color(0xff253140),
      secondaryContainer: Color(0xff3b4858),
      onSecondaryContainer: Color(0xffd7e3f8),
      tertiary: Color(0xffd7bee4),
      onTertiary: Color(0xff3b2947),
      tertiaryContainer: Color(0xff523f5f),
      onTertiaryContainer: Color(0xfff3daff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111418),
      onSurface: Color(0xffe1e2e8),
      onSurfaceVariant: Color(0xffc3c6cf),
      outline: Color(0xff8d9199),
      outlineVariant: Color(0xff43474e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff36618e),
      primaryFixed: Color(0xffd2e4ff),
      onPrimaryFixed: Color(0xff001d36),
      primaryFixedDim: Color(0xffa1cafd),
      onPrimaryFixedVariant: Color(0xff1a4975),
      secondaryFixed: Color(0xffd7e3f8),
      onSecondaryFixed: Color(0xff101c2b),
      secondaryFixedDim: Color(0xffbbc7db),
      onSecondaryFixedVariant: Color(0xff3b4858),
      tertiaryFixed: Color(0xfff3daff),
      onTertiaryFixed: Color(0xff251431),
      tertiaryFixedDim: Color(0xffd7bee4),
      onTertiaryFixedVariant: Color(0xff523f5f),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa7ceff),
      surfaceTint: Color(0xffa1cafd),
      onPrimary: Color(0xff00172e),
      primaryContainer: Color(0xff6b93c4),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbfccdf),
      onSecondary: Color(0xff0a1725),
      secondaryContainer: Color(0xff8592a4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffdbc2e9),
      onTertiary: Color(0xff200f2c),
      tertiaryContainer: Color(0xff9f88ac),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111418),
      onSurface: Color(0xfffafaff),
      onSurfaceVariant: Color(0xffc7cbd3),
      outline: Color(0xff9fa3ab),
      outlineVariant: Color(0xff7f838b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff1c4a76),
      primaryFixed: Color(0xffd2e4ff),
      onPrimaryFixed: Color(0xff001225),
      primaryFixedDim: Color(0xffa1cafd),
      onPrimaryFixedVariant: Color(0xff003862),
      secondaryFixed: Color(0xffd7e3f8),
      onSecondaryFixed: Color(0xff051220),
      secondaryFixedDim: Color(0xffbbc7db),
      onSecondaryFixedVariant: Color(0xff2b3746),
      tertiaryFixed: Color(0xfff3daff),
      onTertiaryFixed: Color(0xff1a0926),
      tertiaryFixedDim: Color(0xffd7bee4),
      onTertiaryFixedVariant: Color(0xff412f4e),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffafaff),
      surfaceTint: Color(0xffa1cafd),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa7ceff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffafaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbfccdf),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffff9fb),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffdbc2e9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111418),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffafaff),
      outline: Color(0xffc7cbd3),
      outlineVariant: Color(0xffc7cbd3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff002b4e),
      primaryFixed: Color(0xffd9e8ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa7ceff),
      onPrimaryFixedVariant: Color(0xff00172e),
      secondaryFixed: Color(0xffdbe8fc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbfccdf),
      onSecondaryFixedVariant: Color(0xff0a1725),
      tertiaryFixed: Color(0xfff5dfff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffdbc2e9),
      onTertiaryFixedVariant: Color(0xff200f2c),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );
}

TextTheme _createTextTheme(BuildContext context) {
  final baseTextTheme = Theme.of(context).textTheme;
  final bodyTextTheme = GoogleFonts.outfitTextTheme(baseTextTheme);
  final displayTextTheme = GoogleFonts.outfitTextTheme(baseTextTheme);
  return displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
}
