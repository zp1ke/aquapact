import 'package:flutter/material.dart';

import '../size.dart';

class SliderWidget extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final bool enabled;
  final double height;
  final double? interval;
  final Function(double) onChanged;

  const SliderWidget({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    this.enabled = true,
    this.height = 48,
    required this.interval,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final paddingFactor = .2;

    return Container(
      width: double.infinity,
      height: height * 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(height * paddingFactor),
        ),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00c6ff),
            const Color(0xFF0072ff),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 1.00),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: height * paddingFactor * 1.5,
          vertical: AppSize.spacingXS,
        ),
        child: Row(
          spacing: AppSize.spacingXS / 2,
          children: <Widget>[
            Text(
              min.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * paddingFactor * 1.2,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white.withValues(alpha: 1.0),
                    inactiveTrackColor: Colors.white.withValues(alpha: .5),
                    trackHeight: AppSize.spacingXS,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: (height - paddingFactor * 2) * 0.55,
                      min: min,
                      max: max,
                    ),
                    overlayColor: Colors.white.withValues(alpha: .4),
                    //valueIndicatorColor: Colors.white,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.red.withValues(alpha: .7),
                  ),
                  child: Slider(
                    min: min,
                    max: max,
                    value: value,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ),
            Text(
              max.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: height * paddingFactor * 1.2,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final double min;
  final double max;

  const CustomSliderThumbCircle({
    required this.thumbRadius,
    required this.min,
    required this.max,
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
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * .6,
        fontWeight: FontWeight.w700,
        color: sliderTheme.thumbColor, //Text Color of Value on Thumb
      ),
      text: getValue(value),
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

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
