import 'dart:io';

import 'package:flutter/material.dart';

import '../../app/navigation.dart';
import '../ios/app_menu.dart';

Widget? appBottomMenu({required AppPage page, required bool enabled}) {
  if (Platform.isIOS) {
    return BottomMenu(page: page, enabled: enabled);
  }
  return null;
}
