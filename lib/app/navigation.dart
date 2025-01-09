import 'package:flutter/material.dart';

import '../constant.dart';
import '../page/home.dart';

enum AppPage {
  home;

  Widget build(Map<String, Object> args) {
    switch (this) {
      case AppPage.home:
        return HomePage(
          didNotificationLaunchApp:
              (args[keyDidNotificationLaunchApp] as bool?) ?? false,
        );
    }
  }
}

extension AppNavigationContext on BuildContext {
  Future<T?> navigateTo<T extends Object?>(
    AppPage page, {
    bool clear = false,
    Map<String, Object>? args,
  }) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page.build(args ?? {})),
      (_) => !clear,
    );
  }
}
