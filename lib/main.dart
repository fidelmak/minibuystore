import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minibuy/app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minibuy/features/products/controllers/product_provider.dart';
import 'package:minibuy/features/products/services/product_service.dart';

void main() async {
  // await GetStorage.init();
  Get.put(ProductService());
  Get.put(ProductProvider());
  runApp(const MyApp());
}
