import 'package:flutter/material.dart';
import 'package:timer_app/src/models/timer_item.dart';

// Events
class TimerEvent {}

class AddTimer extends TimerEvent {
  final TimerItem timerItem;

  AddTimer(this.timerItem);
}

class ToggleTimer extends TimerEvent {
  final int index;

  ToggleTimer(this.index);
}

class StartPausedTimer extends TimerEvent {
  final int index;

  StartPausedTimer(this.index);
}

class RemoveTimerItem extends TimerEvent {
  final TimerItem timerItem;

  RemoveTimerItem(this.timerItem);
}

class UpdateTimerColor extends TimerEvent {
  final TimerItem timerItem;

  UpdateTimerColor(this.timerItem);
}

class UpdatePausedColor extends TimerEvent {
  final Color color;

  UpdatePausedColor(this.color);
}
