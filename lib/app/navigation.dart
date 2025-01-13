import 'package:flutter/material.dart';

import '../page/home.dart';
import '../page/target_settings.dart';

enum AppPage {
  home,
  targetSettings;

  Widget build(Map<String, Object> args) {
    switch (this) {
      case AppPage.home:
        return HomePage();
      case AppPage.targetSettings:
        return TargetSettingsPage();
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

  void navigateBack<T extends Object?>([T? result]) {
    final navigator = Navigator.of(this);
    if (navigator.canPop()) {
      navigator.pop(result);
    }
  }
}
