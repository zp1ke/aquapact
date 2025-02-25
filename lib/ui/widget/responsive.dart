import 'package:flutter/material.dart';

import '../size.dart';

class ResponsiveWidget extends StatelessWidget {
  final WidgetBuilder standard;
  final WidgetBuilder? medium;

  const ResponsiveWidget({
    super.key,
    required this.standard,
    this.medium,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > AppSize.mediumWidthBreakpoint && medium != null) {
      return medium!(context);
    }
    return standard(context);
  }
}
