import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/ui/my_screen.dart';
import 'src/bloc/timer_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(),
        child: MyScreen(),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Timer App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: BlocProvider(
//         create: (context) => TimerBloc(),
//         child: MyScreen(),
//       ),
//     );
//   }
// }

// class MyScreen extends StatelessWidget {
//   final TextEditingController _minuteController = TextEditingController();
//   final TextEditingController _secondController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Timer List"),
//       ),
//       body: CustomScrollView(
//         slivers: [
//           SliverToBoxAdapter(
//             child: Container(
//               color: Colors.yellow,
//               height: MediaQuery.of(context).size.height * 0.2,
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _minuteController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(labelText: "Minutes"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       controller: _secondController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(labelText: "Seconds"),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   ElevatedButton(
//                     onPressed: () {
//                       int minutes = int.tryParse(_minuteController.text) ?? 0;
//                       int seconds = int.tryParse(_secondController.text) ?? 0;

//                       if (minutes > 59) {
//                         minutes = 59;
//                       }
//                       if (seconds > 59) {
//                         seconds = 59;
//                       }

//                       if (minutes > 0 || seconds > 0) {
//                         final TimerItem timerItem = TimerItem(
//                             minutes: minutes,
//                             seconds: seconds,
//                             context: context);
//                         BlocProvider.of<TimerBloc>(context)
//                             .add(AddTimer(timerItem));
//                       }

//                       _minuteController.clear();
//                       _secondController.clear();
//                     },
//                     child: const Text("Add"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           BlocBuilder<TimerBloc, TimerState>(
//             builder: (context, state) {
//               if (state is TimerLoadedState) {
//                 return SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       final TimerItem timerItem = state.timerItems[index];

//                       return Card(
//                         color: timerItem.timerColor,
//                         child: ListTile(
//                           title: CountdownTimer(
//                             timerItem: timerItem,
//                             index: index,
//                           ),
//                           trailing: IconButton(
//                             icon: Icon(
//                               timerItem.isRunning
//                                   ? Icons.pause
//                                   : Icons.play_arrow,
//                             ),
//                             onPressed: () {
//                               context.read<TimerBloc>().add(ToggleTimer(index));
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                     childCount: state.timerItems.length,
//                   ),
//                 );
//               } else {
//                 return const Center(
//                   child: Text("Please Add Data"),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TimerEvent {}

// class AddTimer extends TimerEvent {
//   final TimerItem timerItem;

//   AddTimer(this.timerItem);
// }

// class ToggleTimer extends TimerEvent {
//   final int index;

//   ToggleTimer(this.index);
// }

// class StartPausedTimer extends TimerEvent {
//   final int index;

//   StartPausedTimer(this.index);
// }

// class RemoveTimerItem extends TimerEvent {
//   final TimerItem timerItem;

//   RemoveTimerItem(this.timerItem);
// }

// class TimerState {}

// class TimerLoadedState extends TimerState {
//   final List<TimerItem> timerItems;

//   TimerLoadedState(this.timerItems);
// }

// class TimerBloc extends Bloc<TimerEvent, TimerState> {
//   List<TimerItem> _timerItems = [];

//   TimerBloc() : super(TimerLoadedState([])) {
//     on<AddTimer>((event, emit) {
//       if (_timerItems.length < 10) {
//         _timerItems.add(event.timerItem);
//         emit(TimerLoadedState(List.from(_timerItems)));
//       }
//     });

//     on<ToggleTimer>((event, emit) {
//       _timerItems[event.index].toggleTimer();
//       _timerItems[event.index].updateColor();

//       if (!_timerItems[event.index].isRunning) {
//         _timerItems[event.index].pauseTimer();
//         _timerItems[event.index].updateColor();
//       }

//       emit(TimerLoadedState(List.from(_timerItems)));
//     });

//     on<StartPausedTimer>((event, emit) {
//       _timerItems[event.index].resumeTimer();

//       emit(TimerLoadedState(List.from(_timerItems)));
//     });

//     on<RemoveTimerItem>((event, emit) {
//       event.timerItem.dispose();
//       _timerItems.remove(event.timerItem);
//       emit(TimerLoadedState(List.from(_timerItems)));
//     });
//   }
// }

// class TimerItem {
//   int minutes;
//   int seconds;
//   bool isRunning;
//   final BuildContext context;
//   late StreamController<String> streamController;
//   late Stream<String> timerStream;
//   Timer? timer;
//   ValueNotifier<Color> timerColorNotifier; // Added ValueNotifier for color

//   TimerItem({
//     required this.minutes,
//     required this.seconds,
//     this.isRunning = true,
//     required this.context,
//     Color initialColor = Colors.green,
//   })  : streamController = StreamController<String>.broadcast(),
//         timerColorNotifier = ValueNotifier<Color>(initialColor) {
//     timerStream = streamController.stream;

//     if (isRunning) {
//       startTimer();
//     }
//   }

//   Color get timerColor => timerColorNotifier.value;

//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       Duration duration = Duration(minutes: minutes, seconds: seconds);
//       duration -= const Duration(seconds: 1);

//       if (duration.inSeconds <= 0) {
//         timer.cancel();
//         streamController.add("00:00");
//         streamController.close();
//         context.read<TimerBloc>().add(RemoveTimerItem(this));
//       } else {
//         minutes = duration.inMinutes;
//         seconds = duration.inSeconds % 60;
//         String timeString =
//             "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//         streamController.add(timeString);
//         updateColor();
//       }
//     });
//   }

//   void updateColor() {
//     if (minutes > 0 || seconds > 30) {
//       timerColorNotifier.value = Colors.green;
//     } else {
//       timerColorNotifier.value = Colors.red;
//     }
//   }

//   void toggleTimer() {
//     if (isRunning) {
//       pauseTimer();
//     } else {
//       resumeTimer();
//     }
//   }

//   void pauseTimer() {
//     timer?.cancel();
//     isRunning = false;
//   }

//   void resumeTimer() {
//     if (!isRunning) {
//       isRunning = true;
//       startTimer();
//     }
//   }

//   void dispose() {
//     timer?.cancel();
//     streamController.close();
//     timerColorNotifier.dispose();
//   }
// }

// class CountdownTimer extends StatelessWidget {
//   final TimerItem timerItem;
//   final int index;

//   const CountdownTimer({Key? key, required this.timerItem, required this.index})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<String>(
//       stream: timerItem.timerStream,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return Text(snapshot.data!);
//         }
//         return Text(
//           "${timerItem.minutes.toString().padLeft(2, '0')}:${timerItem.seconds.toString().padLeft(2, '0')}",
//         );
//       },
//     );
//   }
// }
