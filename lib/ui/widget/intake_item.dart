import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../../model/intake.dart';
import '../../util/date_time.dart';
import '../icon.dart';

class IntakeItem extends StatelessWidget {
  final Intake intake;
  final bool dense;
  final Function(Intake) onEdit;
  final Function(Intake) onDelete;

  const IntakeItem({
    super.key,
    required this.intake,
    this.dense = false,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: Key(intake.code),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          var delete = true;
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          scaffoldMessenger.clearSnackBars();
          final l10n = AppL10n.of(context);
          final undoController = scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(l10n.intakeRecordDeleted),
              action: SnackBarAction(
                label: l10n.undo,
                onPressed: () => delete = false,
              ),
            ),
          );
          await undoController.closed;
          return delete;
        }
        return false;
      },
      background: Container(),
      secondaryBackground: Container(
        color: theme.colorScheme.errorContainer,
        child: Center(
          child: AppIcon.delete(context, hasBackground: true),
        ),
      ),
      onDismissed: (_) {
        onDelete(intake);
      },
      child: ListTile(
        dense: dense,
        leading: AppIcon.waterGlass(context),
        title: Text(intake.measureUnit.formatValue(intake.amount)),
        subtitle: Text(intake.dateTime.format(context)),
      ),
    );
  }
}
