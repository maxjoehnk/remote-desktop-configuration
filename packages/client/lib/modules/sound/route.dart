import 'package:client/api/models/application.dart';
import 'package:client/api/models/device_channel.dart';
import 'package:client/api/sound_api.dart';
import 'package:client/modules/sound/application_item.dart';
import 'package:client/modules/sound/device_item.dart';
import 'package:client/shared/sidenav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoundRoute extends StatefulWidget {
  static const routeName = '/sound';

  @override
  _SoundRouteState createState() => _SoundRouteState();
}

class _SoundRouteState extends State<SoundRoute> {
  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidenav(),
      appBar: AppBar(title: Text('Sound')),
      body: SoundRouteBody(activeTab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeTab,
        onTap: (tab) => this.setState(() {
          activeTab = tab;
        }),
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.black54,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow), title: Text('Playback')),
          BottomNavigationBarItem(
              icon: Icon(Icons.fiber_manual_record), title: Text('Recording')),
          BottomNavigationBarItem(
            icon: Icon(Icons.speaker),
            title: Text('Outputs'),
          ),
          BottomNavigationBarItem(icon: Icon(Icons.mic), title: Text('Inputs')),
          BottomNavigationBarItem(
              icon: Icon(Icons.devices), title: Text('Devices'))
        ],
      ),
    );
  }
}

class SoundRouteBody extends StatelessWidget {
  final int tab;

  SoundRouteBody(this.tab);

  @override
  Widget build(BuildContext context) {
    switch (this.tab) {
      case 0:
        return PlaybackList();
      case 1:
        return RecordingList();
      case 2:
        return OutputList();
      case 3:
        return InputList();
      case 4:
        return Container();
    }
  }
}

class PlaybackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SoundApi api = context.repository();
    return FutureBuilder(
      future: api.listPlayback(),
      builder: (context, AsyncSnapshot<List<ApplicationModel>> state) {
        if (state.hasData) {
          return ListView(
            children: state.data
                .map((app) => ApplicationItem(app, isOutput: true))
                .toList(),
          );
        }
        return Container();
      },
    );
  }
}

class RecordingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SoundApi api = context.repository();
    return FutureBuilder(
      future: api.listRecording(),
      builder: (context, AsyncSnapshot<List<ApplicationModel>> state) {
        if (state.hasData) {
          return ListView(
            children: state.data
                .map((app) => ApplicationItem(app, isOutput: false))
                .toList(),
          );
        }
        return Container();
      },
    );
  }
}

class OutputList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SoundApi api = context.repository();
    return FutureBuilder(
      future: api.listOutputs(),
      builder: (context, AsyncSnapshot<List<DeviceChannelModel>> state) {
        if (state.hasData) {
          return ListView(
            children: state.data
                .map((device) => DeviceItem(device, isOutput: true))
                .toList(),
          );
        }
        return Container();
      },
    );
  }
}

class InputList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SoundApi api = context.repository();
    return FutureBuilder(
      future: api.listInputs(),
      builder: (context, AsyncSnapshot<List<DeviceChannelModel>> state) {
        if (state.hasData) {
          return ListView(
            children: state.data
                .map((device) => DeviceItem(device, isOutput: false))
                .toList(),
          );
        }
        return Container();
      },
    );
  }
}
