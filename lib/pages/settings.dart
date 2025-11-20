import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:van_controller_app/settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DataSource(),
            SizedBox(height: 20),
            ThemeSwitch(),
            SizedBox(height: 20),
            LabelBehaviourSelector(),
          ],
        ),
      );
  }
}

class DataSource extends StatelessWidget {
  const DataSource({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    var settings = context.read<GlobalSettings>();

    return Column(
      children: [
        Text('Data Source: ${settings.dataSender.name}'),
        RadioGroup(
          groupValue: settings.dataSender.name,
          onChanged: (String? value) {settings.setDataSender(value);},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bluetooth'),
              Icon(Icons.bluetooth),
              Radio( value: 'bt', ),
              SizedBox(width: 20),
              Text('Test'),
              Icon(Icons.model_training),
              Radio( value: 'test' ),
            ],
          )
        ),
      ],
    );
  }
}



class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    var settings = context.read<GlobalSettings>();

    return Column(
      children: <Widget>[
        Text(
          'Theme: ${settings.currentTheme == darkTheme ? "Dark" : "Light"}'
        ),
        Switch(
          value: settings.currentTheme == darkTheme,
          onChanged: (bool value) {
            settings.toggleTheme();
          },
        ),
      ]
    );
  }
}

class LabelBehaviourSelector extends StatelessWidget {
  const LabelBehaviourSelector({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    var settings = context.read<GlobalSettings>();

    void setLabelBehaviour(NavigationDestinationLabelBehavior newBehaviour) {
      settings.setLabelBehavior(newBehaviour);
    }

    ElevatedButton button(
      NavigationDestinationLabelBehavior behaviour
    ) {
      return ElevatedButton(
        onPressed:
            () => setLabelBehaviour(behaviour),
        child: Text(behaviour.name),
      );
    }

    return Column(
      children: [
        Text('Label behavior: ${settings.labelBehaviour.name}'),
        OverflowBar(
          spacing: 10.0,
          overflowAlignment: OverflowBarAlignment.center,
          overflowSpacing: 10.0,
          children: <Widget>[
            button(NavigationDestinationLabelBehavior.alwaysShow),
            button(NavigationDestinationLabelBehavior.onlyShowSelected),
            button(NavigationDestinationLabelBehavior.alwaysHide),
          ],
        ),
      ],
    );
  }


}

