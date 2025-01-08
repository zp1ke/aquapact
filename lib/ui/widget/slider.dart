import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../size.dart';

// https://help.syncfusion.com/flutter/slider/overview
class SliderWidget extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final double? interval;
  final Function(double) onChanged;

  const SliderWidget({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.interval,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: AppSize.spacingXL),
        SfSliderTheme(
          data: SfSliderThemeData(overlayRadius: 0),
          child: SfSlider(
            min: min,
            max: max,
            value: value,
            interval: interval,
            thumbShape: _SfThumbShape(),
            dividerShape: _DividerShape(),
            showLabels: true,
            shouldAlwaysShowTooltip: true,
            enableTooltip: true,
            onChanged: (value) {
              onChanged(value);
            },
            onChangeEnd: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

class _SfThumbShape extends SfThumbShape {
  @override
  void paint(PaintingContext context, Offset center,
      {required RenderBox parentBox,
      required RenderBox? child,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection,
      required SfThumb? thumb}) {
    final Path path = Path();

    path.moveTo(center.dx, center.dy);
    path.lineTo(center.dx + 10, center.dy - 15);
    path.lineTo(center.dx - 10, center.dy - 15);
    path.close();
    context.canvas.drawPath(
      path,
      Paint()
        ..color = themeData.activeTrackColor!
        ..style = PaintingStyle.fill
        ..strokeWidth = 2,
    );
  }
}

class _DividerShape extends SfDividerShape {
  @override
  void paint(PaintingContext context, Offset center, Offset? thumbCenter,
      Offset? startThumbCenter, Offset? endThumbCenter,
      {required RenderBox parentBox,
      required SfSliderThemeData themeData,
      SfRangeValues? currentValues,
      dynamic currentValue,
      required Paint? paint,
      required Animation<double> enableAnimation,
      required TextDirection textDirection}) {
    bool isActive;

    switch (textDirection) {
      case TextDirection.ltr:
        isActive = center.dx <= thumbCenter!.dx;
        break;
      case TextDirection.rtl:
        isActive = center.dx >= thumbCenter!.dx;
        break;
    }

    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: 5.0, height: 10.0),
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = isActive ? themeData.activeTrackColor! : Colors.white,
    );
  }
}
