part of 'api.dart';

class ApiFactory extends ChangeNotifier {
  Api? _api = TestApi();

  Api get api => _api!;

  void setApi(String type) {
    _api = switch (type) {
      'test' => TestApi(),
      'bt' => BluetoothApi(),
      _ => throw Exception('Unknown api type: $type'),
    };

    notifyListeners();
  }

  LightsModel getLights() {
    return LightsModel(_api!);
  }
}
