import 'package:timer_app/src/models/timer_item.dart';

class TimerState {}

class TimerLoadedState extends TimerState {
  final List<TimerItem> timerItems;

  TimerLoadedState(this.timerItems);
}
