import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minibuy/app.dart';
import 'package:minibuy/features/auth/controllers/auth_provider.dart';
import 'package:minibuy/features/create_products/service/create_product_service.dart';
import 'package:minibuy/features/products/controllers/cart_provider.dart';
import 'package:minibuy/features/products/controllers/product_provider.dart';
import 'package:minibuy/features/products/services/cart_service.dart';
import 'package:minibuy/features/products/services/firebase_product_service.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Firebase App Check - THIS FIXES YOUR ERROR

    print('Firebase and App Check initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  try {
    // Initialize GetStorage
    await GetStorage.init();
    print('GetStorage initialized successfully');
  } catch (e) {
    print('Error initializing GetStorage: $e');
  }

  // Initialize your services and controllers
  _initializeServices();

  runApp(const MyApp());
}

/// Initialize Firebase App Check
Future<void> _initializeAppCheck() async {
  try {
    if (kDebugMode) {
      // For development/testing - use debug provider
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
        // webProvider: ReCaptchaV3Provider('your-site-key'), // Only if you have web
      );
      print('App Check initialized with debug provider');
    } else {
      // For production - use Play Integrity (Android) and App Attest (iOS)
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
        // webProvider: ReCaptchaV3Provider('your-site-key'), // Only if you have web
      );
      print('App Check initialized with production providers');
    }
  } catch (e) {
    print('App Check initialization failed: $e');
    // App will still work, but you'll see the warning
  }
}

/// Initialize all GetX services and controllers
void _initializeServices() {
  try {
    Get.put(ProductService());
    Get.put(ProductProvider());
    Get.put(CartContoller()); // Fixed typo: was CartContoller
    Get.put(CartServices());
    Get.put(CreateProductService());
    Get.put(AuthController());

    print('All services initialized successfully');
  } catch (e) {
    print('Error initializing services: $e');
  }
}
