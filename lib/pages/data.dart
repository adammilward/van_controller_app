import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/API/api.dart';
import 'package:van_controller_app/components/dtata_container.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {

    Api api = context.read<Api>();
                  print(api.lightsPayload);
                  print(api.statusPayload);
                  print(api.timePayload);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),
            Text('Lights'),
            DataContainer(api.lightsPayload),

            const SizedBox(height: 16),
            Text('Battery'),
            DataContainer(api.statusPayload),

            const SizedBox(height: 16),
            Text('Time'),
            DataContainer(api.timePayload),

            const SizedBox(height: 16),
            Text('Processed Data Received'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: api.processedData.length,
              itemBuilder: (context, index) {
                final raw =
                    api.processedData.reversed
                        .elementAt(index)
                        .toString();
                return Column(
                  children: [
                    Text(index.toString()),
                    Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          raw,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
