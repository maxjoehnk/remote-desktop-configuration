import 'package:client/shared/sidenav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControllerRoute extends StatelessWidget {
  static const routeName = '/controllers';
  static const icon = Icons.gamepad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidenav(),
      appBar: AppBar(title: Text('Controllers')),
      body: Container(),
    );
  }
}
