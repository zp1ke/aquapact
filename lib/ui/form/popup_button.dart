import 'package:flutter/material.dart';

import '../size.dart';

class PopupButton<T> extends StatefulWidget {
  final bool enabled;
  final Widget? icon;
  final T value;
  final List<T> values;
  final Widget Function(BuildContext, T, bool) itemBuilder;
  final Function(T) onSelected;
  final bool elevated;
  final bool disableValue;
  final Future<T?> Function(BuildContext, T)? onSelectedTransform;

  const PopupButton({
    super.key,
    this.enabled = true,
    this.icon,
    required this.value,
    required this.values,
    required this.itemBuilder,
    required this.onSelected,
    this.elevated = true,
    this.disableValue = false,
    this.onSelectedTransform,
  });

  @override
  State<PopupButton<T>> createState() => _PopupButtonState<T>();
}

class _PopupButtonState<T> extends State<PopupButton<T>> {
  var tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled
          ? (TapDownDetails details) {
              tapPosition = details.globalPosition;
            }
          : null,
      onLongPress: widget.enabled ? showPopupMenu : null,
      child: button(),
    );
  }

  Widget button() {
    final label = widget.itemBuilder(context, widget.value, true);
    if (widget.elevated) {
      return ElevatedButton.icon(
        onPressed: widget.enabled ? onButtonPressed : null,
        label: label,
        icon: widget.icon,
      );
    }
    return TextButton.icon(
      onPressed: widget.enabled ? onButtonPressed : null,
      label: label,
      icon: widget.icon,
    );
  }

  void onButtonPressed() {
    if (!widget.disableValue) {
      selectValue(widget.value);
    }
  }

  void showPopupMenu() async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final result = await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
        tapPosition & Size(AppSize.spacingXL, AppSize.spacingXL),
        Offset.zero & overlay.size,
      ),
      items: widget.values.map((value) {
        return PopupMenuItem<T>(
          enabled: !widget.disableValue || value != widget.value,
          value: value,
          child: widget.itemBuilder(context, value, false),
        );
      }).toList(),
    );
    if (result != null) {
      selectValue(result);
    }
  }

  void selectValue(T value) async {
    if (widget.onSelectedTransform != null) {
      final newValue = await widget.onSelectedTransform!(context, value);
      if (newValue != null) {
        widget.onSelected(newValue);
      }
    } else {
      widget.onSelected(value);
    }
  }
}
