// // ignore_for_file: avoid_print

// part of 'api.dart';

// class BluetoothApi extends AbstractApi {
//   @override
//   final name = 'bt';

//   late FlutterBluetoothClassic _bluetooth;
//   bool _isBluetoothAvailable = false;
//   BluetoothConnectionState? _connectionState;
//   List<BluetoothDevice> _pairedDevices = [];
//   BluetoothDevice? _connectedDevice;

//   @override
//   void initState() {
//     super.initState();
//     _bluetooth = FlutterBluetoothClassic();
//     _initBluetooth();
//   }

//   @override
//   bool send(String command) {
//     debugPrint('BTSender sending command: $command');
//     print(command);
//     print(command.substring( command.length - 1));
//     if (command.substring(command.length - 1) != '\n') {
//       command += '\n';
//     }
//     _send(command);
//     return false;
//   }

//   Future<void> _send(String command) async {
//     try {
//       await _bluetooth.sendString(command);
//     } catch (e) {
//       debugPrint('Error sending message: $e');
//     }
//   }

//   void _listenToIncomingData() {
//     _bluetooth.onDataReceived.listen((data) {
//       print(data);
//       debugPrint('Data received: ${data.asString()}');



//       notifyListeners();
//     });
//   }

// }
