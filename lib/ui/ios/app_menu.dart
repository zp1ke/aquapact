import 'package:flutter/material.dart';

import '../../app/navigation.dart';
import '../../l10n/app_l10n.dart';
import '../icon.dart';

class BottomMenu extends StatelessWidget {
  final AppPage page;
  final bool enabled;

  const BottomMenu({
    super.key,
    required this.page,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context);
    final theme = Theme.of(context);
    return BottomNavigationBar(
      currentIndex: page.index,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.tertiary,
      onTap: enabled
          ? (index) {
              if (index != page.index) {
                context.navigateTo(AppPage.values[index]);
              }
            }
          : null,
      items: [
        BottomNavigationBarItem(
          activeIcon: AppIcon.home,
          icon: AppIcon.homeOut,
          label: appL10n.home,
        ),
        BottomNavigationBarItem(
          activeIcon: AppIcon.stats,
          icon: AppIcon.statsOut,
          label: appL10n.stats,
        ),
        BottomNavigationBarItem(
          activeIcon: AppIcon.intakes,
          icon: AppIcon.intakesOut,
          label: appL10n.intakes,
        ),
        BottomNavigationBarItem(
          activeIcon: AppIcon.settings,
          icon: AppIcon.settingsOut,
          label: appL10n.settings,
        ),
      ],
    );
  }
}
