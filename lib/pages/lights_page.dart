// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/API/api.dart';
import 'package:van_controller_app/global_settings.dart';

import '../DataModel/data_model.dart';

class LightsStatus {
  double? r;
}

class LightsPage extends StatelessWidget {
  const LightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    AbstractApi api = context.read<GlobalSettings>().api;
    return LightsWidget(api);
  }
}

class LightsWidget extends StatefulWidget {
  const LightsWidget(this.api, {super.key});
  final AbstractApi api;

  @override
  State<LightsWidget> createState() => _LightsWidgetState();
}

class _LightsWidgetState extends State<LightsWidget> {

  //LightsModel get lightsModel => lights;

  late LightsModel model;

  late bool isOn;
  late double r;
  late double g;
  late double b;

  @override
  void initState() {
    print('_LightsWidgetState initState');
    super.initState();
    model = LightsModel(widget.api, updateCallback: _onLightsUpdate);
    _onLightsUpdate();
  }

  void _onLightsUpdate() {
    print('_onLightsUpdate called');
    setState(() {
      isOn = model.isOn;
      r = model.r < LightsModel.min ? LightsModel.min :
        model.r > LightsModel.max ? LightsModel.max :
          model.r;
      g = model.g < LightsModel.min ? LightsModel.min :
        model.g > LightsModel.max ? LightsModel.max :
          model.g;
      b = model.b < LightsModel.min ? LightsModel.min :
        model.b > LightsModel.max ? LightsModel.max :
          model.b;
    });
  }


  @override
  Widget build(BuildContext context) {
    print('_LightsWidgetState rebuilt');

    return Container(
      padding: EdgeInsets.all(22),
      //color: Colors.white,

        child: SizedBox(
          height: 250,
          child: Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          'Lights',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text('on/off'),
                        leading: Icon(Icons.power_settings_new),
                      ),
                    ),
                    Switch(
                        value: isOn,
                        onChanged: (value) {
                          model.on();
                          setState(() => isOn = value);
                        }
                    ),
                  ],
                ),
                Slider(
                  label: 'red',
                  activeColor: Colors.red,
                  value: r,
                  min: LightsModel.min,
                  max: LightsModel.max,
                  onChangeEnd: (double value) => model.setRed(value),
                  onChanged: (value) => setState(() { r = value; }),
                ),
                Slider(
                  activeColor: Colors.green,
                  label: 'green',
                  value: g,
                  min: LightsModel.min,
                  max: LightsModel.max,
                  onChangeEnd: (double value) => model.setGreen(value),
                  onChanged: (value) => setState(() { g = value; }),
                ),
                Slider(
                  activeColor: Colors.blue,
                  label: 'blue',
                  value: b,
                  min: LightsModel.min,
                  max: LightsModel.max,
                  onChangeEnd: (double value) => model.setBlue(value),
                  onChanged: (value) => setState(() { b = value; }),
                ),
                Divider(),
              ],
            ),
          ),
        ),
    );
  }
}


