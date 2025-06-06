import 'package:flutter/material.dart';

import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/target_settings.dart';
import '../service/mixin/target_settings_saver.dart';
import '../service/settings.dart';
import '../ui/form/target_settings.dart';
import '../ui/icon.dart';
import '../ui/widget/app_menu.dart';

class TargetSettingsPage extends StatefulWidget {
  const TargetSettingsPage({super.key});

  @override
  State<TargetSettingsPage> createState() => _TargetSettingsPageState();
}

class _TargetSettingsPageState extends State<TargetSettingsPage>
    with TargetSettingsSaver {
  bool saving = false;
  TargetSettings? settings;

  @override
  void initState() {
    super.initState();
    settings = SettingsService.get().readTargetSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).targetSettings),
      ),
      body: settings != null
          ? SafeArea(child: form())
          : Center(child: AppIcon.loading),
      bottomNavigationBar:
          appBottomMenu(page: AppPage.targetSettings, enabled: !saving),
    );
  }

  Widget form() {
    return TargetSettingsForm(
      saving: saving,
      targetSettings: settings,
      onSave: (newSettings) async {
        await saveTargetSettings(newSettings);
        if (mounted) {
          context.navigateBack(newSettings);
        }
      },
      onCancel: () {
        context.navigateBack();
      },
    );
  }

  Future<void> saveTargetSettings(TargetSettings newSettings) async {
    setState(() {
      saving = true;
    });
    await saveSettings(context, newSettings);
  }
}
