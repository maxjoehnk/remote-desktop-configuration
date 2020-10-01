import 'package:client/modules/bluetooth/route.dart';
import 'package:client/modules/controllers/route.dart';
import 'package:client/modules/disks/route.dart';
import 'package:client/modules/games/route.dart';
import 'package:client/modules/monitoring/route.dart';
import 'package:client/modules/sound/route.dart';
import 'package:flutter/material.dart';

class Sidenav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(child: SidenavList());
  }
}

class SidenavList extends StatelessWidget {
  const SidenavList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: MediaQuery.of(context).padding,
      children: <Widget>[
        NavItem('Sound', SoundRoute.routeName, icon: SoundRoute.icon),
        NavItem('Bluetooth', BluetoothRoute.routeName, icon: BluetoothRoute.icon),
        NavItem('Games', GameRoute.routeName, icon: GameRoute.icon),
        NavItem('Controllers', ControllerRoute.routeName, icon: ControllerRoute.icon),
        NavItem('Sensors', MonitoringRoute.routeName, icon: MonitoringRoute.icon),
        NavItem('Disks', DisksRoute.routeName, icon: DisksRoute.icon),
      ],
    );
  }
}

class NavItem extends StatelessWidget {
  final String title;
  final String routeName;
  final IconData icon;

  const NavItem(this.title, this.routeName,
      {this.icon});

  @override
  Widget build(BuildContext context) {
    bool current = ModalRoute.of(context).settings.name == this.routeName;
    return Container(
      child: ListTile(
        title: Text(this.title),
        leading: this.icon == null
            ? null
            : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(this.icon),
        ),
        onTap: () => Navigator.popAndPushNamed(context, this.routeName),
      ),
      color: current ? Colors.deepOrangeAccent.withAlpha(64) : null,
    );
  }
}
