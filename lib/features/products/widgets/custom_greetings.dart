import 'package:flutter/material.dart';

class ReusableGreeting extends StatelessWidget {
  final String name;

  ReusableGreeting({required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(' Hello $name 👋', style: TextStyle(fontSize: 18))],
    );
  }
}
