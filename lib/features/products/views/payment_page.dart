import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:minibuy/features/products/controllers/cart_provider.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key});
  final CartContoller cartContoller = Get.find<CartContoller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Thanks for your Purchase ", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed("/product");
                cartContoller.cartItems
                    .clear(); // Clear the cart after checkout
                cartContoller.totalAmount.value = 0.0; // Reset total amount
              },
              child: Text("Go to Home "),
            ),
          ],
        ),
      ),
    );
  }
}
