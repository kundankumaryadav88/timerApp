import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/src/bloc/timer_bloc.dart';
import 'package:timer_app/src/bloc/timer_event.dart';

class TimerItem {
  int minutes;
  int seconds;
  bool isRunning;
  String text;
  final BuildContext context;
  late StreamController<String> streamController;
  late Stream<String> timerStream;
  Timer? timer;

  late ValueNotifier<Color> timerColorNotifier;

  TimerItem({
    required this.minutes,
    required this.text,
    required this.seconds,
    this.isRunning = true,
    required this.context,
  })  : streamController = StreamController<String>.broadcast(),
        timerColorNotifier = ValueNotifier<Color>(Colors.green) {
    timerStream = streamController.stream;

    if (isRunning) {
      startTimer();
    }
  }

  void updateColor() {
    if (isRunning) {
      if (minutes > 0 || seconds > 30) {
        timerColorNotifier.value = Colors.green;
      } else {
        timerColorNotifier.value = Colors.red;
      }
    } else {
      timerColorNotifier.value =
          Colors.yellow; // Set color to yellow when paused
    }
    context.read<TimerBloc>().add(UpdateTimerColor(this));
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Duration duration = Duration(minutes: minutes, seconds: seconds);
      duration -= const Duration(seconds: 1);

      if (duration.inSeconds <= 0) {
        timer.cancel();
        streamController.add("00:00");
        streamController.close();
        context.read<TimerBloc>().add(RemoveTimerItem(this));
      } else {
        minutes = duration.inMinutes;
        seconds = duration.inSeconds % 60;
        String timeString =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
        streamController.add(timeString);
        updateColor();
      }
    });
  }

  void toggleTimer() {
    if (isRunning) {
      pauseTimer();
    } else {
      resumeTimer();
    }
  }

  void pauseTimer() {
    timer?.cancel();
    isRunning = false;
  }

  void resumeTimer() {
    if (!isRunning) {
      isRunning = true;
      startTimer();
    }
  }

  void dispose() {
    timer?.cancel();
    streamController.close();
  }
}
