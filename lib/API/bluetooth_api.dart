part of 'api.dart';

class BluetoothApi extends Api {

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
    print('set pairedDevices called, length: ${devices.length}');
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


  Future<void> loadPairedDevices() async {
    try {
      List<BluetoothDevice> devices = await _bluetooth.getPairedDevices();
      _pairedDevices = devices;
    } catch (e) {
      debugPrint('Error loading paired devices: $e');
    }
  }

  Future<void> _initBluetooth() async {
    print('initBluetooth called');
    try {
      bool isSupported = await _bluetooth.isBluetoothSupported();
      bool isEnabled = await _bluetooth.isBluetoothEnabled();


      if (isSupported && isEnabled) {
        loadPairedDevices();
        _listenToConnectionState();
        _listenToIncomingData();
      }
    } catch (e) {
      debugPrint('Error initializing Bluetooth: $e');
    }
  }

  void _listenToConnectionState() {
    _bluetooth.onConnectionChanged.listen((state) {
      print('bluetooth_api.dart connection state changed: $state');
      _connectionState = state;
      if (state.isConnected) {
        // Find the connected device
        _connectedDevice = _pairedDevices.firstWhere(
          (device) => device.address == state.deviceAddress,
          orElse:
              () => BluetoothDevice(
                name: 'Unknown Device',
                address: state.deviceAddress,
                paired: false,
              ),
        );
      } else {
        print('setting connected device to null');
        _connectedDevice = null;
      }
      print('Bluetooth connection state changed: $_connectionState');
      notifyListeners();
    });
  }

  void _listenToIncomingData() {
    _bluetooth.onDataReceived.listen((data) {
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

  Future<void> connect(String address) async {
    _bluetooth.connect(address);
  }

  Future<void> disconnectFromDevice() async {
    _bluetooth.disconnect();
  }
}
