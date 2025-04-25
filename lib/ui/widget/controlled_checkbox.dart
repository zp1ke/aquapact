import 'package:flutter/material.dart';

import '../size.dart';

class ControlledCheckBox extends StatefulWidget {
  const ControlledCheckBox({
    super.key,
    required this.controller,
    required this.text,
  });

  final CheckBoxController controller;

  final String text;

  @override
  State<ControlledCheckBox> createState() => _ControlledCheckBoxState();
}

class _ControlledCheckBoxState extends State<ControlledCheckBox> {
  bool value = false;

  @override
  void initState() {
    super.initState();
    value = widget.controller.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSize.spacingSmall,
      children: [
        Text(widget.text),
        Checkbox.adaptive(
          value: value,
          onChanged: (val) {
            setState(() {
              value = val ?? false;
              widget.controller.value = value;
            });
          },
        ),
      ],
    );
  }
}

class CheckBoxController {
  bool value = false;

  CheckBoxController([this.value = false]);
}
