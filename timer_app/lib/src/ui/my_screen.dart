import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/src/bloc/timer_bloc.dart';
import 'package:timer_app/src/bloc/timer_event.dart';
import 'package:timer_app/src/bloc/timer_state.dart';
import 'package:timer_app/src/models/timer_item.dart';
import 'package:timer_app/src/widgets/countdown_timer.dart';

class MyScreen extends StatelessWidget {
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timer List"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.yellow,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minuteController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Minutes"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _secondController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Seconds"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      int minutes = int.tryParse(_minuteController.text) ?? 0;
                      int seconds = int.tryParse(_secondController.text) ?? 0;

                      if (minutes > 59) {
                        minutes = 59;
                      }
                      if (seconds > 59) {
                        seconds = 59;
                      }

                      if (minutes > 0 || seconds > 0) {
                        final TimerItem timerItem = TimerItem(
                          minutes: minutes,
                          seconds: seconds,
                        );
                        context
                            .read<TimerBloc>()
                            .add(AddTimer(timerItem)); // Updated here
                      }

                      _minuteController.clear();
                      _secondController.clear();
                    },
                    child: Text("Add"),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state is TimerLoadedState) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final TimerItem timerItem = state.timerItems[index];
                      if (timerItem.seconds == 0) {
                        context
                            .read<TimerBloc>()
                            .add(RemoveTimer(index)); // Updated here
                      }
                      Color timerColor = timerItem.isRunning
                          ? (timerItem.seconds < 30 ? Colors.red : Colors.green)
                          : Colors.yellow;

                      return Card(
                        color: timerColor,
                        child: ListTile(
                          title: CountdownTimer(
                            timerItem: timerItem,
                            index: index,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              timerItem.isRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () {
                              context
                                  .read<TimerBloc>()
                                  .add(ToggleTimer(index)); // Updated here
                            },
                          ),
                          onTap: () {
                            // Handle tap on the timer item if needed
                          },
                        ),
                      );
                    },
                    childCount: state.timerItems.length,
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(
                    child: Text("Please Add Data"),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
