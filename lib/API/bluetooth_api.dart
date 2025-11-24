part of 'api.dart';

class BluetoothApi implements Api {
  @override
  final name = 'bt';

  @override
  bool send(String command) {
    debugPrint('BTSender sending command: $command');
    //_sendData(command);
    return false;
  }
}
