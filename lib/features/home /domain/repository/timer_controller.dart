import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimerController extends StateNotifier<TimerState> {
  Timer? _timer;

  TimerController() : super(TimerState());

  void startOrPause() {
    if (state.isPaused) {
      _startTimer();
    } else {
      _pauseTimer();
    }
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remainingTime: state.totalDuration,
      isPaused: true,
      isEditing: false,
    );
    _updateTimeFields();
  }

  void updateDuration(int seconds) {
    state = state.copyWith(
      totalDuration: seconds,
      remainingTime: seconds,
    );
    _updateTimeFields();
  }

  void editTimer() {
    reset();
    state = state.copyWith(isEditing: true);
  }

  void saveNewTime(int hours, int minutes, int seconds) {
    final newDuration = (hours * 3600) + (minutes * 60) + seconds;
    updateDuration(newDuration);
    state = state.copyWith(isEditing: false);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPaused && state.remainingTime > 0) {
        state = state.copyWith(remainingTime: state.remainingTime - 1);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _updateTimeFields() {
    // Update logic for hours, minutes, and seconds based on remainingTime
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TimerState {
  final bool isPaused;
  final bool isEditing;
  final int totalDuration;
  final int remainingTime;

  TimerState({
    this.isPaused = true,
    this.isEditing = false,
    this.totalDuration = 150,
    this.remainingTime = 150,
  });

  TimerState copyWith({
    bool? isPaused,
    bool? isEditing,
    int? totalDuration,
    int? remainingTime,
  }) {
    return TimerState(
      isPaused: isPaused ?? this.isPaused,
      isEditing: isEditing ?? this.isEditing,
      totalDuration: totalDuration ?? this.totalDuration,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}