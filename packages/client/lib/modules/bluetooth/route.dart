import 'package:client/shared/responsive_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluetoothRoute extends StatelessWidget {
  static const routeName = '/bluetooth';
  static const icon = Icons.bluetooth;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(title: Text('Bluetooth')),
      child: Container(),
    );
  }
}
