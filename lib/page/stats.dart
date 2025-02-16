import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app/di.dart';
import '../l10n/app_l10n.dart';
import '../model/intake.dart';
import '../model/measure_unit.dart';
import '../model/target_settings.dart';
import '../service/intakes.dart';
import '../service/settings.dart';
import '../ui/color.dart';
import '../ui/icon.dart';
import '../ui/size.dart';
import '../ui/widget/pull_refresh.dart';
import '../ui/widget/responsive.dart';
import '../util/collection.dart';
import '../util/date_time.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late DateTime from;
  late DateTime to;

  var targetSettings = TargetSettings();
  var intakes = <Intake>[];

  var loadingSettings = false;
  var loadingIntakes = false;

  @override
  void initState() {
    super.initState();
    to = DateTime.now().atEndOfDay();
    from = to.subtract(const Duration(days: 7)).atStartOfDay();
    loadData();
  }

  void loadData() {
    readTargetSettings();
    fetchIntakes();
  }

  void readTargetSettings() {
    if (loadingSettings) {
      return;
    }
    setState(() {
      loadingSettings = true;
    });
    final settings = service<SettingsService>().readTargetSettings();
    setState(() {
      targetSettings = settings ?? TargetSettings();
      loadingSettings = false;
    });
  }

  void fetchIntakes() async {
    if (loadingIntakes) {
      return;
    }
    setState(() {
      loadingIntakes = true;
    });
    intakes = await service<IntakesService>().fetchAmounts(from: from, to: to);
    setState(() {
      loadingIntakes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).stats),
        actions: [
          reloadButton(),
        ],
      ),
      body: SafeArea(
        child: PullToRefresh(
          onRefresh: loadData,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
            child: ResponsiveWidget(
              standard: (_) => standardContent(),
              medium: (_) => mediumContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget standardContent() {
    if (loadingSettings || loadingIntakes) {
      return Center(child: AppIcon.loading);
    }
    return Column(
      spacing: AppSize.spacingXS,
      children: [
        chartTitle(),
        chart(),
      ],
    );
  }

  Widget mediumContent() {
    if (loadingSettings || loadingIntakes) {
      return Center(child: AppIcon.loading);
    }
    return Column(
      children: [
        chartTitle(),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: AppSize.spacingMedium,
            mainAxisSpacing: AppSize.spacingMedium,
            childAspectRatio: 10 / 4,
            children: [
              Container(),
              chart(),
            ],
          ),
        )
      ],
    );
  }

  Widget reloadButton() {
    final isNotLoading = !loadingSettings && !loadingIntakes;
    return IconButton(
      icon: isNotLoading ? AppIcon.refresh : AppIcon.loading,
      onPressed: isNotLoading ? loadData : null,
    );
  }

  Widget chartTitle() {
    final appL10n = AppL10n.of(context);
    String title;
    if (to.isToday) {
      final days = to.difference(from).inDays;
      title = appL10n.lastNDays(days.toStringAsFixed(0));
    } else {
      title = '${from.formatDate(context)} - ${to.formatDate(context)}';
    }
    final avg = intakes
            .map((e) => e.amount)
            .reduce((value, element) => value + element) /
        intakes.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(appL10n
            .intakeAverage(targetSettings.volumeMeasureUnit.formatValue(avg))),
      ],
    );
  }

  Widget chart() {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: screenSize.height / 4,
      child: BarChart(
        BarChartData(
          barGroups: intakes.mapIndexed((index, intake) {
            final percent = intake.amount / targetSettings.dailyTarget;
            var color = theme.colorScheme.water;
            if (percent < 0.3) {
              color = theme.colorScheme.warning;
            } else if (percent > 0.95) {
              color = theme.colorScheme.deepWater;
            }
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: intake.amount,
                  width: AppSize.chartBarWidth,
                  color: color,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: targetSettings.dailyTarget,
                    color: color.withValues(alpha: 0.5),
                  ),
                )
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(''),
                reservedSize: AppSize.spacingXL,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: xTitle,
                reservedSize: AppSize.spacingXL,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: yTitle,
                reservedSize: AppSize.spacingXL,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: yTitle,
                reservedSize: AppSize.spacingXL,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
        ),
      ),
    );
  }

  Widget xTitle(double index, TitleMeta meta) {
    final day = intakes[index.toInt()].dateTime.day;
    final text = Text(
      day.toString(),
      style: TextStyle(fontWeight: FontWeight.bold),
    );
    return SideTitleWidget(
      meta: meta,
      space: AppSize.spacingMedium,
      child: text,
    );
  }

  Widget yTitle(double value, TitleMeta meta) {
    final text = Text(
      VolumeMeasureUnit.l.formatValue(value),
      style: TextStyle(fontWeight: FontWeight.w600),
    );
    return SideTitleWidget(
      meta: meta,
      space: AppSize.spacingMedium,
      child: text,
    );
  }
}
