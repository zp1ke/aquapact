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

  static const loading = SizedBox(
    width: AppSize.icon,
    height: AppSize.icon,
    child: CircularProgressIndicator.adaptive(
      year2023: false,
    ),
  );

  static const refresh = Icon(Icons.refresh_sharp);

  static const settings = Icon(Icons.settings_sharp);

  static const stats = Icon(Icons.area_chart_outlined);

  static Icon waterGlass(BuildContext context) {
    return Icon(
      Icons.local_drink_sharp,
      color: Theme.of(context).colorScheme.water,
    );
  }
}
