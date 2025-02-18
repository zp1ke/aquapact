import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../size.dart';

class ReadyStartWidget extends StatelessWidget {
  final VoidCallback onAction;

  const ReadyStartWidget({
    super.key,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppL10n.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: AppSize.spacing4XL,
      children: <Widget>[
        Text(
          l10n.weAreGoodToGo,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge,
        ),
        OutlinedButton(
          onPressed: onAction,
          child: Text(l10n.letsStart),
        ),
      ],
    );
  }
}
