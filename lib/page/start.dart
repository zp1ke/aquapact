import 'package:flutter/material.dart';

import '../l10n/app_l10n.dart';
import '../notification.dart';
import '../ui/image.dart';
import '../ui/size.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool? hasPermission;

  @override
  void initState() {
    super.initState();
    AppNotification.I.hasPermissionGranted().then((value) {
      setState(() {
        hasPermission = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSize.padding2_4Xl,
          child: content(context),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    if (hasPermission == null) {
      return CircularProgressIndicator.adaptive();
    }
    if (hasPermission == false) {
      return requestPermissionContent(context);
    }
    return Text('Permission granted TODO');
  }

  Widget requestPermissionContent(BuildContext context) {
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
              style: theme.textTheme.titleLarge,
            ),
            Text(
              l10n.allowAppNotificationsDescription,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            AppNotification.I.requestPermissions().then((value) {
              setState(() {
                hasPermission = value;
              });
            });
          },
          child: Text(l10n.sureLetsDoIt),
        ),
      ],
    );
  }
}
