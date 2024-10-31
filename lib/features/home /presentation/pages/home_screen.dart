import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/util/constants/color_grid.dart';
import '../../../../core/util/widgets/d_gap.dart';
import '../riverpod/time_controller_notifier.dart';
import '../widgets/d_circular_timer.dart';
import '../widgets/text_input_field.dart';
import '../widgets/round_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerControllerProvider);
    final timerController = ref.read(timerControllerProvider.notifier);

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
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: DCircularTimer(
                  key: GlobalKey(),
                  color: tRed,
                  durationInSeconds: timerState.totalDuration,
                  remainingTime: timerState.remainingTime,  // Pass remainingTime
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          timerState.isEditing
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TimeInputField(
                        controller: TextEditingController(text: (timerState.remainingTime ~/ 3600).toString().padLeft(2, '0')),
                        hint: "HH",
                      ),
                      const Text(":", style: TextStyle(fontSize: 40)),
                      TimeInputField(
                        controller: TextEditingController(text: ((timerState.remainingTime % 3600) ~/ 60).toString().padLeft(2, '0')),
                        hint: "MM",
                      ),
                      const Text(":", style: TextStyle(fontSize: 40)),
                      TimeInputField(
                        controller: TextEditingController(text: (timerState.remainingTime % 60).toString().padLeft(2, '0')),
                        hint: "SS",
                      ),
                    ],
                  ),
                )
              : Text(
                  _formatTime(timerState.remainingTime),
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
                RoundButton(
                  icon: Icons.refresh_rounded,
                  onPressed: timerState.isEditing ? null : timerController.reset,
                ),
                RoundButton(
                  icon: timerState.isPaused
                      ? Icons.play_arrow_rounded
                      : Icons.pause_rounded,
                  onPressed: timerState.isEditing ? null : timerController.startOrPause,
                ),
                RoundButton(
                  icon: Icons.edit,
                  onPressed: timerController.editTimer,
                  selected: timerState.isEditing,
                ),
              ],
            ),
          ),
          const DGap(multiplier: 10),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }
}