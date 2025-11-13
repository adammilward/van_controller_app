import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // in logical pixels
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(),
      // Row is a horizontal, linear layout.
      child: Row(
        children: [
          // Expanded expands its child
          // to fill the available space.
          Expanded(child: Text('LED Controller')),
        ],
      ),
    );
  }
}
