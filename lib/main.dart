import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  final initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@drawable/app_icon'),
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (notificationResponse) {
      debugPrint(
          'Notification tapped===============================================: ${notificationResponse.notificationResponseType}');
    },
  );

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  debugPrint(
      'app notificationAppLaunchDetails ==================== ${notificationAppLaunchDetails?.didNotificationLaunchApp}');

  runApp(MyApp(
    didNotificationLaunchApp:
        notificationAppLaunchDetails?.didNotificationLaunchApp ?? false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.didNotificationLaunchApp,
  });

  final bool didNotificationLaunchApp;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        didNotificationLaunchApp: didNotificationLaunchApp,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.didNotificationLaunchApp,
  });

  final String title;

  final bool didNotificationLaunchApp;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _notificationsEnabled = false;

  get androidNotificationDetails => AndroidNotificationDetails(
        'default_notification_channel',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        visibility: NotificationVisibility.public,
        enableLights: true,
        enableVibration: true,
        vibrationPattern: Int64List.fromList(<int>[1000, 500, 1000]),
      );

  @override
  void initState() {
    super.initState();
    if (widget.didNotificationLaunchApp) {
      _counter = 100;
    }
    _isAndroidPermissionGranted();
    _requestPermissions();
  }

  Future<void> _isAndroidPermissionGranted() async {
    final bool granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;

    setState(() {
      _notificationsEnabled = granted;
    });
  }

  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final bool? grantedNotificationPermission =
        await androidImplementation?.requestNotificationsPermission();
    setState(() {
      _notificationsEnabled = grantedNotificationPermission ?? false;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('notifications enabled: $_notificationsEnabled'),
            if (!_notificationsEnabled)
              ElevatedButton(
                onPressed: _requestPermissions,
                child: Text('Allow Notifications'),
              ),
            if (_notificationsEnabled)
              ElevatedButton(
                onPressed: _showNotification,
                child: Text('Show Notification'),
              ),
            if (_notificationsEnabled)
              ElevatedButton(
                onPressed: _scheduleNotification,
                child: Text('Schedule Notification in 1 min'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showNotification() async {
    await flutterLocalNotificationsPlugin.show(
      _counter,
      'plain title',
      'plain body',
      NotificationDetails(android: androidNotificationDetails),
      payload: 'item x',
    );
    _incrementCounter();
  }

  Future<void> _scheduleNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    // await flutterLocalNotificationsPlugin.periodicallyShow
    await flutterLocalNotificationsPlugin.zonedSchedule(
      _counter,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime.now(tz.local).add(Duration(minutes: 1)),
      NotificationDetails(android: androidNotificationDetails),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    _incrementCounter();
  }
}
