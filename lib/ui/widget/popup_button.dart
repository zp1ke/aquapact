import 'package:flutter/material.dart';

import '../size.dart';

class PopupButton<T> extends StatefulWidget {
  final bool enabled;
  final Widget? icon;
  final T value;
  final List<T> values;
  final Widget Function(BuildContext, T, bool) itemBuilder;
  final Function(T) onSelected;

  const PopupButton({
    super.key,
    this.enabled = true,
    required this.icon,
    required this.value,
    required this.values,
    required this.itemBuilder,
    required this.onSelected,
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
      child: ElevatedButton.icon(
        onPressed: widget.enabled
            ? () {
                widget.onSelected(widget.value);
              }
            : null,
        label: widget.itemBuilder(context, widget.value, true),
        icon: widget.icon,
      ),
    );
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
          value: value,
          child: widget.itemBuilder(context, value, false),
        );
      }).toList(),
    );
    if (result != null) {
      widget.onSelected(result);
    }
  }
}
