import 'package:flutter/material.dart';

import '../page/home.dart';

enum AppPage {
  home;

  Widget build() {
    switch (this) {
      case AppPage.home:
        return const HomePage();
    }
  }
}

extension AppNavigationContext on BuildContext {
  Future<T?> navigateTo<T extends Object?>(AppPage page, {bool clear = false}) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page.build()),
      (_) => !clear,
    );
  }
}
