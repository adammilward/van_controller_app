import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/API/api.dart';
import 'package:van_controller_app/global_settings.dart';
import 'package:van_controller_app/components/bluetooth_settings.dart';

class ApiPage extends StatelessWidget {
  const ApiPage({super.key});

  @override
  Widget build(BuildContext context) {

    GlobalSettings settings = context.read<GlobalSettings>();

    return MaterialApp(
      title: 'Api Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BluetoothConnect(settings),
    );
  }
}

class BluetoothConnect extends StatefulWidget {
  const BluetoothConnect(this.settings, {super.key});
  final GlobalSettings settings;

  @override
  State<BluetoothConnect> createState() => _BluetoothConnectState();
}

class _BluetoothConnectState extends State<BluetoothConnect> {

  late Api api;
  late GlobalSettings settings;

  @override
  void initState() {
    super.initState();
    settings = widget.settings;
    api = settings.api;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text('Data Source: ${api.name}'),
            RadioGroup(
              groupValue: api.name,
              onChanged: (String? type) {
                settings.setApi(type);
                setState(() {
                  api = settings.api;
                });
                print('Data source change requested to $type');
                //todo set api
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Bluetooth'),
                  Icon(Icons.bluetooth),
                  Radio(value: 'bt'),
                  SizedBox(width: 20),
                  Text('Test'),
                  Icon(Icons.model_training),
                  Radio(value: 'test'),
                ],
              ),
            ),

            if (api is BluetoothApi)
              BluetoothSettings(api as BluetoothApi),
            if (api is TestApi) Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Operating in test mode')),
            ),
          ],
        ),
      ),
    );
  }

}
