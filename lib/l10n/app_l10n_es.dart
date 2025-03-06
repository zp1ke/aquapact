// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppL10nEs extends AppL10n {
  AppL10nEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get appTitle => 'AquaPact';

  @override
  String get allowAppNotifications => 'Permitir notificaciones de la aplicación';

  @override
  String get allowAppNotificationsDescription => 'Necesitaremos permiso para que la aplicación pueda enviarte notificaciones.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get customIntake => 'Otro...';

  @override
  String get dailyWaterIntake => 'Consumo diario de agua';

  @override
  String get edit => 'Editar';

  @override
  String get enterCustomIntake => 'Ingrese otro Consumo...';

  @override
  String get healthSync => 'Sincronizar con apps de salud';

  @override
  String intakeAverage(String amount) {
    return '$amount promedio';
  }

  @override
  String get intakes => 'Consumos';

  @override
  String intakeIn(String unit) {
    return 'Consumo ($unit)';
  }

  @override
  String intakeMessageOf(String percent) {
    return 'Has alcanzado el $percent% de tu objetivo de hidratación. ¡Sigue así! 💧💪';
  }

  @override
  String get intakeMessageMorning0 => '¡Buenos días! 🌞 Comienza tu día con un refrescante vaso de agua! 💧 ¡Empecemos nuestro viaje para mantenernos hidratados hoy!';

  @override
  String get intakeMessageMidday25 => '¡Gran arrancada! Has alcanzado el 25% de tu objetivo de hidratación. ¡Sigue así y mantente fresco! 💧💪';

  @override
  String get intakeMessageMidday50 => '¡Estás a mitad de camino! El 50% de tu objetivo está completo. ¡Sigue bebiendo y mantente en la ruta! 💦👏';

  @override
  String get intakeMessageAfternoon75 => '¡Progreso fantástico! Estás en el 75% de tu objetivo de hidratación. ¡Solo un poco más para llegar! 💧🚀';

  @override
  String get intakeMessageEvening90 => '¡Casi llegas! Estás en el 90% de tu objetivo. ¡Solo un poco más de esfuerzo y lo lograrás! 💦✨';

  @override
  String get intakeMessage10 => 'No te preocupes, ¡aún tienes tiempo para ponerte al día! Bebe un vaso de agua ahora y mantente en el camino para alcanzar tu objetivo. 💧🌟';

  @override
  String get intakeMessage30 => '¡Tú puedes hacerlo! Toma un momento para beber un vaso de agua y sigue adelante hacia tu objetivo. 💦💪';

  @override
  String get intakeMessage100 => '¡Felicidades! Has alcanzado el 100% de tu objetivo de hidratación hoy. ¡Gran trabajo manteniéndote hidratado! 💧🥳';

  @override
  String intakesOf(String date) {
    return 'Consumos de $date';
  }

  @override
  String get intakeRecordDeleted => 'Registro de consumo eliminado';

  @override
  String lastNDays(String days) {
    return 'Últimos $days días (y hoy)';
  }

  @override
  String get lastIntakes => 'Últimos consumos';

  @override
  String get letsStart => '¡Empecemos!';

  @override
  String nextNotificationAt(String time) {
    return 'Próxima notificación a las $time';
  }

  @override
  String get noIntakesRecorded => 'No se han registrado Consumos :(';

  @override
  String get noIntakesYet => 'Aún no hay Consumos. Bebe un poco de agua para comenzar.';

  @override
  String get notificationTitle => 'Recordatorio de beber agua';

  @override
  String get notificationMessage => '¡Es hora de hidratarte!';

  @override
  String notifyEveryHours(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notificar cada $count horas',
      one: 'Notificar cada hora',
    );
    return '$_temp0';
  }

  @override
  String get save => 'Guardar';

  @override
  String get saving => 'Guardando...';

  @override
  String get settings => 'Configuraciones';

  @override
  String get showAll => 'Mostrar todo';

  @override
  String get sleep => 'Dormir';

  @override
  String get stats => 'Estadísticas';

  @override
  String get sureLetsDoIt => 'Claro, hagámoslo';

  @override
  String get targetSettings => 'Configuraciones de objetivo';

  @override
  String get today => 'Hoy';

  @override
  String todayAt(String time) {
    return 'Hoy a las $time';
  }

  @override
  String totalIntake(String amount) {
    return 'Consumo total: $amount';
  }

  @override
  String get undo => 'Deshacer';

  @override
  String get version => 'Versión';

  @override
  String wakeUpSleepTimes(String wakeUpTime, String sleepTime) {
    return 'Me despierto a las $wakeUpTime, me duermo a las $sleepTime';
  }

  @override
  String get wakeUp => 'Despertar';

  @override
  String get weAreGoodToGo => 'Estamos listos';
}
