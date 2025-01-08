import 'package:flutter/material.dart';

enum AppImage {
  notification(isPng: true);

  final bool isPng;

  const AppImage({
    required this.isPng,
  });

  String assetName(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final darkSuffix = brightness == Brightness.dark ? '_dark' : '';
    final extension = isPng ? 'png' : 'jpg';
    return 'assets/$extension/$name$darkSuffix.$extension';
  }
}
