import 'package:flutter/material.dart';

import 'color.dart';
import 'size.dart';

abstract class AppIcon {
  static const add = Icon(Icons.add);

  static Icon delete(BuildContext context, {bool hasBackground = false}) {
    return Icon(
      Icons.delete,
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

  static const refresh = Icon(Icons.refresh);

  static const settings = Icon(Icons.settings);

  static const stats = Icon(Icons.area_chart);

  static Icon waterGlass(BuildContext context) {
    return Icon(
      Icons.local_drink,
      color: Theme.of(context).colorScheme.water,
    );
  }
}
