import 'package:flutter/material.dart';

class ReusableCategoryItem extends StatelessWidget {
  final IconData image;
  final String text;
  final String price;
  final String discount;

  ReusableCategoryItem({
    required this.image,
    required this.text,
    required this.price,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(image, size: 50),
          Text(discount),
          Text(text),
          Text(price),
        ],
      ),
    );
  }
}
