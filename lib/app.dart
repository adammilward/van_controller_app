import 'package:flutter/material.dart';
import 'package:van_controller_app/navigation.dart';
import 'package:van_controller_app/pages/led.dart';

class MyScaffold extends StatelessWidget {

  MyScaffold({super.key});

  final Widget selectedPage = LedPage();

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece
    // of paper on which the UI appears.
    return Material(
      // Column is a vertical, linear layout.
      child: Navigation()

    );
  }
}
