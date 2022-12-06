import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework_07/main.dart';
import 'package:workmanager/workmanager.dart';
import '../bloc/bloc.dart';
import '../bloc/events.dart';
import '../bloc/states.dart';
import '../model/indication.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var listItems = <Indication>[];

  @override
  void initState() {
    super.initState();
    _showIndications();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: size.width * 0.7,
          child: ElevatedButton(
            onPressed: _showIndications,
            child: const Text('Refresh list of indications'),
          ),
        ),
        SizedBox(
          width: size.width * 0.7,
          child: ElevatedButton(
            onPressed: () async {
              Workmanager().registerOneOffTask(
                'oneOffTask',
                checkAndSaveTask,
              );
            },
            child: const Text('Add current indications'),
          ),
        ),
        SizedBox(
          width: size.width * 0.7,
          child: ElevatedButton(
            onPressed: () async {
              Workmanager().registerPeriodicTask(
                'periodicTask',
                checkAndSaveTask,
                frequency: const Duration(hours: 1),
              );
              print('Register 1 hour Periodic Task');
            },
            child: const Text('Check And Save Indications Every Hour'),
          ),
        ),
        SizedBox(
          width: size.width * 0.7,
          child: ElevatedButton(
            onPressed: () async {
              await Workmanager().cancelAll();
              print('Cancel all tasks completed');
            },
            child: const Text('Cancel All Tasks'),
          ),
        ),
        //const SizedBox(height: 16),
        BlocConsumer<IndicationsBloc, IndicationsState>(
          listener: (context, state) {
            if (state is IndicationsLoadedState) {
              listItems = state.indications;
            }
          },
          builder: (context, state) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      final item = listItems[index];
                      return Card(
                        elevation: 2,
                        child: Container(
                          width: double.infinity,
                          height: 48,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DateTimeStamp(dateTime: item.dateTime),
                              Text('${item.charge}%'),
                              (() {
                                if (item.isCharging) {
                                  return const Icon(
                                    Icons.battery_charging_full,
                                    color: Colors.blue,
                                  );
                                } else {
                                  return (() {
                                    if (item.charge < 9) {
                                      return const Icon(
                                        Icons.battery_0_bar,
                                        color: Colors.red,
                                      );
                                    } else if (item.charge < 24) {
                                      return const Icon(
                                        Icons.battery_1_bar,
                                        color: Colors.deepOrange,
                                      );
                                    } else if (item.charge < 39) {
                                      return const Icon(
                                        Icons.battery_2_bar,
                                        color: Colors.deepOrangeAccent,
                                      );
                                    } else if (item.charge < 54) {
                                      return const Icon(
                                        Icons.battery_3_bar,
                                        color: Colors.orange,
                                      );
                                    } else if (item.charge < 69) {
                                      return const Icon(
                                        Icons.battery_4_bar,
                                        color: Colors.orangeAccent,
                                      );
                                    } else if (item.charge < 84) {
                                      return const Icon(
                                        Icons.battery_5_bar,
                                        color: Colors.green,
                                      );
                                    } else if (item.charge < 99) {
                                      return const Icon(
                                        Icons.battery_6_bar,
                                        color: Colors.green,
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.battery_full,
                                        color: Colors.green,
                                      );
                                    }
                                  }());
                                }
                              }()),
                              (item.haveWiFi)
                                  ? const Icon(
                                      Icons.wifi,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.wifi_off,
                                      color: Colors.red,
                                    ),
                              (item.haveInternet)
                                  ? const Icon(
                                      Icons.cloud_queue_outlined,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.cloud_off_outlined,
                                      color: Colors.red,
                                    ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showIndications() {
    final bloc = BlocProvider.of<IndicationsBloc>(context);
    bloc.add(LoadIndicationsEvent());
  }
}

class DateTimeStamp extends StatelessWidget {
  const DateTimeStamp({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  String withLeadingZero(int number) {
    return (number < 10) ? '0$number' : '$number';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${withLeadingZero(dateTime.day)}.'
            '${withLeadingZero(dateTime.month)}.'
            '${dateTime.year}'),
        Text('${withLeadingZero(dateTime.hour)}:'
            '${withLeadingZero(dateTime.minute)}:'
            '${withLeadingZero(dateTime.second)}'),
      ],
    );
  }
}
