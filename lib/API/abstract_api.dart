// ignore_for_file: avoid_print

part of 'api.dart';

abstract class Api extends ChangeNotifier {
  final String name = '';

  final _payloads = <String, dynamic>{};

  Map<String, Function> _updateCallbacks = {};

  get lightsPayload => _payloads['lights'];

  bool send(String command);

  _processIncomingData(String data) {

    data = data.replaceAll(RegExp(r"\'"), "\"");

    RegExp exp = RegExp(r'\<\{(.*?)\}\>', multiLine: true, dotAll: true);
    Iterable<RegExpMatch> matches = exp.allMatches(data);
    for (final m in matches) {
      String match = m[0]!;
      match = match.substring(1, match.length - 1); // remove < and >
      try {
        Map<String, dynamic> jsonData = jsonDecode(match);
        String type = jsonData['type'];
        var payload = jsonData['payload'];
        print('Type: $type, Payload: $payload');

        switch (type) {
          case 'lights':
            _payloads['lights'] = payload;

          case 'time':
            _payloads['time'] = payload;
          case 'status':
            _payloads['status'] = payload;
          default:
            assert(false, 'Unknown payload type: $type');
        }

        if (_updateCallbacks.containsKey(type)) {
          _updateCallbacks[type]!();
        }

      } catch (e) {
        debugPrint('Error decoding JSON: $e');
      }
    }
  }

  attatchUpdateCallback(String type, Function callback) {
    _updateCallbacks[type] = callback;
  }

  detatchUpdateCallback(String type) {
    _updateCallbacks.remove(type);
  }
}


