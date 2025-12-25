import 'package:flutter/material.dart';
import 'package:van_controller_app/global_settings.dart';
import 'package:van_controller_app/pages/api_page.dart';
import 'package:van_controller_app/pages/bt_test.dart';
import 'package:van_controller_app/pages/time.dart';
import 'package:van_controller_app/pages/data.dart';
import 'package:van_controller_app/pages/battery.dart';

import 'package:provider/provider.dart';

import 'pages/lights_page.dart';
import 'pages/settings.dart';

/// Flutter code sample for [NavigationBar].

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;

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
            selectedIcon: Icon(Icons.bluetooth),
            icon: Icon(Icons.bluetooth_outlined),
            label: 'bluetooth',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bluetooth),
            icon: Icon(Icons.bluetooth_outlined),
            label: 'bluetooth',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'settings',
          ),

        ],
      ),
      body: [
        LightsPage(),
        BatteryPage(),
        TimePage(),
        DataPage(),
        ApiPage(),
        BtTest(),
        SettingsPage(),
        ][currentPageIndex],
    );
  }
}
