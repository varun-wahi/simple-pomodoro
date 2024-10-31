import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:async';

import '../../../../config/theme/text_styles.dart';
import '../../../../core/util/constants/color_grid.dart';
import '../../../../core/util/constants/sizes.dart';
import '../../../../core/util/widgets/d_gap.dart';
import '../widgets/d_circular_timer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<DCircularTimerState> _timerKey =
      GlobalKey<DCircularTimerState>();
  bool isPaused = true;
  bool isEditing = false;
  int totalDuration = 150; // Total duration in seconds (2:30)
  int remainingTime = 150;
  Timer? timer;

  // Controllers for hours, minutes, and seconds fields
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void reset() {
    setState(() {
      isPaused = true;
      remainingTime = totalDuration;
      _updateTimeFields();
      isEditing = false;
    });
    _timerKey.currentState?.reset();
  }

  void updateDuration(int seconds) {
    setState(() {
      totalDuration = seconds;
      remainingTime = seconds;
      _updateTimeFields();
    });
    _timerKey.currentState?.updateDuration(seconds);
  }

  void startOrPause() {
    setState(() {
      isPaused = !isPaused;
    });
    if (isPaused) {
      _timerKey.currentState?.pause();
    } else {
      _timerKey.currentState?.start();
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void editTimer() {
    reset(); // Reset the timer to prevent conflicts
    setState(() {
      isEditing = true;
    });
  }

  void saveNewTime() {
    final hours = int.tryParse(_hoursController.text) ?? 0;
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;

    final newDuration = (hours * 3600) + (minutes * 60) + seconds;
    updateDuration(newDuration);

    setState(() {
      isEditing = false;
    });
  }

  void _updateTimeFields() {
    final hours = remainingTime ~/ 3600;
    final minutes = (remainingTime % 3600) ~/ 60;
    final seconds = remainingTime % 60;

    _hoursController.text = hours.toString().padLeft(2, '0');
    _minutesController.text = minutes.toString().padLeft(2, '0');
    _secondsController.text = seconds.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      appBar: AppBar(
        backgroundColor: tWhite,
        foregroundColor: tBlack,
        title: const Text("Timer"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: DCircularTimer(
                    key: _timerKey,
                    color: tRed,
                    durationInSeconds: totalDuration,
                  ),
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
          const DGap(multiplier: 5),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildRoundButton(
                  icon: Icons.refresh_rounded,
                  onPressed:
                      isEditing ? null : reset, // Disable reset in edit mode
                ),
                _buildRoundButton(
                  icon:
                      isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  onPressed: isEditing
                      ? null
                      : startOrPause, // Disable play/pause in edit mode
                ),
                _buildRoundButton(
                  icon: Icons.edit,
                  onPressed: editTimer,
                  selected: isEditing, // Highlight the edit button if editing
                ),
              ],
            ),
          ),
          const DGap(multiplier: 10),
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
        style: boldHeading(color: tBlack, size: 35),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(dBorderRadius),
            borderSide: const BorderSide(color: tBlack, width: 0.3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(dBorderRadius),
            borderSide: const BorderSide(color: tBlack, width: 0.7),
          ),
        ),
        onSubmitted: (_) => saveNewTime(),
      ),
    );
  }

  Widget _buildRoundButton(
      {required IconData icon,
      required VoidCallback? onPressed,
      bool selected = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: dPadding * 2),
        padding: const EdgeInsets.all(dPadding * 2),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.blueGrey.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: selected ? tWhite : tBlack, size: 40),
      ),
    );
  }
}