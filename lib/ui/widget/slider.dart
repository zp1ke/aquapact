import 'package:flutter/material.dart';

import '../size.dart';

typedef ValueFormatter = String Function(double value);

class SliderWidget extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final bool enabled;
  final double height;
  final double interval;
  final Color? fromColor;
  final Color? toColor;
  final Color? textColor;
  final Function(double) onChanged;
  final ValueFormatter valueFormatter;

  const SliderWidget({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    this.enabled = true,
    this.height = AppSize.spacingXL * 1.1,
    required this.interval,
    required this.onChanged,
    this.fromColor,
    this.toColor,
    this.textColor,
    required this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final paddingFactor = .2;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(height * paddingFactor),
        ),
        gradient: LinearGradient(
          colors: [
            fromColor ?? theme.colorScheme.primaryContainer,
            toColor ?? theme.colorScheme.primaryContainer,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 1.00),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: height * paddingFactor,
          vertical: AppSize.spacingSmall,
        ),
        child: Row(
          spacing: AppSize.spacingXS / 2,
          children: <Widget>[
            Text(
              valueFormatter(min),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * paddingFactor * 1.2,
                fontWeight: FontWeight.w700,
                color: textColor ?? theme.colorScheme.onPrimaryContainer,
              ),
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: theme.indicatorColor,
                    inactiveTrackColor:
                        theme.indicatorColor.withValues(alpha: .5),
                    trackHeight: AppSize.spacingXS,
                    thumbShape: _SliderThumbCircle(
                      thumbRadius: height * 0.45,
                      label: valueFormatter(value),
                      color: theme.colorScheme.surface,
                      textColor: theme.colorScheme.onSurface,
                    ),
                  ),
                  child: Slider.adaptive(
                    year2023: false,
                    min: min,
                    max: max,
                    value: value,
                    divisions: ((max - min) / interval).toInt(),
                    label: valueFormatter(value),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
            Text(
              valueFormatter(max),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * paddingFactor * 1.2,
                fontWeight: FontWeight.w700,
                color: textColor ?? theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final String label;
  final Color color;
  final Color textColor;

  const _SliderThumbCircle({
    required this.thumbRadius,
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * .6,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      text: label,
    );

    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }
}
