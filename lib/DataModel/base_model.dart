part of 'package:van_controller_app/DataModel/data_model.dart';

abstract base class BaseModel {

  BaseModel(this._api);

  Api _api;

  bool _send(String command) {
    debugPrint('Sending command: $command');
    return _api.send(command);
  }

  bool send(String command);

  setSender(Api sender) {
    _api = sender;
  }

  bool report({num? interval}) {
    String command = interval == null ? 'report' : 'report $interval';
    return send(command);
  }
}

