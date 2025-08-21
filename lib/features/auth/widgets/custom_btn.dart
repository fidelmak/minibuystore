import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final Color color;

  ReusableButton({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
