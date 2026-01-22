import 'package:flutter/material.dart';
import 'package:van_controller_app/API/api.dart';

class GlobalSettings extends ChangeNotifier {

  GlobalSettings() {
    debugPrint('GlobalSettings initialized');
    setApi('bt');
  }

  ThemeData _currentTheme = darkTheme;
  NavigationDestinationLabelBehavior _labelBehavior = NavigationDestinationLabelBehavior.alwaysHide;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == darkTheme) {
      _currentTheme = lightTheme;
    } else {
      _currentTheme = darkTheme;
    }
    debugPrint('Theme changed to: ${_currentTheme == darkTheme ? "Dark" : "Light"}');
    notifyListeners();
  }

  NavigationDestinationLabelBehavior get labelBehaviour => _labelBehavior;

  void setLabelBehavior(NavigationDestinationLabelBehavior newBehaviour) {
    debugPrint(newBehaviour.toString());
    _labelBehavior = newBehaviour;
    notifyListeners();
  }

  late Api _api;
  final BluetoothApi _apiBt = BluetoothApi();
  final TestApi _apiTest = TestApi();
  Api get api => _api;

  void setApi(String? type) {
    print('setApi called with type: $type');

    _api = switch (type) {
      'test'  => _apiTest,
      'bt'    => _apiBt,
      _       => throw Exception('Unknown data model type: $type'),
    };
    notifyListeners(); // todo is this needed?
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  //backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 211, 16, 169),
    brightness: Brightness.light,
  ),

  //textTheme: TextTheme(bodyText1: TextStyle(color: Colors.black)),
);
ThemeData darkTheme = ThemeData(
  //brightness: Brightness.dark,
  primaryColor: Colors.amber,
  // appBarTheme: AppBarTheme(
  //   backgroundColor: Colors.amber,
  //   titleTextStyle: TextStyle(color: Color.fromARGB(255, 51, 4, 41), fontSize: 18),
  // ),
  // textTheme: TextTheme(),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 211, 16, 169),
    brightness: Brightness.dark,
  ),
);


