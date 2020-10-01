import 'package:client/shared/sidenav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;
  final Widget appBar;
  final Widget bottomNavigationBar;

  ResponsiveScaffold({this.child, this.appBar, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    bool inlineSidenav = MediaQuery.of(context).size.width > 1000;
    debugPrint('inlineSidenav: $inlineSidenav');
    if (inlineSidenav) {
      return this.getDesktop(context);
    } else {
      return this.getMobile(context);
    }
  }

  Widget getMobile(BuildContext context) {
    return Scaffold(
      drawer: Sidenav(),
      appBar: appBar,
      body: child,
      bottomNavigationBar: this.bottomNavigationBar,
    );
  }

  Widget getDesktop(BuildContext context) {
    return Scaffold(
        appBar: this.appBar,
        body: Row(children: [
          Container(
            constraints: BoxConstraints.expand(width: 300),
            child: SidenavList(),
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 2, color: Colors.black12))),
          ),
          this.child
        ]),
        bottomNavigationBar: this.bottomNavigationBar);
  }
}
