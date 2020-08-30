import 'package:client/api/models/application.dart';
import 'package:client/api/sound_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplicationItem extends StatefulWidget {
  final ApplicationModel app;
  final bool isOutput;

  ApplicationItem(this.app, {this.isOutput});

  @override
  _ApplicationItemState createState() =>
      _ApplicationItemState(this.app.volume.first, this.app.mute);
}

class _ApplicationItemState extends State<ApplicationItem> {
  double volume;
  bool mute;

  _ApplicationItemState(this.volume, this.mute);

  @override
  Widget build(BuildContext context) {
    SoundApi api = context.repository();
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: SvgPicture.network(
                'http://192.168.1.13:5560/api/icons/${widget.app.icon}',
                placeholderBuilder: (context) =>
                    Icon(widget.isOutput ? Icons.speaker : Icons.mic)),
            title: Text(widget.app.name),
            subtitle: Text(widget.app.stream),
            trailing: IconButton(
                icon: Icon(mute ? Icons.volume_off : Icons.volume_up),
                onPressed: () {
                  setState(() {
                    mute = !mute;
                  });
                  if (widget.isOutput) {
                    api.togglePlaybackMute(widget.app.cursor, !mute);
                  } else {
                    api.toggleRecordingMute(widget.app.cursor, !mute);
                  }
                }),
          ),
          Slider(
              value: this.volume.clamp(0, 1),
              onChanged: (value) {
                setState(() {
                  this.volume = value;
                });
                if (widget.isOutput) {
                  api.changePlaybackVolume(widget.app.cursor, value);
                } else {
                  api.changeRecordingVolume(widget.app.cursor, value);
                }
              })
        ],
      ),
    );
  }
}
