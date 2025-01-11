import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_pomodoro/config/router/route_constants.dart';
import 'package:simple_pomodoro/core/util/constants/color_grid.dart';
import 'package:simple_pomodoro/features/home%20/presentation/widgets/d_circular_timer.dart';
import 'package:simple_pomodoro/features/home%20/presentation/widgets/round_button.dart';

import '../../../../core/util/widgets/d_elevated_button.dart';
import '../../../../core/util/widgets/d_gap.dart'; // Update this import path

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Focus and Break Durations
  ///
  /// You can set your desired defaults. For testing, we keep them small.
  int focusDuration = 15; // e.g., 15 seconds for quick tests
  int breakDuration = 5;  // e.g., 5 seconds for quick tests

  // Track the current time left on the clock
  int remainingTime = 15; // Start with focus duration

  bool isPaused = true;
  bool isEditing = false;
  bool isBreak = false; // false = focus mode, true = break mode

  Timer? timer;

  /// Keys and Controllers
  final GlobalKey<DCircularTimerState> _timerKey = GlobalKey<DCircularTimerState>();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  /// Session Tracking
  ///
  /// We accumulate active time (only while unpaused) separately for focus and break.
  /// sessionStart is the first time the user *ever* pressed play in this session.
  DateTime? sessionStart;
  Duration totalFocusTime = Duration.zero;
  Duration totalBreakTime = Duration.zero;

  /// Tracks when the user last resumed the timer. Used to accumulate active time accurately.
  DateTime? lastResumeTime;

  @override
  void initState() {
    super.initState();
    // Ensure remainingTime matches focusDuration on startup
    remainingTime = focusDuration;
  }

  @override
  void dispose() {
    timer?.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  /// Start or pause the timer
  void _startOrPauseTimer() {
    setState(() {
      isPaused = !isPaused; // Toggle paused state
    });

    if (isPaused) {
      // Pausing: stop the clock and accumulate any active time
      _timerKey.currentState?.pause();
      timer?.cancel();
      _accumulateActiveTime(); // add time from lastResumeTime until now
    } else {
      // Resuming
      // If this is the very first time in the session, set sessionStart
      sessionStart ??= DateTime.now();

      // Mark the resume time for accumulation
      lastResumeTime = DateTime.now();

      _timerKey.currentState?.start();
      if (timer == null || !timer!.isActive) {
        _startTimer();
      }
    }
  }

  /// Common method to start the periodic timer that decreases remainingTime
  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      }
      if (remainingTime <= 0) {
        // Time's up for this session (focus or break)
        timer.cancel();
        _showCompletionDialog();
      }
    });
  }

  /// When the timer completes, show an alert dialog
  void _showCompletionDialog() {
    // First, accumulate any active time up to this point
    _accumulateActiveTime();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Time's up!"),
          content: Text(
            isBreak
                ? "Your break is over. Ready to focus again?"
                : "Your focus session has completed.",
          ),
          actions: [
            // Reset - ends the entire session
            TextButton(
              onPressed: () async {
                // End the session
                await _endSessionAndSave();
                _resetTimer();                
                Navigator.of(context).pop();
              },
              child: const Text("Reset"),
            ),
            // If we are currently focusing, user can choose to start break
            if (!isBreak)
              TextButton(
                onPressed: () {
                  // End the focus portion
                  // We do NOT end the session here—just switch to break
                  _accumulateActiveTime();
                  setState(() {
                    isBreak = true;
                  });
                  _resetTimerWithoutEndingSession();                  
                  Navigator.of(context).pop();
                },
                child: const Text("Start break"),
              ),

            // If we are currently on break, user can continue the focus session
            if (isBreak)
              TextButton(
                onPressed: () {
                  // End the break portion
                  _accumulateActiveTime();
                  setState(() {
                    isBreak = false;
                  });
                  _resetTimerWithoutEndingSession();
                  Navigator.of(context).pop();
                },
                child: const Text("Continue focus"),
              ),
          ],
        );
      },
    );
  }

  /// Reset the timer to default state.
  ///
  /// This is called when the user chooses "Reset" from the dialog or the refresh button.
  /// This will effectively end the session and start a new one when user presses play again.
  void _resetTimer() {
    setState(() {
      isPaused = true;
      // If we are in break mode, reset to breakDuration, else focusDuration
      remainingTime = isBreak ? breakDuration : focusDuration;
    });

    _timerKey.currentState?.reset();
    timer?.cancel();

    // Also clear out the partial accumulation so the next start is a new session
    sessionStart = null;
    lastResumeTime = null;
    totalFocusTime = Duration.zero;
    totalBreakTime = Duration.zero;
  }

  /// Reset the timer but *do not* end the entire session.
  ///
  /// This is used for switching from focus to break or break to focus mid-session.
  void _resetTimerWithoutEndingSession() {
    setState(() {
      isPaused = true;
      remainingTime = isBreak ? breakDuration : focusDuration;
    });

    _timerKey.currentState?.reset();
    timer?.cancel();
    lastResumeTime = null;
  }

  /// Called when we want to end the session completely and store data.
  Future<void> _endSessionAndSave() async {
    // Accumulate any final active time
    _accumulateActiveTime();
    // The session ends now
    final sessionEnd = DateTime.now();

    // If sessionStart is null, it means no actual timer usage occurred
    // (User might have pressed reset right away).
    if (sessionStart == null) return;

    // Prepare session data
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    final sessionData = {
      'sessionId': sessionId,
      'startDateTime': sessionStart.toString(),
      'endDateTime': sessionEnd.toString(),
      'totalFocusTime': totalFocusTime.inSeconds,
      'totalBreakTime': totalBreakTime.inSeconds,
    };

    // Save to shared prefs
    final prefs = await SharedPreferences.getInstance();
    final sessionList = prefs.getStringList('sessions') ?? [];
    sessionList.add(jsonEncode(sessionData));
    await prefs.setStringList('sessions', sessionList);

    debugPrint("Session saved: $sessionData");
  }

  /// Accumulate active time (focus or break) from lastResumeTime to now.
  /// This is how we ensure pausing does not inflate the totals.
  void _accumulateActiveTime() {
    if (lastResumeTime != null) {
      final diff = DateTime.now().difference(lastResumeTime!);
      if (isBreak) {
        totalBreakTime += diff;
      } else {
        totalFocusTime += diff;
      }
      lastResumeTime = null;
    }
  }

  /// Update the focus or break duration based on whether we are in break or focus mode.
  /// If you only want to allow changing focus time, ignore the `isBreak` check.
  void _updateDuration(int newDurationInSeconds) {
    setState(() {
      if (isBreak) {
        // If you want to allow editing break time:
        breakDuration = newDurationInSeconds;
        remainingTime = breakDuration;
      } else {
        focusDuration = newDurationInSeconds;
        remainingTime = focusDuration;
      }
    });
    // Update the DCircularTimer widget
    _timerKey.currentState?.updateDuration(remainingTime);
  }

  /// Toggle edit mode
  void _editTimer() {
    // We treat editing as always editing the currently active mode's duration
    _resetTimerWithoutEndingSession();
    setState(() {
      isEditing = true;
      final current = isBreak ? breakDuration : focusDuration;
      final hours = current ~/ 3600;
      final minutes = (current % 3600) ~/ 60;
      final seconds = current % 60;

      _hoursController.text = hours.toString();
      _minutesController.text = minutes.toString();
      _secondsController.text = seconds.toString();
    });
  }

  /// Save new time entered in edit mode
  void _saveNewTime() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final newDuration = (hours * 3600) + (minutes * 60) + seconds;

    if (newDuration > 0) {
      _updateDuration(newDuration);
      setState(() {
        isEditing = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid duration.")),
      );
    }
  }

  /// Format the time for display
  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pomodoro Timer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            // Navigate to your analytics screen
            context.pushNamed(RouteConstants.analytics);
          },
          icon: const Icon(Icons.analytics),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () {
                context.pushNamed(RouteConstants.settings);
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Timer
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: DCircularTimer(
                  key: _timerKey,
                  durationInSeconds: remainingTime,
                  fgColor: isBreak ? Colors.yellow : Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Time Display or Editor
          if (isEditing)
            Column(
              children: [
                Padding(
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
                ),
                const SizedBox(height: 20),
                DElevatedButton(
                  buttonColor: tWhite,
                  textColor: tBlack,
                  onPressed: _saveNewTime,
                  child: const Text("Save"),
                ),
              ],
            )
          else
            Text(
              _formatTime(remainingTime),
              style: GoogleFonts.barlowCondensed(
                fontWeight: FontWeight.w900,
                fontSize: 95,
              ),
            ),

          const SizedBox(height: 20),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundButton(
                icon: Icons.refresh,
                onPressed: isEditing
                    ? null
                    : () async {
                        // If we're currently running, end the session
                        if (!isPaused) {
                          await _endSessionAndSave();
                        }
                        _resetTimer();
                      },
              ),
              RoundButton(
                icon: isPaused ? Icons.play_arrow : Icons.pause,
                onPressed: isEditing ? null : _startOrPauseTimer,
              ),
              RoundButton(
                icon: Icons.edit,
                onPressed: isEditing ? null : _editTimer,
                selected: isEditing,
              ),
            ],
          ),
          const DGap(multiplier: 10),
        ],
      ),
    );
  }

  /// Helper widget for editing hours/minutes/seconds
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
      ),
    );
  }
}