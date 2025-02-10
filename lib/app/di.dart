import 'package:get_it/get_it.dart';

import '../service/impl/intakes.dart';
import '../service/impl/notification.dart';
import '../service/impl/settings.dart';
import '../service/intakes.dart';
import '../service/notification.dart';
import '../service/settings.dart';

final _getIt = GetIt.instance;

Future<void> setupServices() async {
  final notificationService = await LocalNotificationService.create();
  _getIt.registerSingleton<NotificationService>(notificationService);

  final settingsService = await LocalSettingsService.create();
  _getIt.registerSingleton<SettingsService>(settingsService);

  final intakesService = IntakesFakeService();
  _getIt.registerSingleton<IntakesService>(intakesService);
}

T service<T extends Object>() => _getIt.get<T>();
