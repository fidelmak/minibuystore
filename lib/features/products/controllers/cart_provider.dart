import 'package:get/get.dart';
import 'package:minibuy/features/products/models/products.dart';
import 'package:minibuy/features/products/services/cart_service.dart';

class CartContoller extends GetxController {
  final CartServices cartServices = Get.put(CartServices());
  var cartItems = <MiniProducts>[].obs;
  var totalAmount = 0.0.obs;

  void addToCart(MiniProducts product) {
    final index = cartItems.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      // Item exists, update quantity
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + 1,
      );
    } else {
      // Item doesn't exist, add new item with quantity 1
      cartItems.add(product.copyWith(quantity: 1));
    }
    calculateTotalAmount();
  }

  void removeFromCart(MiniProducts product) {
    final index = cartItems.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        // If quantity > 1, decrease quantity
        cartItems[index] = cartItems[index].copyWith(
          quantity: cartItems[index].quantity - 1,
        );
      } else {
        // If quantity is 1, remove the item completely
        cartItems.removeAt(index);
      }
    }
    calculateTotalAmount();
  }

  void removeItemCompletely(MiniProducts product) {
    cartItems.removeWhere((item) => item.id == product.id);
    calculateTotalAmount();
  }

  int getQuantity(MiniProducts product) {
    final item = cartItems.firstWhereOrNull((item) => item.id == product.id);
    return item?.quantity ?? 0;
  }

  void calculateTotalAmount() {
    totalAmount.value = cartItems.fold(
      0.0,
      (sum, item) =>
          sum + (double.parse(item.price.toString()) * item.quantity),
    );
  }

  void clearCart() {
    cartItems.clear();
    totalAmount.value = 0.0;
  }
}
