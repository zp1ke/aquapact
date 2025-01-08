import 'package:aquapact/notification.dart';
import 'package:flutter/material.dart';

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
    const assetName = 'assets/png/notification.png';
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Image(
          image: AssetImage(assetName),
          height: basePadding * 5,
          fit: BoxFit.fitHeight,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: basePadding / 2,
          children: [
            Text(
              'Allow App Notifications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'We will need permission so the app can send you notifications.',
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
          style: theme.elevatedButtonTheme.style?.copyWith(
            backgroundColor: WidgetStateProperty.all(theme.primaryColor),
          ),
          child: Text('Sure, let\'s do it!'),
        ),
      ],
    );
  }
}
