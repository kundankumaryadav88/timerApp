import 'package:equatable/equatable.dart';
import 'package:timer_app/src/models/timer_item.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object> get props => [];
}

class TimerLoadedState extends TimerState {
  final List<TimerItem> timerItems;

  TimerLoadedState(this.timerItems);

  @override
  List<Object> get props => [timerItems];
}
