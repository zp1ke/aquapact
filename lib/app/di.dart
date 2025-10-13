import 'package:get_it/get_it.dart';

import '../service/database.dart';
import '../service/health.dart';
import '../service/home.dart';
import '../service/impl/health.dart';
import '../service/impl/home.dart';
import '../service/impl/notification.dart';
import '../service/impl/settings.dart';
import '../service/intakes.dart';
import '../service/notification.dart';
import '../service/settings.dart';
import '../vendor/objectbox/object_box.dart';
import '../vendor/objectbox/service/intakes.dart';

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

  final healthService = HealthChannelService();
  _getIt.registerSingleton<HealthService>(healthService);

  final homeService = HomeScreenService();
  _getIt.registerSingleton<HomeService>(homeService);
}

T service<T extends Object>() => _getIt.get<T>();
