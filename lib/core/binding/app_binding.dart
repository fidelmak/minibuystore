import 'package:get/get.dart';
import 'package:minibuy/features/products/controllers/product_provider.dart';
import 'package:minibuy/features/products/services/product_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductService>(() => ProductService());
    Get.lazyPut<ProductProvider>(() => ProductProvider());
  }
}
