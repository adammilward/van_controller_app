//import 'base_model.dart';
part of 'data_model.dart';

enum FadeMode {lin, sin, exp, expsin }

base class LightsModel extends BaseModel {

  LightsModel(super._api);

  final Map <String, dynamic> _status = {'test': '123'};
  Map <String, dynamic> get status => _status;

  bool isFading = false;

  @override
  bool send(String command) {
    return _send('l $command');
  }

  get isOn => _r > 0 || _g > 0 || _b > 0;
  double _r = 0;
  get r => _r;
  double _g = 0;
  get g => _g;
  double _b = 0;
  get b => _b;

  Object get updateCount => 0;



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
