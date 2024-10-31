import 'package:flutter/material.dart';
import 'dart:math';

import '../../../../core/util/constants/color_grid.dart';


class DCircularTimer extends StatefulWidget {
  final int durationInSeconds;
  final Color color;

  const DCircularTimer({
    super.key,
    this.durationInSeconds = 10,
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
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    );

    // Listen for timer completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: tWhite,
          title: const Text("Time's up!"),
          content: const Text("The timer has completed."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text("Dismiss"),
            ),
            TextButton(
              onPressed: () {
                reset(); // Reset the timer
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );
  }


  void updateDuration(int newDurationInSeconds) {
    _controller.stop();
    _controller.duration = Duration(seconds: newDurationInSeconds);
    _controller.reset();
  }

  void start() {
    if (!_controller.isAnimating && !_controller.isCompleted) {
      _controller.forward();
    }
  }

  void pause() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  void reset() {
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
          // Background black circle
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
        ),]
      ),
    );
  }
}

// Painter for the black background circle
class BackgroundCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
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