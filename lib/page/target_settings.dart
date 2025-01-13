import 'package:flutter/material.dart';

import '../app/navigation.dart';
import '../model/target_settings.dart';
import '../service/mixin/target_settings_saver.dart';
import '../ui/form/target_settings.dart';

class TargetSettingsPage extends StatefulWidget {
  const TargetSettingsPage({super.key});

  @override
  State<TargetSettingsPage> createState() => _TargetSettingsPageState();
}

class _TargetSettingsPageState extends State<TargetSettingsPage>
    with TargetSettingsSaver {
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Target Settings'),
      ),
      body: TargetSettingsForm(
        saving: saving,
        onSave: (newSettings) async {
          await saveTargetSettings(newSettings);
          if (context.mounted) {
            context.navigateBack(newSettings);
          }
        },
        onCancel: () {
          context.navigateBack();
        },
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
