import 'package:client/shared/responsive_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControllerRoute extends StatelessWidget {
  static const routeName = '/controllers';
  static const icon = Icons.gamepad;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(title: Text('Controllers')),
      child: Container(),
    );
  }
}
