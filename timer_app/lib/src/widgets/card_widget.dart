import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/src/bloc/timer_bloc.dart';
import 'package:timer_app/src/bloc/timer_event.dart';
import 'package:timer_app/src/models/timer_item.dart';
import 'package:timer_app/src/widgets/countdown_timer.dart';

class CardWidget extends StatelessWidget {
  final TimerItem timerItem;
  final int index;

  const CardWidget({Key? key, required this.timerItem, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      color: timerItem.timerColorNotifier.value,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // Set the border color to black
            width: 2.0, // Set the border width
          ),
        ),
        child: ListTile(
          title: CountdownTimer(timerItem: timerItem, index: index),
          subtitle: Text(
            timerItem.text,
            style: TextStyle(color: Colors.white),
          ),
          trailing: IconButton(
            icon: Icon(
              timerItem.isRunning ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () {
              context.read<TimerBloc>().add(ToggleTimer(index));
            },
          ),
        ),
      ),
    );
  }
}
