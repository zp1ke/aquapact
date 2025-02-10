import 'dart:math';

import 'package:flutter/material.dart';

import '../color.dart';
import '../size.dart';

class LiquidProgressIndicatorWidget extends StatefulWidget {
  final double value;
  final double targetValue;
  final Duration loadDuration;
  final Duration waveDuration;
  final Color? waveColor;

  const LiquidProgressIndicatorWidget({
    super.key,
    required this.value,
    required this.targetValue,
    this.loadDuration = const Duration(milliseconds: 2000),
    this.waveDuration = const Duration(milliseconds: 800),
    this.waveColor,
  });

  @override
  State<LiquidProgressIndicatorWidget> createState() =>
      _LiquidProgressIndicatorWidgetState();
}

class _LiquidProgressIndicatorWidgetState
    extends State<LiquidProgressIndicatorWidget> with TickerProviderStateMixin {
  late final AnimationController waveController;
  late final AnimationController loadController;

  late Animation<double> loadValue;

  double get loadedValue => min(widget.value / widget.targetValue, 1.0);

  double get loadStep =>
      loadedValue /
      (widget.loadDuration.inMilliseconds / widget.waveDuration.inMilliseconds);

  @override
  initState() {
    super.initState();
    waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    );
    loadController = AnimationController(
      vsync: this,
      duration: widget.loadDuration,
    );
    loadValue = Tween<double>(
      begin: 0,
      end: loadedValue,
    ).animate(loadController);

    loadValue.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          loadValue.value == loadedValue) {
        waveController.stop();
      }
      if (status == AnimationStatus.forward) {
        waveController.repeat();
      }
    });
    loadController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: Listenable.merge([loadController, waveController]),
        builder: (context, child) {
          return Stack(
            children: [
              SizedBox.expand(
                child: CustomPaint(
                  painter: _WavePainter(
                    waveValue: waveController.value,
                    loadValue: loadValue.value,
                    waveColor: widget.waveColor ?? theme.colorScheme.water,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.spacingXS * 2,
                    vertical: .0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSize.spacingLarge),
                  ),
                  child: Text(
                    '${(loadValue.value * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: AppSize.spacingLarge * 1.4,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.targetValue != widget.targetValue) {
      loadValue = Tween<double>(
        begin: loadValue.value,
        end: loadedValue,
      ).animate(loadController);
      loadController.reset();
      loadController.forward();
    }
  }

  @override
  void dispose() {
    waveController.dispose();
    loadController.dispose();
    super.dispose();
  }
}

class _WavePainter extends CustomPainter {
  static const pi2 = 2 * pi;
  final double waveValue;
  final double loadValue;
  final Color waveColor;

  _WavePainter({
    required this.waveValue,
    required this.loadValue,
    required this.waveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    double baseHeight = height * loadValue;
    final path = Path();

    path.moveTo(0.0, height);
    if (loadValue != 1) {
      for (var i = 0.0; i <= width; i++) {
        path.lineTo(
            i, height - baseHeight + sin(pi2 * (i / width + waveValue)) * 8);
      }
    }

    path.lineTo(width, height);
    if (loadValue == 1) {
      path.lineTo(width, 0);
      path.lineTo(0, 0);
    }

    path.close();
    final wavePaint = Paint()..color = waveColor;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.waveValue != waveValue ||
        oldDelegate.loadValue != loadValue;
  }
}
