import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repository/timer_controller.dart';

final timerControllerProvider = StateNotifierProvider<TimerController, TimerState>((ref) {
  return TimerController();
});