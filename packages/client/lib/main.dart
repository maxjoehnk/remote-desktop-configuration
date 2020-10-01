import 'package:client/api/disks_api.dart';
import 'package:client/api/monitoring_api.dart';
import 'package:client/api/sound_api.dart';
import 'package:client/api/game_api.dart';
import 'package:client/modules/bluetooth/route.dart';
import 'package:client/modules/controllers/route.dart';
import 'package:client/modules/disks/route.dart';
import 'package:client/modules/games/route.dart';
import 'package:client/modules/monitoring/route.dart';
import 'package:client/modules/sound/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => SoundApi("192.168.1.13")),
        RepositoryProvider(create: (context) => GameApi("192.168.1.13")),
        RepositoryProvider(create: (context) => MonitoringApi("192.168.1.13")),
        RepositoryProvider(create: (context) => DisksApi("192.168.1.13")),
      ],
      child: MaterialApp(
        title: 'Remote Desktop Configuration',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: SoundRoute.routeName,
        routes: {
          SoundRoute.routeName: (context) => SoundRoute(),
          BluetoothRoute.routeName: (context) => BluetoothRoute(),
          GameRoute.routeName: (context) => GameRoute(),
          ControllerRoute.routeName: (context) => ControllerRoute(),
          MonitoringRoute.routeName: (context) => MonitoringRoute(),
          DisksRoute.routeName: (context) => DisksRoute(),
        },
      ),
    );
  }
}
