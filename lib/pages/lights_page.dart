import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/API/api.dart';
import 'package:van_controller_app/components/dtata_container.dart';
import 'package:van_controller_app/global_settings.dart';

import '../DataModel/data_model.dart';

class LightsPage extends StatelessWidget {
  const LightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Api api = context.read<GlobalSettings>().api;
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

  late LightsModel model;
  Map<String, dynamic>? payload;

  late bool isOn;
  late double r;
  late double g;
  late double b;
  late FadeMode fadeMode;
  late double delay;
  late double upper;
  late double lower;

  @override
  void initState() {
    super.initState();
    model = LightsModel(widget.api, updateCallback: _onLightsUpdate);
    _onLightsUpdate();
  }

  void onPayloadClear() {
    print('Clearing lights payload');
    setState(() {
      model.clearPayload();
    });
  }

  void _onLightsUpdate() {
    setState(() {
      payload = model.payload;
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
      fadeMode = model.fadeMode;
      delay = model.delay;
      upper = model.upper;
      lower = model.lower;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(22),
      child: ListView(
        children: [
          SizedBox(
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
                        value: model.isOn,
                        onChanged: (value) {
                          setState(() {
                            isOn = value;
                          });
                          model.on();
                        }
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(LightsModel.min.toStringAsFixed(1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          showValueIndicator: ShowValueIndicator.onDrag,
                        ),
                        child: Slider(
                          label: 'red',
                          activeColor: Colors.red,
                          value: r,
                          min: LightsModel.min,
                          max: LightsModel.max,
                          onChangeEnd: (double value) => model.setRed(value),
                          onChanged: (value) => setState(() { r = value; }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(LightsModel.max.toStringAsFixed(1)),
                  ],
                ),
                Row(
                  children: [
                    Text(LightsModel.min.toStringAsFixed(1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          showValueIndicator: ShowValueIndicator.onDrag,
                        ),
                        child: Slider(
                          label: 'green',
                          activeColor: Colors.green,
                          value: g,
                          min: LightsModel.min,
                          max: LightsModel.max,
                          onChangeEnd: (double value) => model.setGreen(value),
                          onChanged: (value) => setState(() { g = value; }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(LightsModel.max.toStringAsFixed(1)),
                  ],
                ),
                Row(
                  children: [
                    Text(LightsModel.min.toStringAsFixed(1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          showValueIndicator: ShowValueIndicator.onDrag,
                        ),
                        child: Slider(
                          label: 'blue',
                          activeColor: Colors.blue,
                          value: b,
                          min: LightsModel.min,
                          max: LightsModel.max,
                          onChangeEnd: (double value) => model.setBlue(value),
                          onChanged: (value) => setState(() { b = value; }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(LightsModel.max.toStringAsFixed(1)),
                  ],
                ),

                Divider(),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              Text('Fading'),
              RadioGroup<FadeMode>(
                groupValue: model.fadeMode,
                onChanged:(FadeMode? value) {
                  model.send('');
                  setState(() {
                    fadeMode = value!;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      Column(
                        children: [
                          Text('None'),
                          Radio(value: FadeMode.static),
                        ],
                      ),
                    Column(
                      children: [
                        Text('Lin'),
                        Radio(value: FadeMode.lin),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Sin'),
                        Radio(value: FadeMode.sin),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Exp'),
                        Radio(value: FadeMode.exp),
                      ],
                    ),
                    Column(
                      children: [
                        Text('SnEx'),
                        Radio(value: FadeMode.sinexp),
                      ],
                    ),
                  ],
                ),
              ),
                Row(
                children: [
                  Text(LightsModel.delayMin.toStringAsFixed(1)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        showValueIndicator: ShowValueIndicator.onDrag,
                      ),
                      child: Slider(
                        label: delay.toStringAsFixed(1),
                        activeColor: Colors.red,
                        value: delay,
                        min: LightsModel.delayMin,
                        max: LightsModel.delayMax,
                        onChangeEnd: (double value) => model.setDelay(value),
                        onChanged: (value) => setState(() {
                          delay = value;
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(LightsModel.delayMax.toStringAsFixed(1)),
                ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
          Text('payload:'),
          DataContainer(model.payload, onPayloadClear: onPayloadClear),
        ],
      ),
    );
  }
}


