// ignore_for_file: avoid_print

part of 'api.dart';

class ApiFactory {
  AbstractApi? _api = TestApi();

  AbstractApi get api {
    print('api factory building api: ${_api!.name}');
    return _api!;
  }

  void setApi(String type) {
    _api = switch (type) {
      'test' => TestApi(),
      //'bt' => BluetoothApi(),
      _ => throw Exception('Unknown api type: $type'),
    };
  }

  LightsModel getLights() {
    return LightsModel(_api!);
  }
}
