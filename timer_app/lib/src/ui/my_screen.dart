import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/src/bloc/timer_bloc.dart';
import 'package:timer_app/src/bloc/timer_event.dart';
import 'package:timer_app/src/bloc/timer_state.dart';
import 'package:timer_app/src/models/timer_item.dart';
import 'package:timer_app/src/widgets/card_widget.dart';

class MyScreen extends StatelessWidget {
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer List"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 34, 209, 198),
                  border: Border.all(color: Colors.blue, width: 4)),
              // color: Colors.grey,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: "Text"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _minuteController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Minutes"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _secondController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Seconds"),
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
                          context: context,
                          text: _textController.text,
                        );
                        BlocProvider.of<TimerBloc>(context)
                            .add(AddTimer(timerItem));
                      }

                      _minuteController.clear();
                      _secondController.clear();
                      _textController.clear();
                    },
                    child: const Text("Add"),
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

                      return CardWidget(timerItem: timerItem, index: index);
                    },
                    childCount: state.timerItems.length,
                  ),
                );
              } else {
                return const Center(
                  child: Text("Please Add Data"),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
