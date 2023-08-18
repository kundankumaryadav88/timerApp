import 'package:equatable/equatable.dart';
import 'package:timer_app/src/models/timer_item.dart';

// Events
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class AddTimer extends TimerEvent {
  final TimerItem timerItem;

  AddTimer(this.timerItem);

  @override
  List<Object> get props => [timerItem];
}

class ToggleTimer extends TimerEvent {
  final int index;

  ToggleTimer(this.index);

  @override
  List<Object> get props => [index];
}

class RemoveTimer extends TimerEvent {
  final int index;

  RemoveTimer(this.index);

  @override
  List<Object> get props => [index];
}
