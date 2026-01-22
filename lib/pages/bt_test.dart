import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';

class BtTest extends StatelessWidget {
  const BtTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Classic Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BluetoothClassicDemo(),
    );
  }
}


class BluetoothClassicDemo extends StatefulWidget {
  const BluetoothClassicDemo({super.key});

  @override
  State<BluetoothClassicDemo> createState() => _BluetoothClassicDemoState();
}

class _BluetoothClassicDemoState extends State<BluetoothClassicDemo> {
  late FlutterBluetoothClassic _bluetooth;
  bool _isBluetoothAvailable = false;
  BluetoothConnectionState? _connectionState;
  List<BluetoothDevice> _pairedDevices = [];
  BluetoothDevice? _connectedDevice;
  String _receivedData = '';
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bluetooth = FlutterBluetoothClassic();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    try {
      bool isSupported = await _bluetooth.isBluetoothSupported();
      bool isEnabled = await _bluetooth.isBluetoothEnabled();
      setState(() {
        _isBluetoothAvailable = isSupported && isEnabled;
      });

      if (isSupported && isEnabled) {
        _loadPairedDevices();
        _listenToConnectionState();
        _listenToIncomingData();
      }
    } catch (e) {
      debugPrint('Error initializing Bluetooth: $e');
    }
  }

  Future<void> _loadPairedDevices() async {
    try {
      List<BluetoothDevice> devices = await _bluetooth.getPairedDevices();
      setState(() {
        _pairedDevices = devices;
      });
    } catch (e) {
      debugPrint('Error loading paired devices: $e');
    }
  }

  void _listenToConnectionState() {
    _bluetooth.onConnectionChanged.listen((state) {
      print('bt_test.dart connection state changed: $state');

      setState(() {
        _connectionState = state;
        if (state.isConnected) {
          // Find the connected device
          _connectedDevice = _pairedDevices.firstWhere(
                (device) => device.address == state.deviceAddress,
            orElse: () => BluetoothDevice(
              name: 'Unknown Device',
              address: state.deviceAddress,
              paired: false,
            ),
          );
        } else {
          _connectedDevice = null;
        }
      });
    });
  }

  void _listenToIncomingData() {
    _bluetooth.onDataReceived.listen((data) {
      debugPrint('Data received: ${data.asString()}');
      setState(() {
        _receivedData += '${data.asString()}\n';
      });
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await _bluetooth.connect(device.address);
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
      await _bluetooth.disconnect();
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty &&
        _connectionState?.isConnected == true) {
      try {
        await _bluetooth.sendString(_messageController.text);
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
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
                          _isBluetoothAvailable
                              ? Icons.bluetooth
                              : Icons.bluetooth_disabled,
                          color: _isBluetoothAvailable
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isBluetoothAvailable ? 'Available' : 'Not Available',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _connectionState?.isConnected == true
                              ? Icons.link
                              : Icons.link_off,
                          color: _connectionState?.isConnected == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(_connectionState?.status ?? 'disconnected'),
                      ],
                    ),
                    if (_connectedDevice != null) ...[
                      const SizedBox(height: 8),
                      Text('Connected to: ${_connectedDevice!.name}'),
                      Text('Address: ${_connectedDevice!.address}'),
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
                            onPressed: _loadPairedDevices,
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _pairedDevices.isEmpty
                            ? const Center(
                          child: Text('No paired devices found'),
                        )
                            : ListView.builder(
                          itemCount: _pairedDevices.length,
                          itemBuilder: (context, index) {
                            final device = _pairedDevices[index];
                            final isConnected =
                                _connectedDevice?.address ==
                                    device.address;
                            return ListTile(
                              leading: Icon(
                                Icons.devices,
                                color: isConnected ? Colors.green : null,
                              ),
                              title: Text(device.name),
                              subtitle: Text(device.address),
                              trailing: isConnected
                                  ? ElevatedButton(
                                onPressed: _disconnect,
                                child: const Text('Disconnect'),
                              )
                                  : ElevatedButton(
                                onPressed:
                                _connectionState?.isConnected !=
                                    true
                                    ? () => _connectToDevice(device)
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
            if (_connectionState?.isConnected == true) ...[
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
                            flex:1,
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
                              setState(() {
                                _receivedData = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          ),
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
                              _receivedData.isEmpty
                                  ? 'No data received'
                                  : _receivedData,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

