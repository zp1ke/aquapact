import 'package:flutter/material.dart';

import '../l10n/app_l10n.dart';
import '../notification.dart';
import '../ui/image.dart';

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
    const basePadding = 24.0;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: basePadding * 2,
            vertical: basePadding * 5,
          ),
          child: content(context, basePadding),
        ),
      ),
    );
  }

  Widget content(BuildContext context, double basePadding) {
    if (hasPermission == null) {
      return CircularProgressIndicator.adaptive();
    }
    if (hasPermission == false) {
      return requestPermissionContent(context, basePadding);
    }
    return Text('Permission granted TODO');
  }

  Widget requestPermissionContent(BuildContext context, double basePadding) {
    final theme = Theme.of(context);
    final l10n = AppL10n.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image(
          image: AssetImage(AppImage.notification.assetName(context)),
          height: basePadding * 5,
          fit: BoxFit.fitHeight,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: basePadding / 2,
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
