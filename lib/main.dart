import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/navigation.dart';

class GlobalSettings extends ChangeNotifier {
  ThemeData _currentTheme = darkTheme;
  NavigationDestinationLabelBehavior _labelBehavior = NavigationDestinationLabelBehavior.alwaysHide;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    if (_currentTheme == darkTheme) {
      _currentTheme = lightTheme;
    } else {
      _currentTheme = darkTheme;
    }
    print('Theme changed to: ${_currentTheme == darkTheme ? "Dark" : "Light"}');
    notifyListeners();
  }

  NavigationDestinationLabelBehavior get labelBehaviour => _labelBehavior;

  void setLabelBehavior(NavigationDestinationLabelBehavior newBehaviour) {
    print(newBehaviour);
    _labelBehavior = newBehaviour;
    notifyListeners();
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
  )

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
  )
);


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalSettings(),
      child: TopLevelConsumer()
    )
  );
}

class TopLevelConsumer extends StatelessWidget {
  const TopLevelConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer <GlobalSettings>(
      builder: (context, globalSettings, child) => MaterialApp(
          title: 'Van Controller', // used by the OS task switcher
          home: SafeArea(
            child: Navigation()
          ),
          theme: globalSettings.currentTheme,
        ),
    );
  }

}
