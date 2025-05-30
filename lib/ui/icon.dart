import 'package:flutter/material.dart';

import 'color.dart';
import 'size.dart';

abstract class AppIcon {
  static const about = Icon(Icons.info_outline_rounded);

  static const add = Icon(Icons.add_sharp);

  static Icon delete(BuildContext context, {bool hasBackground = false}) {
    return Icon(
      Icons.delete_forever_sharp,
      color: hasBackground
          ? Theme.of(context).colorScheme.onErrorContainer
          : Theme.of(context).colorScheme.error,
    );
  }

  static Icon healthSynced(BuildContext context, {required bool synced}) {
    return Icon(
      synced ? Icons.check_circle_sharp : Icons.check_circle_outline_sharp,
      color: synced
          ? Theme.of(context).colorScheme.success
          : Theme.of(context).disabledColor,
    );
  }

  static const home = Icon(Icons.home_sharp);
  static const homeOut = Icon(Icons.home_outlined);

  static const intakes = Icon(Icons.local_drink_sharp);
  static const intakesOut = Icon(Icons.local_drink_outlined);

  static const loading = SizedBox(
    width: AppSize.icon,
    height: AppSize.icon,
    child: CircularProgressIndicator.adaptive(),
  );

  static const refresh = Icon(Icons.refresh_sharp);

  static const settings = Icon(Icons.settings_sharp);
  static const settingsOut = Icon(Icons.settings_outlined);

  static const stats = Icon(Icons.area_chart_sharp);
  static const statsOut = Icon(Icons.area_chart_outlined);

  static Icon waterGlass(BuildContext context) {
    return Icon(
      Icons.local_drink_sharp,
      color: Theme.of(context).colorScheme.water,
    );
  }
}
