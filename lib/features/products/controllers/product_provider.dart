import 'package:get/get.dart';
import 'package:minibuy/features/products/models/products.dart';
import 'package:minibuy/features/products/services/product_service.dart';

class ProductProvider extends GetxController {
  final ProductService productService = ProductService();
  var products = <MiniProducts>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = ''.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit(); // Call super.onInit() first
    getProducts();
    getAllCategory();
    // Initialize any other necessary data or services here
    print("ProductProvider initialized");
  }

  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous error messages
      final fetchedProducts = await productService.fetchProducts();
      products.assignAll(fetchedProducts);
      print("Products fetched successfully: ${products.length} items");
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<List> getAllCategory() async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear previous error messages
      final categories = await productService.allCategory();
      this.categories.assignAll(categories);
      print("Categories fetched successfully: ${categories.length} items");
      return categories; // Return the categories
    } catch (e) {
      errorMessage.value = e.toString();
      print("Error fetching categories: $e");
      return []; // Return an empty list on error
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Add a method to refresh products
  Future<void> refreshProducts() async {
    await getProducts();
  }

  // Optional: Add error handling for UI
  void clearError() {
    errorMessage.value = '';
  }
}
