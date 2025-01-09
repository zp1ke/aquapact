import 'package:get_it/get_it.dart';

import '../service/impl/notification.dart';
import '../service/impl/settings.dart';
import '../service/notification.dart';
import '../service/settings.dart';

final _getIt = GetIt.instance;

Future<void> setupServices() async {
  final notificationService = await LocalNotificationService.create();
  _getIt.registerSingleton<NotificationService>(notificationService);

  final settingsService = await LocalSettingsService.create();
  _getIt.registerSingleton<SettingsService>(settingsService);
}

T service<T extends Object>() => _getIt.get<T>();
