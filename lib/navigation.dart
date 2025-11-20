import 'package:flutter/material.dart';
import 'package:van_controller_app/settings.dart';
import 'package:van_controller_app/pages/time.dart';
import 'package:van_controller_app/pages/bt_connect.dart';
import 'package:van_controller_app/pages/battery.dart';

import 'package:provider/provider.dart';

import 'pages/led.dart';
import 'pages/settings.dart';

/// Flutter code sample for [NavigationBar].

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 3;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: context.read<GlobalSettings>().labelBehaviour,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.lightbulb),
            icon: Icon(Icons.lightbulb_outline),
            label: 'lights',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.electric_rickshaw),
            icon: Icon(Icons.electric_rickshaw_outlined),
            label: 'battery',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.access_time_filled),
            icon: Icon(Icons.access_time),
            label: 'time'),
          NavigationDestination(
            selectedIcon: Icon(Icons.data_object),
            icon: Icon(Icons.data_object_outlined),
            label: 'data',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'settings',
          ),

        ],
      ),
      body: [
        LedPage(),
        BatteryPage(),
        TimePage(),
        DataPage(),
        SettingsPage()
        ][currentPageIndex],
    );
  }
}
