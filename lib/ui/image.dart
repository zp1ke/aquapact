import 'package:flutter/material.dart';

enum AppImage {
  logo(isPng: true),
  notification(isPng: true);

  final bool isPng;

  const AppImage({
    required this.isPng,
  });

  AssetImage assetImage(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final darkSuffix = brightness == Brightness.dark ? '_dark' : '';
    final extension = isPng ? 'png' : 'jpg';
    final path = 'assets/$extension/$name$darkSuffix.$extension';
    return AssetImage(path);
  }
}
