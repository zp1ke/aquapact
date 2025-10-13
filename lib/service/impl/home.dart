import 'package:home_widget/home_widget.dart';

import '../../util/date_time.dart';
import '../home.dart';
import '../intakes.dart';
import '../settings.dart';

class HomeScreenService implements HomeService {
  final String appGroupId = 'org.zp1ke.aquapact';
  final String androidWidgetName = 'StatusWidget';

  @override
  Future<void> updateData() async {
    final settings = SettingsService.get().readTargetSettings();
    final today = DateTime.now().atStartOfDay();
    if (settings != null) {
      final intakeValue = await IntakesService.get().sumIntakesAmount(
        from: today,
        to: today.add(const Duration(days: 1)),
      );
      final todayStr = today.formatDateByPattern('yyyy-MM-dd');

      HomeWidget.saveWidgetData<String>('intake_date', todayStr);
      HomeWidget.saveWidgetData<int>('intake_value', intakeValue.toInt());
      HomeWidget.saveWidgetData<int>(
        'target_value',
        settings.dailyTarget.toInt(),
      );
      HomeWidget.updateWidget(androidName: androidWidgetName);
    }
  }
}
