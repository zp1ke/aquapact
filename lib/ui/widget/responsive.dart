import 'package:flutter/material.dart';

import '../size.dart';

class ResponsiveWidget extends StatefulWidget {
  final WidgetBuilder standard;
  final WidgetBuilder medium;

  const ResponsiveWidget({
    super.key,
    required this.standard,
    required this.medium,
  });

  @override
  State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {
  Widget? standard;
  Widget? medium;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width > AppSize.mediumWidthBreakpoint) {
          return mediumWidget(context);
        }
        return standardWidget(context);
      },
    );
  }

  Widget standardWidget(BuildContext context) {
    return standard ??= widget.standard(context);
  }

  Widget mediumWidget(BuildContext context) {
    return medium ??= widget.medium(context);
  }
}
