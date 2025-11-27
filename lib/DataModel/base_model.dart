part of 'package:van_controller_app/DataModel/data_model.dart';

abstract base class BaseModel {

  AbstractApi _api;
  BaseModel(this._api);
  void Function()? onPayloadReceived;

  bool _send(String command) {
    debugPrint('Sending command: $command');
    return _api.send(command);
  }

  bool send(String command);

  setSender(AbstractApi sender) {
    _api = sender;
  }

  bool report({num? interval}) {
    String command = interval == null ? 'report' : 'report $interval';
    return send(command);
  }
}

