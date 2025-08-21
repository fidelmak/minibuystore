import 'package:flutter/material.dart';
import 'package:minibuy/core/routes/app_pages.dart';
import 'package:minibuy/core/routes/app_routes.dart';

import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Pages ',
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
