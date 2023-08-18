import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/src/bloc/timer_event.dart';
import 'package:timer_app/src/bloc/timer_state.dart';
import 'package:timer_app/src/models/timer_item.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  List<TimerItem> _timerItems = [];

  TimerBloc() : super(TimerLoadedState([])) {
    on<AddTimer>((event, emit) {
      if (_timerItems.length < 10) {
        _timerItems.add(event.timerItem);
        emit(TimerLoadedState(List.from(_timerItems)));
      }
    });

    on<ToggleTimer>((event, emit) {
      _timerItems[event.index].toggleTimer();

      // Update color when paused
      if (!_timerItems[event.index].isRunning) {
        _timerItems[event.index].updateColor();
      }

      emit(TimerLoadedState(List.from(_timerItems)));
    });

    on<StartPausedTimer>((event, emit) {
      _timerItems[event.index].resumeTimer();

      emit(TimerLoadedState(List.from(_timerItems)));
    });

    on<RemoveTimerItem>((event, emit) {
      event.timerItem.dispose();
      _timerItems.remove(event.timerItem);
      emit(TimerLoadedState(List.from(_timerItems)));
    });

    on<UpdateTimerColor>((event, emit) {
      emit(TimerLoadedState(List.from(_timerItems)));
    });

    on<UpdatePausedColor>((event, emit) {
      emit(TimerLoadedState(List.from(_timerItems)));
    });
  }
}
