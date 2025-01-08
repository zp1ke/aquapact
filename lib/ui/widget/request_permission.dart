import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../../app/notification.dart';
import '../image.dart';
import '../size.dart';

class RequestPermissionWidget extends StatelessWidget {
  final VoidCallback onGranted;

  const RequestPermissionWidget({
    super.key,
    required this.onGranted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppL10n.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image(
          image: AppImage.notification.assetImage(context),
          height: AppSize.spacing4Xl,
          fit: BoxFit.fitHeight,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: AppSize.spacingMedium,
          children: [
            Text(
              l10n.allowAppNotifications,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            Text(
              l10n.allowAppNotificationsDescription,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () {
            AppNotification.I.requestPermissions().then((value) {
              if (value) {
                onGranted();
              }
            });
          },
          child: Text(l10n.sureLetsDoIt),
        ),
      ],
    );
  }
}
