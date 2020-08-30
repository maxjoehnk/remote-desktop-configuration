import 'package:client/shared/sidenav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluetoothRoute extends StatelessWidget {
  static const routeName = '/bluetooth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidenav(),
      appBar: AppBar(title: Text('Bluetooth')),
      body: Container(),
    );
  }
}
