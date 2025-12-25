//import 'base_model.dart';
part of 'data_model.dart';

enum FadeMode { static, lin, sin, exp, sinexp }

base class LightsModel extends BaseModel {

  LightsModel(super._api, {void Function()? updateCallback}) {
    initState();
    if (null != updateCallback) {
      _api.attatchUpdateCallback('lights', updateCallback);
    }
  }

  get payload => _api.lightsPayload;
  clearPayload() {
    _api.clearLightsPayload();
  }

  static const double min = 0;
  static const double max = 100;
  static const double delayMin = 0;
  static const double delayMax = 255;
  static const double upperMin = 25;
  static const double upperMax = 255;
  static const double lowerMin = 0;
  static const double lowerMax = 100;

  bool isFading = false;

  get isOn => r > 0 || g > 0 || b > 0 ? true : false;
  get r => payload?['r'] ?? 0.0;
  get g => payload?['g'] ?? 0.0;
  get b => payload?['b'] ?? 0.0;

  get delay => payload?['delay']?.toDouble() ?? delayMin;
  get upper => payload?['u']?.toDouble() ?? upperMax;
  get lower => payload?['l']?.toDouble() ?? lowerMin;

  get fadeMode {
    var modeIndex =
      (payload?['lightMode']?[0] ?? 0)
        *
      (payload?['lightMode']?[1] ?? 0);
    return FadeMode.values[modeIndex];
  }

  setFadeMode(FadeMode mode) {
    switch (mode) {
      case FadeMode.static:
        static();
      case FadeMode.lin:
        lin();
      case FadeMode.sin:
        sin();
      case FadeMode.exp:
        exp();
      case FadeMode.sinexp:
        sinExp();
    }
  }

  int updateCount = 0;

  @override
  bool send(String command) {
    return _send('l $command');
  }

  void initState() {
    var payload = _api.lightsPayload;
    setValuesFromPayload(payload);
  }

  void setValuesFromPayload(payload) {
    if (payload == null) return;
    updateCount++;
    debugPrint('LightsModel updated: is this function needed?');
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
