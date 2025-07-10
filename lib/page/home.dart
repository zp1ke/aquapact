import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/notification.dart';
import '../model/pair.dart';
import '../model/target_settings.dart';
import '../service/intakes.dart';
import '../service/mixin/target_settings_saver.dart';
import '../service/notification.dart';
import '../service/settings.dart';
import '../ui/android/app_menu.dart';
import '../ui/form/add_intake_button.dart';
import '../ui/icon.dart';
import '../ui/size.dart';
import '../ui/widget/app_menu.dart';
import '../ui/widget/intakes_list.dart';
import '../ui/widget/liquid_progress_indicator.dart';
import '../ui/widget/pull_refresh.dart';
import '../ui/widget/responsive.dart';
import '../util/date_time.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TargetSettingsSaver {
  final intakeCtrl = IntakesController();

  var targetSettings = TargetSettings();
  var notifications = <AppNotification>[];

  var intakeValue = .0;
  var loadingSettings = false;
  var loadingNotifications = false;
  var processing = false;

  final nextNotificationKey = GlobalKey();
  final addIntakeKey = GlobalKey();
  final showAllKey = GlobalKey();
  final intakeAmountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadData();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setupTutorial()?.show(context: context),
    );
  }

  void loadData() {
    readTargetSettings();
    fetchNotifications();
    final today = DateTime.now().atStartOfDay();
    intakeCtrl.refresh(
      from: today,
      to: today.add(const Duration(days: 1)),
    );
    fetchIntakeValue();
  }

  void readTargetSettings() {
    if (processing || loadingSettings) {
      return;
    }
    setState(() {
      loadingSettings = true;
    });
    final settings = SettingsService.get().readTargetSettings();
    setState(() {
      targetSettings = settings ?? TargetSettings();
      loadingSettings = false;
    });
  }

  void fetchNotifications() async {
    if (processing || loadingNotifications) {
      return;
    }
    setState(() {
      loadingNotifications = true;
    });
    final notifications = await NotificationService.get().nextNotifications();
    setState(() {
      this.notifications = notifications;
      loadingNotifications = false;
    });
  }

  void fetchIntakeValue() async {
    final today = DateTime.now().atStartOfDay();
    intakeValue = await IntakesService.get()
        .sumIntakesAmount(from: today, to: today.add(const Duration(days: 1)));
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).appTitle),
        actions: [
          reloadButton(),
        ],
      ),
      body: PullToRefresh(
        onRefresh: loadData,
        withBottomPadding: false,
        child: ResponsiveWidget(
          standard: (_) => standardContent(),
          medium: (_) => mediumContent(),
        ),
      ),
      drawer: menu(),
      bottomNavigationBar:
          appBottomMenu(page: AppPage.home, enabled: !processing),
    );
  }

  Widget? menu() {
    if (Platform.isAndroid) {
      return ResponsiveWidget(
        standard: (_) => Drawer(
          child: AppMenu(onChanged: loadData),
        ),
        medium: (_) => Drawer(
          width: AppSize.mediumDrawerWidth,
          child: AppMenu(onChanged: loadData),
        ),
      );
    }
    return null;
  }

  Widget standardContent() {
    return Column(
      spacing: AppSize.spacingSmall,
      children: [
        nextNotifications(),
        addIntakeButton(),
        tipText(),
        Divider(),
        intakesToolbar(),
        lastIntakes(),
        dailyStatusText(),
        dailyStatusWidget(),
      ],
    );
  }

  Widget mediumContent() {
    return Column(
      spacing: AppSize.spacingSmall,
      children: [
        nextNotifications(),
        addIntakeButton(),
        tipText(),
        Divider(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  spacing: AppSize.spacingSmall,
                  children: [
                    intakesToolbar(),
                    lastIntakes(),
                  ],
                ),
              ),
              VerticalDivider(),
              Flexible(
                child: Column(
                  spacing: AppSize.spacingSmall,
                  children: [
                    dailyStatusText(),
                    Spacer(),
                    dailyStatusWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget reloadButton() {
    final isNotLoading = !loadingSettings && !loadingNotifications;
    return IconButton(
      icon: isNotLoading ? AppIcon.refresh : AppIcon.loading,
      onPressed: (!processing && isNotLoading) ? loadData : null,
    );
  }

  Widget addIntakeButton() {
    return AddIntakeButton(
      key: addIntakeKey,
      enabled: !processing,
      targetSettings: targetSettings,
      onAdding: () {
        setState(() {
          processing = true;
        });
      },
      onAdded: addedIntake,
    );
  }

  Widget tipText() {
    return Padding(
      padding: const EdgeInsets.all(AppSize.spacingSmall),
      child: Text(
        IntakesService.get().tip(
          context,
          intakeValue: intakeValue,
          targetValue: targetSettings.dailyTarget,
        ),
        textScaler: TextScaler.linear(0.95),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget nextNotifications() {
    if (notifications.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            AppL10n.of(context)
                .nextNotificationAt(notifications.first.time.format(context)),
            key: nextNotificationKey,
            textAlign: TextAlign.left,
            textScaler: TextScaler.linear(0.8),
          ),
        ),
      );
    }
    return Container();
  }

  Widget intakesToolbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppL10n.of(context).lastIntakes,
            textScaler: TextScaler.linear(1.2),
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          OutlinedButton(
            key: showAllKey,
            child: Text(AppL10n.of(context).showAll),
            onPressed: () async {
              await context.navigateTo(AppPage.intakes);
              loadData();
            },
          ),
        ],
      ),
    );
  }

  Widget lastIntakes() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.spacingSmall),
        child: IntakesListWidget(
          limit: 4,
          controller: intakeCtrl,
          dense: true,
          onChanged: fetchIntakeValue,
        ),
      ),
    );
  }

  Widget dailyStatusText() {
    final intake = targetSettings.volumeMeasureUnit
        .formatValue(intakeValue, withSymbol: false);
    final target = targetSettings.volumeMeasureUnit
        .formatValue(targetSettings.dailyTarget);
    return Text(
      '$intake / $target',
      key: intakeAmountKey,
      textScaler: TextScaler.linear(1.5),
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget dailyStatusWidget() {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: LiquidProgressIndicatorWidget(
        value: intakeValue,
        targetValue: targetSettings.dailyTarget,
      ),
    );
  }

  void addedIntake(Pair<TargetSettings, double> value) async {
    targetSettings = value.first.copyWith(
      defaultIntakeValue: value.second,
    );
    if (mounted) {
      await saveSettings(context, targetSettings, scheduleNotifications: false);
    }
    setState(() {
      processing = false;
    });
    loadData();
  }

  TutorialCoachMark? setupTutorial() {
    if (SettingsService.get().homeWizardCompleted()) {
      return null;
    }
    return TutorialCoachMark(
      targets: tutorialTargets(),
      textSkip: AppL10n.of(context).skip,
      imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      colorShadow: Theme.of(context).colorScheme.primary,
      onFinish: () {
        SettingsService.get().saveHomeWizardCompleted();
      },
      onSkip: () {
        SettingsService.get().saveHomeWizardCompleted();
        return true;
      },
    );
  }

  List<TargetFocus> tutorialTargets() {
    final appL10n = AppL10n.of(context);
    return <TargetFocus>[
      TargetFocus(
        identify: 'nextNotificationKey',
        keyTarget: nextNotificationKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        paddingFocus: AppSize.spacingSmall,
        contents: [
          TargetContent(
            align: ContentAlign.right,
            padding: EdgeInsets.all(AppSize.spacingSmall),
            builder: (_, _) => tutorialCard(appL10n.tutorialNextNotification),
          ),
        ],
      ),
      TargetFocus(
        identify: 'addIntakeKey',
        keyTarget: addIntakeKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        paddingFocus: AppSize.spacingSmall,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.all(AppSize.spacingSmall),
            builder: (_, _) => tutorialCard(appL10n.tutorialAddIntake),
          ),
        ],
      ),
      TargetFocus(
        identify: 'showAllKey',
        keyTarget: showAllKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        paddingFocus: AppSize.spacingSmall,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: EdgeInsets.all(AppSize.spacingSmall),
            builder: (_, _) => tutorialCard(appL10n.tutorialShowAll),
          ),
        ],
      ),
      TargetFocus(
        identify: 'intakeAmountKey',
        keyTarget: intakeAmountKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        paddingFocus: AppSize.spacingSmall,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: EdgeInsets.all(AppSize.spacingSmall),
            builder: (_, _) => tutorialCard(
              appL10n.tutorialIntakeAmount,
              isLast: true,
            ),
          ),
        ],
      ),
    ];
  }

  Widget tutorialCard(String text, {bool isLast = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSize.spacingSmall),
        child: Column(
          spacing: AppSize.spacingSmall,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.justify),
            Text(
              isLast
                  ? AppL10n.of(context).lastTip
                  : AppL10n.of(context).nextTip,
              textScaler: TextScaler.linear(0.75),
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
