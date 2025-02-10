import 'package:get_it/get_it.dart';

import '../service/database.dart';
import '../service/impl/notification.dart';
import '../service/impl/settings.dart';
import '../service/intakes.dart';
import '../service/notification.dart';
import '../service/settings.dart';
import '../vendor/objectbox/object_box.dart';
import '../vendor/objectbox/service/BoxIntakesService.dart';

final _getIt = GetIt.instance;

Future<void> setupServices() async {
  final notificationService = await LocalNotificationService.create();
  _getIt.registerSingleton<NotificationService>(notificationService);

  final settingsService = await LocalSettingsService.create();
  _getIt.registerSingleton<SettingsService>(settingsService);

  final objectBoxService = await ObjectBox.create();
  _getIt.registerSingleton<DatabaseService>(objectBoxService);

  final intakesService = BoxIntakesService(objectBoxService);
  _getIt.registerSingleton<IntakesService>(intakesService);
}

T service<T extends Object>() => _getIt.get<T>();
