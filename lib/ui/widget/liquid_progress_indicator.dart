import 'dart:math';

import 'package:flutter/material.dart';

class LiquidProgressIndicatorWidget extends StatefulWidget {
  final double loadValue;
  final Duration loadDuration;
  final Duration waveDuration;
  final Color? waveColor;

  const LiquidProgressIndicatorWidget({
    super.key,
    required double value,
    required double targetValue,
    this.loadDuration = const Duration(milliseconds: 500),
    this.waveDuration = const Duration(milliseconds: 50),
    this.waveColor,
  }) : loadValue = value / targetValue;

  @override
  State<LiquidProgressIndicatorWidget> createState() =>
      _LiquidProgressIndicatorWidgetState();
}

class _LiquidProgressIndicatorWidgetState
    extends State<LiquidProgressIndicatorWidget> with TickerProviderStateMixin {
  late final double targetValue;
  double loadStep = 0.1;
  late final AnimationController waveController;
  late final AnimationController loadController;
  late final Animation<double> loadValue;

  @override
  initState() {
    super.initState();

    targetValue = min(widget.loadValue, 1);

    loadStep = targetValue /
        (widget.loadDuration.inMilliseconds /
            widget.waveDuration.inMilliseconds);
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
      end: targetValue,
    ).animate(loadController);

    loadValue.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          loadValue.value == targetValue) {
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
                    waveColor: widget.waveColor ?? Colors.blue,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${(loadValue.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.black.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
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
    if (oldWidget.loadValue != targetValue) {
      loadValue = Tween<double>(
        begin: loadValue.value,
        end: targetValue,
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
