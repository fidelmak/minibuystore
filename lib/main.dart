import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minibuy/app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minibuy/features/create_products/service/create_product_service.dart';
import 'package:minibuy/features/products/controllers/cart_provider.dart';
import 'package:minibuy/features/products/controllers/product_provider.dart';
import 'package:minibuy/features/products/services/cart_service.dart';
import 'package:minibuy/features/products/services/product_service.dart';
import 'package:minibuy/firebase_options.dart';

void main() async {
  // Ensure Widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    // You might want to handle this error appropriately
  }

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize your services and controllers
  Get.put(ProductService());
  Get.put(ProductProvider());
  Get.put(CartContoller());
  Get.put(CartServices());
  Get.put(CreateProductService()); // Add your new service

  runApp(const MyApp());
}
