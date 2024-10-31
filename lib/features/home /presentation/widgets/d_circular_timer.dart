import 'package:flutter/material.dart';
import 'dart:math';

class DCircularTimer extends StatefulWidget {
  final int durationInSeconds;
  final Color color;

  const DCircularTimer({
    super.key,
    required this.durationInSeconds,
    this.color = Colors.blue,
  });

  @override
  DCircularTimerState createState() => DCircularTimerState();
}

class DCircularTimerState extends State<DCircularTimer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    );

    // Notify when timer completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted && widget.durationInSeconds > 0) {
          // Notify HomeScreen that the timer has completed
          if (widget.key is GlobalKey<DCircularTimerState>) {
            final parentKey = widget.key as GlobalKey<DCircularTimerState>;
            parentKey.currentState?.onTimerComplete();
          }
        }
      }
    });
  }

  void onTimerComplete() {
    if (mounted) {
      // Notify parent about timer completion
      if (widget.key is GlobalKey<DCircularTimerState>) {
        final parentKey = widget.key as GlobalKey<DCircularTimerState>;
        parentKey.currentState?.onTimerComplete();
      }
    }
  }

  // Public methods to control the timer
  void start() {
    _controller.forward(from: 0);
  }

  void pause() {
    _controller.stop();
  }

  void reset() {
    _controller.reset();
  }

  void updateDuration(int newDurationInSeconds) {
    _controller.stop();
    _controller.duration = Duration(seconds: newDurationInSeconds);
    _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(700, 700),
            painter: BackgroundCirclePainter(),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(500, 500),
                painter: PieChartPainter(
                  progress: 1 - _controller.value,
                  color: widget.color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BackgroundCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.0)
      ..style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PieChartPainter extends CustomPainter {
  final double progress;
  final Color color;

  PieChartPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double sweepAngle = 2 * pi * progress;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}