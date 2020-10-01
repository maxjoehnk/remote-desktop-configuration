import 'package:byte_size/byte_size.dart';
import 'package:client/api/disks_api.dart';
import 'package:client/api/models/mount.dart';
import 'package:client/shared/responsive_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisksRoute extends StatelessWidget {
  static const routeName = '/disks';
  static const icon = Icons.storage;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(title: Text('Disks')),
      child: DiskList(),
    );
  }
}

class DiskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DisksApi api = context.repository();
    return FutureBuilder(
      future: api.listMounts(),
      builder: (context, AsyncSnapshot<List<MountModel>> state) {
        if (state.hasData) {
          return ListView(
            children: state.data.map((e) => DiskCard(e)).toList(),
          );
        }
        return Container();
      },
    );
  }
}

class DiskCard extends StatelessWidget {
  final MountModel mount;

  DiskCard(this.mount);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(children: [
          ListTile(
            title: Text(this.mount.path),
            subtitle: Text(this.mount.name),
            trailing: Text('Free: $freeSpace'),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('$usedSpace / $totalSpace'),
            ),
            LinearProgressIndicator(
              value: this.mount.used / this.mount.total,
            )
          ])
        ]),
      ),
    );
  }

  String get freeSpace {
    return prettyPrintBytes(this.mount.free);
  }

  String get usedSpace {
    return prettyPrintBytes(this.mount.used);
  }

  String get totalSpace {
    return prettyPrintBytes(this.mount.total);
  }

  String prettyPrintBytes(int bytes) {
    var byteSize = ByteSize(bytes);
    if (byteSize.TeraBytes > 1) {
      return byteSize.toString('TB');
    }
    if (byteSize.GigaBytes > 1) {
      return byteSize.toString('GB');
    }
    return byteSize.toString('MB');
  }
}
