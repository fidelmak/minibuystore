import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minibuy/features/auth/controllers/auth_provider.dart';
import 'package:minibuy/features/products/controllers/cart_provider.dart';
import 'package:minibuy/features/products/controllers/product_provider.dart';
import 'package:minibuy/features/products/widgets/custom_drawer.dart';

import 'package:minibuy/features/products/widgets/custom_greetings.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:async'; // Add this import for Timer

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductProvider productController = Get.find<ProductProvider>();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (productController.products.isEmpty) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % productController.products.length;
      });

      itemScrollController.scrollTo(
        index: _currentIndex,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController _authController = Get.find<AuthController>();
    return Scaffold(
      drawer: CustomDrawer(
        profileImage:
            'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
        userName: _authController.currentUser?.username ?? 'Guest User',
        email: _authController.currentUser?.email ?? ' No Email',
        items: [
          DrawerItem(label: 'Home', icon: Icons.home, index: 0),
          DrawerItem(label: 'Categories', icon: Icons.category, index: 1),
          DrawerItem(label: 'Cart', icon: Icons.shopping_cart, index: 2),
          DrawerItem(label: 'Profile', icon: Icons.person, index: 3),

          DrawerItem(
            label: "Admin",
            icon: Icons.admin_panel_settings,
            index: 4,
          ),
          DrawerItem(label: "logout", icon: Icons.logout, index: 5),
        ],
        onItemSelected: (index) {
          Navigator.pop(context); // Close the drawer
          switch (index) {
            case 0:
              Get.toNamed('/product');
              break;
            case 1:
              Get.toNamed('/categories');
              break;
            case 2:
              Get.toNamed('/cart');
              break;
            case 3:
              Get.toNamed('/profile');
              break;
            case 4:
              Get.toNamed('/create_product');
              break;
            case 5:
              _authController.logout();
              Get.offAllNamed('/login');
              break;
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFF17547),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              final CartContoller cartController = Get.find<CartContoller>();
              final cartCount = cartController.cartItems.length;
              return Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                  ), // Use Icon instead of IconButton
                  if (cartCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,

                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: const Color(0xFFF17547),
                            width: 1,
                          ),
                        ),

                        child: Text(
                          cartCount.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 8, // Reduced font size for better fit
                            color: Color(0xFFF17547),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation based on the tapped index
          switch (index) {
            case 0:
              // Already on Home, do nothing or refresh
              break;
            case 1:
              // Navigate to Categories screen
              Get.toNamed('/categories');
              break;
            case 2:
              // Navigate to Cart screen
              Get.toNamed('/cart');
              break;
            case 3:
              // Navigate to Profile screen
              Get.toNamed('/create_product');
              break;
          }
        },
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF17547),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
        title: ReusableGreeting(
          name: _authController.currentUser?.username ?? 'Guest User',
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search, size: 32),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (productController.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final randomProducts = List.of(productController.products)..shuffle();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Products',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // In your controller or before building the widget
              SizedBox(
                height: 60,
                child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                  itemCount: randomProducts.length, // Use the shuffled list
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product =
                        randomProducts[index]; // Access shuffled list
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? const Color(0xFFF17547).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  "/product_details",
                                  arguments: product,
                                );
                              },
                              child: Text(
                                product.title ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _currentIndex == index
                                      ? const Color(0xFFF17547)
                                      : Colors.black,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // ... rest of your code remains the same
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Products',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '${productController.products.length}',
                      style: const TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: productController.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = productController.products[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed("/product_details", arguments: product);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 0.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                product.image ?? '',
                                height: 100,
                                width: 100,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error, size: 50),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.title ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      " ₦",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${product.price}",
                                      style: const TextStyle(
                                        color: Color(0xFFF17547),
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (product.rating != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Rating: ${product.rating!.rate.toString()}  ⭐',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
