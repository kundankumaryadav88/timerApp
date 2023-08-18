import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/src/bloc/timer_event.dart';
import 'package:timer_app/src/bloc/timer_state.dart';
import 'package:timer_app/src/models/timer_item.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  List<TimerItem> _timerItems = [];

  TimerBloc() : super(TimerLoadedState([]));

  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is AddTimer) {
      if (_timerItems.length < 10) {
        _timerItems.add(event.timerItem);
        yield TimerLoadedState(List.from(_timerItems));
      }
    } else if (event is ToggleTimer) {
      _timerItems[event.index].toggleTimer();
      yield TimerLoadedState(List.from(_timerItems));
    } else if (event is RemoveTimer) {
      _timerItems[event.index].dispose();
      _timerItems.removeAt(event.index);
      yield TimerLoadedState(List.from(_timerItems));
    }
  }
}
