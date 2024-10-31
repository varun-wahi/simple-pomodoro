import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_pomodoro/features/home%20/presentation/widgets/d_circular_timer.dart';
import 'package:simple_pomodoro/features/home%20/presentation/widgets/round_button.dart';

import '../../../../core/util/widgets/d_gap.dart'; // Update this import path

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<DCircularTimerState> _timerKey = GlobalKey<DCircularTimerState>();
  bool isPaused = true;
  bool isEditing = false;
  int totalDuration = 150; // Total duration in seconds (2:30)
  int remainingTime = 150;
  Timer? timer;

  // Format time for display
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // Start the periodic timer to update remaining time
  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      }
      if (remainingTime <= 0) {
        _showCompletionDialog();
        timer.cancel();
      }
    });
  }

  // Show completion dialog when timer ends
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Time's up!"),
          content: const Text("The timer has completed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Dismiss"),
            ),
            TextButton(
              onPressed: () {
                _resetTimer();
                Navigator.of(context).pop();
              },
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );
  }

  // Start or pause the timer
  void _startOrPauseTimer() {
    setState(() {
      isPaused = !isPaused;
    });
    if (isPaused) {
      _timerKey.currentState?.pause();
    } else {
      _timerKey.currentState?.start();
      if (timer == null || !timer!.isActive) _startTimer();
    }
  }

  // Reset both the circular timer and text
  void _resetTimer() {
    setState(() {
      isPaused = true;
      remainingTime = totalDuration;
    });
    _timerKey.currentState?.reset();
    timer?.cancel();
  }

  // Update the duration of the timer
  void _updateDuration(int newDurationInSeconds) {
    setState(() {
      totalDuration = newDurationInSeconds;
      remainingTime = newDurationInSeconds;
    });
    _timerKey.currentState?.updateDuration(newDurationInSeconds);
  }

  // Toggle edit mode
  void _editTimer() {
    _resetTimer();
    setState(() {
      isEditing = !isEditing;
    });
  }

  // Save new time entered in edit mode
  void _saveNewTime() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final newDuration = (hours * 3600) + (minutes * 60) + seconds;

    _updateDuration(newDuration);
    setState(() {
      isEditing = false;
    });
  }

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void dispose() {
    timer?.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Timer"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: DCircularTimer(
                  key: _timerKey,
                  durationInSeconds: totalDuration,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          isEditing
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeField(_hoursController, "HH"),
                      const Text(":", style: TextStyle(fontSize: 40)),
                      _buildTimeField(_minutesController, "MM"),
                      const Text(":", style: TextStyle(fontSize: 40)),
                      _buildTimeField(_secondsController, "SS"),
                    ],
                  ),
                )
              : Text(
                  _formatTime(remainingTime),
                  style: GoogleFonts.barlowCondensed(
                    fontWeight: FontWeight.w900,
                    fontSize: 95,
                  ),
                ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundButton(
                icon: Icons.refresh,
                onPressed: isEditing ? null : _resetTimer,
              ),
              RoundButton(
                icon: isPaused ? Icons.play_arrow : Icons.pause,
                onPressed: isEditing ? null : _startOrPauseTimer,
              ),
              RoundButton(
                icon: Icons.edit,
                onPressed: _editTimer,
                selected: isEditing,
              ),
            ],
          ),
        const DGap(multiplier: 10,)
        ],
      ),
    );
  }

  Widget _buildTimeField(TextEditingController controller, String hint) {
    return SizedBox(
      width: 70,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 35, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black, width: 0.3),
          ),
        ),
        onSubmitted: (_) => _saveNewTime(),
      ),
    );
  }

}