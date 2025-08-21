import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscureText;

  ReusableTextField({
    required this.label,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
