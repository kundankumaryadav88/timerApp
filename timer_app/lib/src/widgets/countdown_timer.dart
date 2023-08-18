import 'package:flutter/material.dart';
import 'package:timer_app/src/models/timer_item.dart';

class CountdownTimer extends StatelessWidget {
  final TimerItem timerItem;
  final int index;

  const CountdownTimer({Key? key, required this.timerItem, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: timerItem.timerStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!);
        }
        return Text(
          "${timerItem.minutes.toString().padLeft(2, '0')}:${timerItem.seconds.toString().padLeft(2, '0')}   ",
        );
      },
    );
  }
}
