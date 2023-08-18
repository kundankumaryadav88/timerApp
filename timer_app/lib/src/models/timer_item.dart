import 'dart:async';

class TimerItem {
  int minutes;
  int seconds;
  bool isRunning;
  late StreamController<String> streamController;
  late Stream<String> timerStream;
  Timer? timer;

  TimerItem({
    required this.minutes,
    required this.seconds,
    this.isRunning = true,
  }) : streamController = StreamController<String>() {
    timerStream = streamController.stream;
    if (isRunning) {
      startTimer();
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Duration duration = Duration(minutes: minutes, seconds: seconds);
      duration -= const Duration(seconds: 1);

      if (duration.inSeconds <= 0) {
        timer.cancel();
        streamController.add("00:00");
        streamController.close();
      } else {
        minutes = duration.inMinutes;
        seconds = duration.inSeconds % 60;
        streamController.add(
          "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
        );
      }
    });
  }

  void toggleTimer() {
    if (isRunning) {
      timer?.cancel();
      streamController.close();
    } else {
      if (!streamController.isClosed) {
        startTimer();
      }
    }
    isRunning = !isRunning;
  }

  void dispose() {
    timer?.cancel();
    streamController.close();
  }
}
