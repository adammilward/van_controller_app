import 'package:flutter/material.dart';
import 'package:van_controller_app/API/api.dart';

class BluetoothSettings extends StatefulWidget {
  const BluetoothSettings(this.api, {super.key});
  final BluetoothApi api;

  @override
  State<BluetoothSettings> createState() => _BluetoothSettingsState();
}

class _BluetoothSettingsState extends State<BluetoothSettings> {

  BluetoothApi get api => widget.api;
  late List _pairedDevices;

  @override
  void initState() {
    super.initState();
    _pairedDevices = api.pairedDevices;
    loadPairedDevices();
  }

  Future<void> loadPairedDevices() async {
    try {
      _pairedDevices = await api.getPairedDevices();
      setState(() {_pairedDevices = _pairedDevices;});
      print('no of paired devices: ${_pairedDevices.length}');
    } catch (e) {
      debugPrint('Error loading paired devices: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children : [
          // Bluetooth Status
          bluetoothStatus(context),

          const SizedBox(height: 16),

          // Paired Devices
          SizedBox(
            height: 400,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paired Devices',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          onPressed: () async {
                            await loadPairedDevices();
                          },
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child:
                          _pairedDevices.isEmpty
                              ? const Center(
                                child: Text('No paired devices found'),
                              )
                              : ListView.builder(
                                itemCount: _pairedDevices.length,
                                itemBuilder: (context, index) {
                                  final device = _pairedDevices[index];
                                  final isConnected =
                                      widget.api.connectedDevice?.address ==
                                      device.address;
                                  return ListTile(
                                    leading: Icon(
                                      Icons.devices,
                                      color:
                                          isConnected ? Colors.green : null,
                                    ),
                                    title: Text(device.name),
                                    subtitle: Text(device.address),
                                    trailing:
                                        isConnected
                                            ? ElevatedButton(
                                              onPressed: widget.api.disconnect,
                                              child: const Text('Disconnect'),
                                            )
                                            : ElevatedButton(
                                              onPressed:
                                                  widget.api.connectionState
                                                              ?.isConnected !=
                                                          true
                                                      ? () =>
                                                          widget.api.connectToDevice(
                                                            device,
                                                          )
                                                      : null,
                                              child: const Text('Connect'),
                                            ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16), // Message Section
          if (widget.api.connectionState?.isConnected == true) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Test',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => widget.api.send('report'),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Received Data
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Received Data',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       _receivedData = '';
                      //     });
                      //   },
                      //   icon: const Icon(Icons.clear),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        widget.api.receivedDataIsEmpty
                            ? 'No data received'
                            : widget.api.lastDataReceived,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]
      );
  }



  Card bluetoothStatus(BuildContext context) {
    return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bluetooth Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      widget.api.isBluetoothAvailable
                          ? Icons.bluetooth
                          : Icons.bluetooth_disabled,
                      color:
                          widget.api.isBluetoothAvailable ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.api.isBluetoothAvailable ? 'Available' : 'Not Available',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      widget.api.connectionState?.isConnected == true
                          ? Icons.link
                          : Icons.link_off,
                      color:
                          widget.api.connectionState?.isConnected == true
                              ? Colors.green
                              : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(widget.api.connectionState?.status ?? 'disconnected'),
                  ],
                ),
                if (widget.api.connectedDevice != null) ...[
                  const SizedBox(height: 8),
                  Text('Connected to: ${widget.api.connectedDevice!.name}'),
                  Text('Address: ${widget.api.connectedDevice!.address}'),
                ],
              ],
            ),
          ),
        );
  }
}
