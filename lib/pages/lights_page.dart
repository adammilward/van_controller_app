import 'package:flutter/material.dart';

class LightsStatus {
  double? r;
}

var record = ('first', a: 2, b: true, 'last');



class LightsPage extends StatelessWidget {
  const LightsPage({super.key});

  //LightsModel lights = LightsModel();

  @override
  Widget build(BuildContext context) {

    debugPrint(record.toString());

    return Container(
      padding: EdgeInsets.all(22),
      color: Colors.white,

        child: SizedBox(
          height: 200,
          child: Card(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text(
                          'Lights',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: const Text('on/off'),
                        leading: Icon(Icons.power_settings_new),
                      ),
                    ),
                    Switch(value: true, onChanged: (value) {}),
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

