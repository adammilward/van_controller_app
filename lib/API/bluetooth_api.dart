part of 'api.dart';

class BluetoothApi extends AbstractApi {

  @override
  String get name => 'bt';

  late FlutterBluetoothClassic _bluetooth;

  bool _isBluetoothAvailable = false;
  bool get isBluetoothAvailable => _isBluetoothAvailable;
  set isBluetoothAvailable(bool value) {
    _isBluetoothAvailable = value;
    notifyListeners();
  }

  List<BluetoothDevice> _pairedDevices = [];
  List<BluetoothDevice> get pairedDevices => _pairedDevices;
  set pairedDevices(List<BluetoothDevice> devices) {
    _pairedDevices = devices;
    notifyListeners();
  }

  BluetoothDevice? _connectedDevice;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  set connectedDevice(BluetoothDevice? device) {
    _connectedDevice = device;
    notifyListeners();
  }

  BluetoothConnectionState? _connectionState;
  BluetoothConnectionState? get connectionState => _connectionState;
  set connectionState(BluetoothConnectionState? state) {
    _connectionState = state;
    notifyListeners();
  }

  BluetoothApi() {
    print('BluetoothApi constructor called');
    _bluetooth = FlutterBluetoothClassic();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    try {
      bool isSupported = await _bluetooth.isBluetoothSupported();
      bool isEnabled = await _bluetooth.isBluetoothEnabled();

      isBluetoothAvailable = isSupported && isEnabled;

      if (isSupported && isEnabled) {
        _listenToConnectionState();
        _listenToIncomingData();
      }
    } catch (e) {
      debugPrint('Error initializing Bluetooth: $e');
    }
  }

  Future<List<BluetoothDevice>> getPairedDevices() async {
    return _bluetooth.getPairedDevices();
  }

  void _listenToConnectionState() {
    _bluetooth.onConnectionChanged.listen((state) {
      connectionState = state;
      if (state.isConnected) {
        // Find the connected device
        connectedDevice = _pairedDevices.firstWhere(
          (device) => device.address == state.deviceAddress,
          orElse:
              () => BluetoothDevice(
                name: 'Unknown Device',
                address: state.deviceAddress,
                paired: false,
              ),
        );
      } else {
        connectedDevice = null;
      }
      // todo notify listeners about connection state change
      // however this doesn't get triggered on
      // connection state change from android devices
    });
  }

  void _listenToIncomingData() {
    _bluetooth.onDataReceived.listen((data) {
      rawDataReceived.add(data.asString());
      _processIncomingData(data.asString());
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await _bluetooth.connect(device.address);
    } catch (e) {
      debugPrint('Error connecting to device: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      await _bluetooth.disconnect();
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }

  @override
  bool send(String command) {
    debugPrint('BTSender sending command: $command');
    print(command);
    print(command.substring( command.length - 1));
    if (command.substring(command.length - 1) != '\n') {
      command += '\n';
    }
    _send(command);
    return false;
  }

  Future<void> _send(String command) async {
    try {
      await _bluetooth.sendString(command);
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }
}
