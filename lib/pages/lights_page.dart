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

    LightsModel lightsModel = context.read<ApiFactory>().getLights();
    debugPrint(record.toString());

    return LightsWidget(lightsModel);
  }
}

class LightsWidget extends StatefulWidget {
  const LightsWidget(this.lightsModel, {super.key});
  final LightsModel lightsModel;

  @override
  State<LightsWidget> createState() => _LightsWidgetState();
}

class _LightsWidgetState extends State<LightsWidget> {

  bool isOn = false;
  double r = 0;
  double g = 0;
  double b = 0;

  @override
  void initState() {
    print('_LightsWidgetState initState');
    super.initState();
    isOn = widget.lightsModel.isOn;
    g = widget.lightsModel.g;
    b = widget.lightsModel.b;
    r = widget.lightsModel.r;
  }

  @override
  void didUpdateWidget(covariant LightsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lightsModel.updateCount != oldWidget.lightsModel.updateCount) {
      print("Data changed from ${oldWidget.lightsModel} to ${widget.lightsModel}");
      // Update internal state or logic here if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    print('_LightsWidgetState rebuilt');

    return Container(
      padding: EdgeInsets.all(22),
      //color: Colors.white,

        child: SizedBox(
          height: 200,
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
                          setState(() => isOn = value);
                        }
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        ),
    );
  }
}

