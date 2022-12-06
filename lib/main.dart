import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:workmanager/workmanager.dart';
import 'bloc/bloc.dart';
import 'database/database.dart';
import 'datasource/ds_indication.dart';
import 'model/indication.dart';
import 'ui/main_screen.dart';


const checkAndSaveTask = "flutter_homework_07.checkAndSaveTask";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch(task) {
      case checkAndSaveTask:
        final Battery battery = Battery();
        BatteryState batteryState = await battery.batteryState;
        final Connectivity connectivity = Connectivity();
        ConnectivityResult connectionStatus =
          await connectivity.checkConnectivity();
        final InternetConnectionChecker internetChecker =
        InternetConnectionChecker();
        InternetConnectionStatus internetStatus =
          await internetChecker.connectionStatus;
        final db = await provideDb();
        final indicationsDs = IndicationsDatasource(db);
        final indication = Indication(
          dateTime: DateTime.now(),
          charge: await battery.batteryLevel,
          isCharging: batteryState == BatteryState.charging,
          haveWiFi: connectionStatus == ConnectivityResult.wifi,
          haveInternet:
            internetStatus == InternetConnectionStatus.connected,
          );
        indicationsDs.saveIndication(indication);
        print("$checkAndSaveTask was executed");
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blackout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Blackout Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocProvider(
        create: (context) => IndicationsBloc(),
        child: const MainScreen(),
      ),
    );
  }
}
