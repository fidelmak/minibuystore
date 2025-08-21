import 'package:flutter/material.dart';

class ReusableOfferBanner extends StatelessWidget {
  final String text;
  final Color color;
  final String buttonText;

  ReusableOfferBanner({
    required this.text,
    required this.color,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: color,
      child: Center(
        child: ElevatedButton(onPressed: () {}, child: Text(buttonText)),
      ),
    );
  }
}
