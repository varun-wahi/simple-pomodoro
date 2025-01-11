import 'package:flutter/material.dart';
import 'dart:math';

import 'package:simple_pomodoro/core/util/constants/color_grid.dart';

class DCircularTimer extends StatefulWidget {
  final int durationInSeconds;
  final Color fgColor;
  final Color bgColor;


  const DCircularTimer({
    super.key,
    required this.durationInSeconds,
    this.fgColor = Colors.blue,
    this.bgColor = tBlack,
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
  }

  // Public method to start/resume the timer
  void start() {
    if (_controller.isDismissed || _controller.isCompleted) {
      _controller.duration = Duration(seconds: widget.durationInSeconds); // Reset duration if completed
    }
    _controller.forward(from: _controller.value); // Resume from current position
  }

  // Public method to pause the timer
  void pause() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  // Public method to reset the timer
  void reset() {
    _controller.reset();
  }

  // Method to update duration without resetting the progress
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
                  color: widget.fgColor,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Painter for the black background circle
class BackgroundCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
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