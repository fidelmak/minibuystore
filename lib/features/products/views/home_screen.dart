import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:minibuy/features/products/controllers/product_provider.dart';
import 'package:minibuy/features/products/widgets/custom_banner.dart';
import 'package:minibuy/features/products/widgets/custom_category_tab.dart';
import 'package:minibuy/features/products/widgets/custom_greetings.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ProductProvider productController = Get.find<ProductProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation
        },
      ),
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: ReusableGreeting(name: 'PaulFidelis'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to MiniBuy',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 60, // Fixed height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productController.products.length,
                  itemBuilder: (context, index) {
                    final product = productController.products[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Text(
                            product.title ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '${productController.products.length}',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: productController.products.length,
                  itemBuilder: (BuildContext context, int index) {
                    final product = productController.products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 0.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            product.image ?? '',
                            height: 100,
                            width: 100,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.title ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('\$${product.price.toString()}'),
                          ),
                          if (product.rating != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Rating: ${product.rating!.rate.toString()}',
                              ),
                            ),
                        ],
                      ),
                    );

                    // ListTile(
                    //   title: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(product.title ?? ''),
                    //   ),
                    //   subtitle: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Text(product.price.toString()),
                    //   ),
                    //   onTap: () {
                    //     Get.toNamed("/product_details", arguments: product);
                    //   },
                    // );
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
