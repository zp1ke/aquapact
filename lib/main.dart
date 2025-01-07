import 'package:flutter/material.dart';

import 'notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final didNotificationLaunchApp = await AppNotification.I.initialize();

  runApp(MyApp(
    didNotificationLaunchApp: didNotificationLaunchApp,
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

  @override
  void initState() {
    super.initState();
    if (widget.didNotificationLaunchApp) {
      _counter = 100;
    }
    AppNotification.I.androidHasPermissionGranted().then((enabled) {
      setState(() {
        _notificationsEnabled = enabled;
      });
      if (!enabled) {
        AppNotification.I.requestPermissions();
      }
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
                onPressed: AppNotification.I.requestPermissions,
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
    await AppNotification.I.showNotification(
      _counter,
      'plain title',
      'plain body',
      payload: 'item x',
    );
    _incrementCounter();
  }

  Future<void> _scheduleNotification() async {
    await AppNotification.I.scheduleNotification(
      _counter,
      'scheduled title',
      'scheduled body',
      DateTime.now().add(const Duration(minutes: 1)),
    );
    _incrementCounter();
  }
}
