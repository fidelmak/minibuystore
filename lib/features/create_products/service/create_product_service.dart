import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minibuy/features/create_products/model/create_product_model.dart';

class CreateProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reference to the products collection
  CollectionReference<Map<String, dynamic>> get _productsRef =>
      _firestore.collection('products');

  // Create a new product
  Future<String> createProduct(CreateProductModel product) async {
    try {
      // Check if user is authenticated (optional but recommended)
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to create products');
      }

      // Add the product to Firestore and get the document reference
      final docRef = await _productsRef.add(product.toJson());

      // Optionally, you can also create a subcollection for product history/audit
      await _productsRef.doc(docRef.id).collection('audit_logs').add({
        'action': 'created',
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'productData': product.toJson(),
      });

      return docRef.id; // Return the auto-generated document ID
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  // Create product with custom ID (useful for migrations)
  Future<void> createProductWithId(
    String documentId,
    CreateProductModel product,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to create products');
      }

      await _productsRef.doc(documentId).set(product.toJson());

      // Add to audit log
      await _productsRef.doc(documentId).collection('audit_logs').add({
        'action': 'created_with_id',
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'productData': product.toJson(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create product with ID: $e');
    }
  }

  // Update an existing product
  Future<void> updateProduct(
    String productId,
    CreateProductModel product,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to update products');
      }

      await _productsRef.doc(productId).update(product.toUpdateJson());

      // Add to audit log
      await _productsRef.doc(productId).collection('audit_logs').add({
        'action': 'updated',
        'updatedBy': user.uid,
        'updatedAt': FieldValue.serverTimestamp(),
        'productData': product.toUpdateJson(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        throw Exception('Product with ID $productId not found');
      }
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  // Delete a product
  Future<void> deleteProduct(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User must be authenticated to delete products');
      }

      // First, get the product data for the audit log
      final docSnapshot = await _productsRef.doc(productId).get();
      if (!docSnapshot.exists) {
        throw Exception('Product with ID $productId not found');
      }

      final productData = docSnapshot.data();

      // Delete the product
      await _productsRef.doc(productId).delete();

      // Add to audit log (in a separate deleted_products collection)
      await _firestore.collection('deleted_products').add({
        'originalId': productId,
        'deletedBy': user.uid,
        'deletedAt': FieldValue.serverTimestamp(),
        'productData': productData,
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // Get a product by ID (useful for editing)
  Future<CreateProductModel?> getProductById(String productId) async {
    try {
      final docSnapshot = await _productsRef.doc(productId).get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      return CreateProductModel(
        title: data['title'] ?? '',
        price: (data['price'] as num?)?.toDouble() ?? 0.0,
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        image: data['image'] ?? '',
        rating: Rating(
          rate: (data['rating']?['rate'] as num?)?.toDouble() ?? 0.0,
          count: (data['rating']?['count'] as int?) ?? 0,
        ),
        additionalImages: [],
      );
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  // Check if a product with the same title already exists (basic duplicate check)
  Future<bool> doesProductExist(String title) async {
    try {
      final querySnapshot = await _productsRef
          .where('title', isEqualTo: title)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check product existence: $e');
    }
  }
}
