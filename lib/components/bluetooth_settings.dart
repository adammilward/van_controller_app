import 'package:flutter/material.dart';
import 'package:van_controller_app/API/api.dart';
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';

class BluetoothSettings extends StatefulWidget {
  const BluetoothSettings(this.api, {super.key});
  final BluetoothApi api;

  @override
  State<BluetoothSettings> createState() => _BluetoothSettingsState();

}

class _BluetoothSettingsState extends State<BluetoothSettings> {
  BluetoothApi get api => widget.api;
  List<BluetoothDevice> _pairedDevices = [];

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pairedDevices = api.pairedDevices;
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await api.connect(device.address);
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to connect: $e')));
      }
    }
  }

  Future<void> _disconnect() async {
    try {
      await api.disconnect();
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }

  Future<void> _reloadPairedDevices() async {
    print('Reloading paired devices');
    try {
      print('Before loadPairedDevices call');
      await api.loadPairedDevices();
      print('After loadPairedDevices call');
      setState(() {
        print('Updating paired devices list');
        _pairedDevices = api.pairedDevices;
      });
    } catch (e) {
      debugPrint('Error loading paired devices: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty &&
        api.connectionState?.isConnected == true) {
      try {
        api.send(_messageController.text);
        _messageController.clear();
      } catch (e) {
        debugPrint('Error sending message: $e');
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bluetooth Status
        Card(
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
                          api.isBluetoothAvailable
                              ? Icons.bluetooth
                              : Icons.bluetooth_disabled,
                          color:
                              api.isBluetoothAvailable ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          api.isBluetoothAvailable ? 'Available' : 'Not Available',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          api.connectionState?.isConnected == true
                              ? Icons.link
                              : Icons.link_off,
                          color:
                              api.connectionState?.isConnected == true
                                  ? Colors.green
                                  : Colors.red,
                        ),
                        const SizedBox(width: 8),

                        Expanded(child: Text(api.connectionState?.status ?? 'disconnected')),
                      ],
                    ),
                    if (api.connectedDevice != null) ...[
                      const SizedBox(height: 8),
                      Text('Connected to: ${api.connectedDevice!.name}'),
                      Text('Address: ${api.connectedDevice!.address}'),
                    ],
                  ],
                ),
              ),
            ),

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
                            onPressed: _reloadPairedDevices,
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
                                        api.connectedDevice?.address ==
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
                                                onPressed: _disconnect,
                                                child: const Text('Disconnect'),
                                              )
                                              : ElevatedButton(
                                                onPressed:
                                                    api.connectionState
                                                                ?.isConnected !=
                                                            true
                                                        ? () =>
                                                            _connectToDevice(
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
            if (api.connectionState?.isConnected == true) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Send Message',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: _messageController,
                              textInputAction: TextInputAction.newline,
                              decoration: const InputDecoration(
                                hintText: 'Enter message to send',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _sendMessage,
                            child: const Text('Send'),
                          ),
                        ],
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
                        IconButton(
                          onPressed: () {
                            //TPT clear received data
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.api.rawData.length,
                      itemBuilder: (context, index) {
                        final raw =
                            widget.api.rawData.reversed.elementAt(index).toString();
                        return Column(
                          children: [
                            Text((widget.api.rawData.length - index).toString()),
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
                          widget.api.rawData.isEmpty
                            ? 'No data received'
                            : widget.api.rawData.last,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
    );
  }

  @override
  void dispose() {
    print('Disposing BluetoothSettings');
    _messageController.dispose();
    super.dispose();
  }
}
