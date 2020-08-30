import 'package:client/api/models/device_channel.dart';
import 'package:client/api/sound_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceItem extends StatefulWidget {
  final DeviceChannelModel device;
  final bool isOutput;

  DeviceItem(this.device, {this.isOutput});

  @override
  _DeviceItemState createState() => _DeviceItemState(device.volume.first, device.mute);
}

class _DeviceItemState extends State<DeviceItem> {
  double volume;
  bool mute;

  _DeviceItemState(this.volume, this.mute);

  @override
  Widget build(BuildContext context) {
    SoundApi api = context.repository();
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(widget.isOutput ? Icons.speaker : Icons.mic),
            title: Text(widget.device.name),
            trailing: IconButton(icon: Icon(mute ? Icons.volume_off : Icons.volume_up), onPressed: () {
              setState(() {
                mute = !mute;
              });
              if (widget.isOutput) {
                api.toggleOutputMute(widget.device.cursor, !mute);
              }else {
                api.toggleInputMute(widget.device.cursor, !mute);
              }
            }),
          ),
          Slider(value: volume.clamp(0, 1), onChanged: (value) {
            setState(() {
              this.volume = value;
            });
            if (widget.isOutput) {
              api.changeOutputVolume(widget.device.cursor, value);
            }else {
              api.changeInputVolume(widget.device.cursor, value);
            }
          })
        ],
      ),
    );
  }
}
