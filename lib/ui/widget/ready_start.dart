import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../image.dart';
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
      spacing: AppSize.spacing4XL,
      children: <Widget>[
        Spacer(),
        Image(
          image: AppImage.logo.assetImage(context),
          height: AppSize.spacing4XL * 1.5,
          fit: BoxFit.fitHeight,
        ),
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
