import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app/config.dart';
import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/intake_range.dart';
import '../model/measure_unit.dart';
import '../model/range_type.dart';
import '../model/target_settings.dart';
import '../service/intakes.dart';
import '../service/settings.dart';
import '../ui/color.dart';
import '../ui/icon.dart';
import '../ui/size.dart';
import '../ui/widget/app_menu.dart';
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
  var intakes = <IntakeRange>[];

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
      bottomNavigationBar:
          appBottomMenu(page: AppPage.stats, enabled: !loadingIntakes),
    );
  }

  Widget standardContent() {
    if (loadingSettings || loadingIntakes) {
      return Center(child: AppIcon.loading);
    }
    return Column(
      spacing: AppSize.spacingXS,
      children: [
        chartSummary(),
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
        chartSummary(),
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

  Widget chartSummary() {
    final appL10n = AppL10n.of(context);
    String dateRange;
    if (to.isToday) {
      final days = to.difference(from).inDays;
      dateRange = appL10n.lastNDays(days.toStringAsFixed(0));
    } else {
      dateRange = '${from.formatDate(context)} - ${to.formatDate(context)}';
    }
    final avg = intakes
            .map((e) => e.amount)
            .reduce((value, element) => value + element) /
        intakes.length;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(onPressed: pickDateRange, child: Text(dateRange)),
        Text(intakes.first.rangeType == RangeType.daily
            ? appL10n.intakeAverage(
                targetSettings.volumeMeasureUnit.formatValue(avg))
            : ''),
      ],
    );
  }

  Widget chart() {
    final screenSize = MediaQuery.sizeOf(context);
    return SizedBox(
      width: double.infinity,
      height: screenSize.height / 4,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (data) {
                if (data.barRods.isNotEmpty) {
                  return backgroundColorOf(
                      data.barRods.first.toY, intakes.first.rangeType);
                }
                return Theme.of(context).colorScheme.surface;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final intake = intakes[groupIndex];
                return BarTooltipItem(
                  VolumeMeasureUnit.l.formatValue(intake.amount),
                  TextStyle(
                    color: colorOf(intake.amount, intake.rangeType),
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          barGroups: intakes.mapIndexed((index, intake) {
            final color = backgroundColorOf(intake.amount, intake.rangeType);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: intake.amount,
                  width: AppSize.chartBarWidth,
                  color: color,
                  backDrawRodData: BackgroundBarChartRodData(
                    show: intake.rangeType == RangeType.daily,
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
                getTitlesWidget: (_, __) => Text(''),
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
    final text = Text(
      intakes[index.toInt()].label(context),
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

  void pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: AppConfig.launchDateTime,
      initialDateRange: DateTimeRange(start: from, end: to),
      lastDate: DateTime.now(),
    );
    if (range != null) {
      setState(() {
        from = range.start.atStartOfDay();
        to = range.end.atEndOfDay();
      });
      fetchIntakes();
    }
  }

  Color backgroundColorOf(double amount, RangeType rangeType) {
    if (rangeType == RangeType.daily) {
      final percent = amount / targetSettings.dailyTarget;
      if (percent < 0.3) {
        return Theme.of(context).colorScheme.warning;
      } else if (percent > 0.95) {
        return Theme.of(context).colorScheme.deepWater;
      }
    }
    return Theme.of(context).colorScheme.water;
  }

  Color colorOf(double amount, RangeType rangeType) {
    if (rangeType != RangeType.daily) {
      final percent = amount / targetSettings.dailyTarget;
      if (percent < 0.3) {
        return Theme.of(context).colorScheme.onWarning;
      } else if (percent > 0.95) {
        return Theme.of(context).colorScheme.onDeepWater;
      }
    }
    return Theme.of(context).colorScheme.onWater;
  }
}
