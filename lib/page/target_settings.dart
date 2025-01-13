import 'package:flutter/material.dart';

import '../app/di.dart';
import '../app/navigation.dart';
import '../l10n/app_l10n.dart';
import '../model/target_settings.dart';
import '../service/mixin/target_settings_saver.dart';
import '../service/settings.dart';
import '../ui/form/target_settings.dart';

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
    settings = service<SettingsService>().readTargetSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context).targetSettings),
      ),
      body: settings != null
          ? TargetSettingsForm(
              saving: saving,
              targetSettings: settings,
              onSave: (newSettings) async {
                await saveTargetSettings(newSettings);
                if (context.mounted) {
                  context.navigateBack(newSettings);
                }
              },
              onCancel: () {
                context.navigateBack();
              },
            )
          : Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }

  Future<void> saveTargetSettings(TargetSettings newSettings) async {
    setState(() {
      saving = true;
    });
    await saveSettings(context, newSettings);
  }
}
