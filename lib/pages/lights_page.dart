// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/API/api.dart';

import '../DataModel/data_model.dart';

class LightsStatus {
  double? r;
}

var record = ('first', a: 2, b: true, 'last');



class LightsPage extends StatelessWidget {
  const LightsPage({super.key});

  @override
  Widget build(BuildContext context) {

    Api api = context.read<Api>();
    debugPrint(record.toString());

    return LightsWidget(api);
  }
}

class LightsWidget extends StatefulWidget {
  const LightsWidget(this.api, {super.key});
  final Api api;

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
    // isOn = lights.isOn;
    // g = lights.g < LightsModel.MAX ? LightsModel.MAX : lights.g > model.MAX ? model.MAX : lights.g;
    // b = lights.b < LightsModel.MAX ? LightsModel.MAX : lights.b > model.MAX ? model.MAX : lights.b;
    // r = lights.r < LightsModel.MAX ? LightsModel.MAX : lights.r > model.MAX ? model.MAX : lights.r;
    _onLightsUpdate();
    print(r);
  }

  void _onLightsUpdate() {
    print('_onLightsUpdate called');
    setState(() {
      isOn = model.isOn;
      r = model.r < LightsModel.MIN ? LightsModel.MIN :
        model.r > LightsModel.MAX ? LightsModel.MAX :
          model.r;
      g = model.g < LightsModel.MIN ? LightsModel.MIN :
        model.g > LightsModel.MAX ? LightsModel.MAX :
          model.g;
      b = model.b < LightsModel.MIN ? LightsModel.MIN :
        model.b > LightsModel.MAX ? LightsModel.MAX :
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
                          print(value);
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
                  min: LightsModel.MIN,
                  max: LightsModel.MAX,
                  onChangeEnd: (double value) => model.setRed(value),
                  onChanged: (value) => setState(() { r = value; }),
                ),
                Slider(
                  activeColor: Colors.green,
                  label: 'green',
                  value: g,
                  min: LightsModel.MIN,
                  max: LightsModel.MAX,
                  onChangeEnd: (double value) => model.setGreen(value),
                  onChanged: (value) => setState(() { g = value; }),
                ),
                Slider(
                  activeColor: Colors.blue,
                  label: 'blue',
                  value: b,
                  min: LightsModel.MIN,
                  max: LightsModel.MAX,
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


