import 'package:get/get.dart';
import 'package:minibuy/features/create_products/model/create_product_model.dart';
import 'package:minibuy/features/create_products/service/create_product_service.dart';

class CreateProductProvider extends GetxController {
  final CreateProductService _createProductService = CreateProductService();

  // Reactive state variables
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _successMessage = ''.obs;

  // Getters for state
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get successMessage => _successMessage.value;

  // Clear messages
  void clearMessages() {
    _errorMessage.value = '';
    _successMessage.value = '';
  }

  // Create a new product
  Future<String?> createProduct(CreateProductModel product) async {
    try {
      _isLoading.value = true;
      clearMessages();

      final productId = await _createProductService.createProduct(product);

      _successMessage.value = 'Product created successfully!';
      return productId;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  // Create product with custom ID
  Future<bool> createProductWithId(
    String documentId,
    CreateProductModel product,
  ) async {
    try {
      _isLoading.value = true;
      clearMessages();

      await _createProductService.createProductWithId(documentId, product);

      _successMessage.value = 'Product created with custom ID successfully!';
      return true;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Update an existing product
  Future<bool> updateProduct(
    String productId,
    CreateProductModel product,
  ) async {
    try {
      _isLoading.value = true;
      clearMessages();

      await _createProductService.updateProduct(productId, product);

      _successMessage.value = 'Product updated successfully!';
      return true;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Delete a product
  Future<bool> deleteProduct(String productId) async {
    try {
      _isLoading.value = true;
      clearMessages();

      await _createProductService.deleteProduct(productId);

      _successMessage.value = 'Product deleted successfully!';
      return true;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Get product by ID
  Future<CreateProductModel?> getProductById(String productId) async {
    try {
      _isLoading.value = true;
      clearMessages();

      final product = await _createProductService.getProductById(productId);
      return product;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  // Check if product exists
  Future<bool> doesProductExist(String title) async {
    try {
      _isLoading.value = true;
      return await _createProductService.doesProductExist(title);
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
