import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:minibuy/features/products/controllers/cart_provider.dart';
import 'package:minibuy/features/products/models/products.dart';
import 'package:minibuy/features/products/views/cart_page.dart';
import 'package:minibuy/features/products/widgets/custom_button.dart';

class ProductDetails extends StatelessWidget {
  ProductDetails({super.key});

  final MiniProducts product = Get.arguments;
  final CartContoller cartContoller = Get.find<CartContoller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          Obx(() {
            final cartCount = cartContoller.cartItems.length;
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Get.toNamed('/cart');
                  },
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 6,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.transparent,
                      child: Text(
                        cartCount.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFF17547),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(product.image, height: 200, width: 200),
                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      product.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " ₦",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),

                    SizedBox(width: 20),
                    Text(
                      "${product.price}",
                      style: TextStyle(
                        color: Color(0xFFF17547),
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text(
                    " ${product.description}",
                    textAlign: TextAlign.left,

                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: CustomButton(
                    text: "Add to Cart",
                    onPressed: () {
                      cartContoller.addToCart(product);
                      Get.snackbar(
                        "Success",
                        "${product.title} added to cart",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white,
                        colorText: Colors.green,

                        duration: Duration(seconds: 2),
                        borderRadius: 8,
                        margin: EdgeInsets.all(16),
                        boxShadows: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      );
                    },
                    color: Color(0xFFF17547),
                    textColor: Colors.white,

                    borderRadius: 8.0,
                    elevation: 2.0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
