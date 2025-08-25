import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minibuy/features/products/models/products.dart';

class CartServices extends GetxService {
  final storage = GetStorage();
  final cartItems = <MiniProducts>[].obs;

  @override
  void onInit() {
    super.onInit();
    final storedCart = storage.read<List>('cartItems') ?? [];
    if (storedCart.isNotEmpty) {
      cartItems.addAll(
        storedCart.map((item) => MiniProducts.fromJson(item)).toList(),
      );
    }
    ever(cartItems, (_) {
      storage.write(
        'cartItems',
        cartItems.map((item) => item.toJson()).toList(),
      );
    });
  }

  void addToCart(MiniProducts product) {
    cartItems.add(product);
    //saveCart();
  }

  void removeFromCart(MiniProducts product) {
    cartItems.remove(product);
    //saveCart();
  }

  void saveCart() {
    storage.write('cartItems', cartItems.map((item) => item.toJson()).toList());
  }

  void clearCart() {
    cartItems.clear();
    storage.remove('cartItems');
  }

  double getTotalAmount() {
    return cartItems.fold(0.0, (sum, item) => sum + item.price);
  }
}
