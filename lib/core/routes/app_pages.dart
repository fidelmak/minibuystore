import 'package:get/get.dart';
import 'package:minibuy/core/binding/app_binding.dart';
import 'package:minibuy/core/routes/app_routes.dart';
import 'package:minibuy/features/create_products/views/create_product_page.dart';
import 'package:minibuy/features/products/views/cart_page.dart';
import 'package:minibuy/features/products/views/home_screen.dart';
import 'package:minibuy/features/auth/views/login_screen.dart';
import 'package:minibuy/features/products/views/payment_page.dart';
import 'package:minibuy/features/products/views/product_details.dart';
import 'package:minibuy/features/products/views/splash_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      bindings: [AppBindings()],
    ),
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => ProductDetails(),
      bindings: [AppBindings()],
    ),
    // GetPage(name: AppRoutes.profile, page: () => ProfileScreen()),
    // GetPage(name: AppRoutes.onboarding, page: () => OnboardingScreen()),
    // GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    // GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordScreen()),
    // GetPage(name: AppRoutes.resetPassword, page: () => ResetPasswordScreen()),
    // GetPage(name: AppRoutes.allproduct, page: () => AllProductScreen()),
    // GetPage(name: AppRoutes.productDetails, page: () => ProductDetailsScreen()),
    GetPage(
      name: AppRoutes.cart,
      page: () => CartView(),
      bindings: [AppBindings()],
    ),
    GetPage(name: AppRoutes.checkout, page: () => Checkout()),
    GetPage(name: AppRoutes.create, page: () => CreateProductPage()),
    // GetPage(name: AppRoutes.orderHistory, page: () => OrderHistoryScreen()),
    // GetPage(name: AppRoutes.orderDetails, page: () => OrderDetailsScreen()),
  ];
}
