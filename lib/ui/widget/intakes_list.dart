import 'package:flutter/material.dart';

import '../../app/di.dart';
import '../../l10n/app_l10n.dart';
import '../../model/intake.dart';
import '../../service/intakes.dart';
import '../../util/date_time.dart';
import '../icon.dart';
import 'intake_item.dart';

class IntakesController {
  final _listeners = <_IntakesListener>[];

  void refresh({
    required DateTime from,
    required DateTime to,
  }) {
    for (final listener in _listeners) {
      listener.onRefresh(from: from, to: to);
    }
  }
}

class IntakesListWidget extends StatefulWidget {
  final int? limit;
  final IntakesController controller;
  final bool dense;
  final bool shrinkWrap;
  final VoidCallback onChanged;

  const IntakesListWidget({
    super.key,
    this.limit,
    required this.controller,
    this.dense = false,
    this.shrinkWrap = false,
    required this.onChanged,
  });

  @override
  State<IntakesListWidget> createState() => _IntakesListWidgetState();
}

class _IntakesListWidgetState extends State<IntakesListWidget>
    implements _IntakesListener {
  var from = DateTime.now().atStartOfDay();
  late DateTime to = from.add(Duration(days: 1));
  var intakes = <Intake>[];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    widget.controller._listeners.add(this);
    loadData();
  }

  void loadData() async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    intakes = await service<IntakesService>().fetchIntakes(
      from: from,
      to: to,
      limit: widget.limit,
    );
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading && intakes.isEmpty) {
      return Center(child: AppIcon.loading);
    }
    if (intakes.isEmpty) {
      return Center(
        child: Text(
          AppL10n.of(context).noIntakesYet,
          textScaler: TextScaler.linear(1.2),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: intakes.length,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index) => IntakeItem(
        intake: intakes[index],
        onEdit: (intake) {},
        onDelete: (intake) async {
          intakes.removeWhere((element) => element.code == intake.code);
          await service<IntakesService>().deleteIntake(intake);
          widget.onChanged();
          loadData();
        },
      ),
      separatorBuilder: (context, index) {
        return Divider(height: .0);
      },
    );
  }

  @override
  void onRefresh({
    required DateTime from,
    required DateTime to,
  }) {
    this.from = from;
    this.to = to;
    loadData();
  }
}

abstract class _IntakesListener {
  void onRefresh({
    required DateTime from,
    required DateTime to,
  });
}
