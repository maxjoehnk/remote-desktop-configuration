import 'package:client/modules/bluetooth/route.dart';
import 'package:client/modules/sound/route.dart';
import 'package:flutter/material.dart';

class Sidenav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          NavItem('Sound', SoundRoute.routeName, icon: Icons.volume_up),
          NavItem('Bluetooth', BluetoothRoute.routeName, icon: Icons.bluetooth)
        ],
      )
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