//import 'base_model.dart';
part of 'data_model.dart';

enum FadeMode {lin, sin, exp, expsin }

base class LightsModel extends BaseModel {

  LightsModel(super._api, {void Function()? updateCallback}) {
    initState();
    if (null != updateCallback) {
      _api.attatchUpdateCallback('lights', updateCallback);
    }
  }

  static const double MIN = -0.01;
  static const double MAX = 1.0;

  bool isFading = false;

  get isOn => _r >= 0 || _g >= 0 || _b >= 0;
  double _r = 0;
  get r => _r;
  double _g = 0;
  get g => _g;
  double _b = 0;
  get b => _b;

  int updateCount = 0;

  @override
  bool send(String command) {
    return _send('l $command');
  }

  void initState() {
    print('LightsModel initState');
    var payload = _api.lightsPayload;
    setValuesFromPayload(payload);
  }


  void setValuesFromPayload(payload) {
    print('setValuesFromPayload called');
    if (payload == null) return;
    _r = (payload['r'] as num).toDouble();
    _g = (payload['g'] as num).toDouble();
    _b = (payload['b'] as num).toDouble();
    updateCount++;
    debugPrint('LightsModel updated: r=$_r, g=$_g, b=$_b');
  }


  bool on() => send("on");
  bool off() => send("off");

  bool static() => send("static");
  bool lin() => send("lin");
  bool sin() => send("sin");
  bool exp() => send("exp");
  bool sinExp() => send("sinexp");

  bool rUp() => send('ru');
  bool rDown() => send('rd');
  bool bUp() => send('bu');
  bool bDown() => send('bd');
  bool gUp() => send('gu');
  bool gDown() => send('gd');

  bool setRed(num value) => send("r $value");
  bool setGreen(num value) => send("g $value");
  bool setBlue(num value) => send("b $value");
  bool setDelay(num value) => send("delay $value");
  bool setUpper(num value) => send("u $value");
  bool setLower(num value) => send("l $value");
}
