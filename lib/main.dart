import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/global_settings.dart';
import 'package:van_controller_app/navigation.dart';

import 'API/api.dart';


void main() {

  runApp(

    Builder(
      builder: (context) {
        GlobalSettings settings = GlobalSettings();
        Api api = settings.api;
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create:(context) => settings),
            ChangeNotifierProvider(create:(context) => api),
          ],
          //create: (context) => GlobalSettings(),
          child: TopLevelConsumer()
        );
      }
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
