import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minibuy/features/products/models/firebase_product_model.dart';
// Your model path

class ProductService {
  // Get a reference to the 'products' collection
  final CollectionReference<Map<String, dynamic>> productsCollection =
      FirebaseFirestore.instance.collection('products');

  // Fetch all products
  Future<List<MiniProducts>> fetchProducts() async {
    try {
      // Get a QuerySnapshot from the collection
      final querySnapshot = await productsCollection.get();

      // Convert each document in the snapshot to a MiniProducts object
      // doc is a QueryDocumentSnapshot, which we can pass to fromFirestore
      return querySnapshot.docs
          .map((doc) => MiniProducts.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to load products: $e");
    }
  }

  // Fetch a single product by its Document ID
  Future<MiniProducts> fetchProductById(String id) async {
    // Changed parameter to String
    try {
      // Get the document by its ID (which is the product id)
      final docSnapshot = await productsCollection.doc(id).get();

      if (docSnapshot.exists) {
        return MiniProducts.fromFirestore(docSnapshot);
      } else {
        throw Exception("Product with id $id not found");
      }
    } catch (e) {
      throw Exception("Failed to load product with id $id: $e");
    }
  }

  // Fetch products by category
  Future<List<MiniProducts>> fetchProductsByCategory(String category) async {
    try {
      // Query the collection where the 'category' field is equal to the provided category
      final querySnapshot = await productsCollection
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => MiniProducts.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to load products for category $category: $e");
    }
  }

  // Search products by title (case-insensitive)
  // Note: Firestore doesn't support native full-text search. This is a simple workaround.
  // For production, consider a dedicated search service like Algolia.
  Future<List<MiniProducts>> searchProducts(String query) async {
    try {
      // This is a basic query. It's case-sensitive and looks for exact matches.
      // For a better search experience, you need a more complex setup.
      final querySnapshot = await productsCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where(
            'title',
            isLessThan: query + 'z',
          ) // This approximates a "starts with" query
          .get();

      // For a more robust solution, fetch all and filter locally (not recommended for large datasets)
      // final allProducts = await fetchProducts();
      // return allProducts.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList();

      return querySnapshot.docs
          .map((doc) => MiniProducts.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to search products with query $query: $e");
    }
  }

  // Fetch all unique categories
  Future<List<String>> allCategory() async {
    try {
      // Aggregate queries are expensive. Often better to store categories in a separate collection.
      // This query gets all documents, but only the 'category' field.
      final querySnapshot = await productsCollection.get();

      // Use a Set to automatically handle duplicates
      final categoriesSet = <String>{};

      for (final doc in querySnapshot.docs) {
        final category = doc['category'] as String?;
        if (category != null) {
          categoriesSet.add(category);
        }
      }

      return categoriesSet.toList()..sort(); // Return sorted list
    } catch (e) {
      throw Exception("Failed to load categories: $e");
    }
  }
}
