import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:minibuy/features/products/controllers/cart_provider.dart';
import 'package:minibuy/features/products/views/payment_page.dart';
import 'package:minibuy/features/products/widgets/custom_button.dart';

class CartView extends StatelessWidget {
  CartView({super.key});

  final CartContoller cartController = Get.find<CartContoller>(); // Fixed typo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items in Cart", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFFF17547),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return Center(child: Text("Your cart is empty"));
              }

              return ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = cartController.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product Image
                            Card(
                              elevation: 2,

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    item.image,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),

                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and Delete Button
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "Remove Item",
                                            middleText:
                                                "Are you sure you want to remove ${item.title} from the cart?",
                                            onConfirm: () {
                                              Get.back();
                                              cartController
                                                  .removeItemCompletely(item);
                                            },
                                            onCancel: () {
                                              Get.back();
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8),

                                  Text(
                                    "${item.category}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),

                                  // Price
                                  SizedBox(height: 16),

                                  // Quantity Controls
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: Text(
                                          "₦${item.price * item.quantity}",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),

                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              color: Colors.grey[200],
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                cartController.removeFromCart(
                                                  item,
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              item.quantity.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              color: Colors.grey[200],
                                            ),
                                            child: IconButton(
                                              icon: Icon(Icons.add, size: 20),
                                              onPressed: () {
                                                cartController.addToCart(item);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Total Amount and Checkout Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Obx(
                  () => Text(
                    "Total Amount: ₦${cartController.totalAmount.value.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: "Checkout",
                    onPressed: () {
                      Get.to(() => Checkout());
                    },
                    color: Color(0xFFF17547),
                    textColor: Colors.white,
                    borderRadius: 8.0,
                    elevation: 2.0,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
