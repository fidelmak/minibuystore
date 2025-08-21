import 'package:flutter/material.dart';

class ReusableSocialButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: Icon(Icons.android), onPressed: () {}),
        IconButton(icon: Icon(Icons.apple), onPressed: () {}),
        IconButton(icon: Icon(Icons.facebook), onPressed: () {}),
      ],
    );
  }
}
