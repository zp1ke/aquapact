import 'package:flutter/material.dart';

import '../page/home.dart';

enum AppPage {
  home;

  Widget build(Map<String, Object> args) {
    switch (this) {
      case AppPage.home:
        return HomePage();
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
