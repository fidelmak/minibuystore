import 'package:flutter/material.dart';
import 'package:minibuy/features/products/widgets/custom_banner.dart';
import 'package:minibuy/features/products/widgets/custom_category_tab.dart';
import 'package:minibuy/features/products/widgets/custom_greetings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableGreeting(name: 'Fola'),
            SizedBox(height: 10),
            ReusableOfferBanner(
              text: '20% OFF DURING THE WEEKEND',
              color: Colors.orange,
              buttonText: 'Get Now',
            ),
            ReusableOfferBanner(
              text: '20% OFF WEEKEND',
              color: Colors.blue,
              buttonText: 'Get Now',
            ),
            SizedBox(height: 10),
            Text(
              'Top Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text('See All', style: TextStyle(color: Colors.orange)),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ReusableCategoryItem(
                    image: Icons.watch,
                    text: 'Redmi Note 4',
                    price: '\$45,000 - \$55,000',
                    discount: '50% OFF',
                  ),
                  ReusableCategoryItem(
                    image: Icons.watch,
                    text: 'Apple Watch - series 6',
                    price: '\$45,000 - \$55,000',
                    discount: '50% OFF',
                  ),
                  ReusableCategoryItem(
                    image: Icons.watch,
                    text: 'Watch Model',
                    price: '\$45,000 - \$55,000',
                    discount: '50% OFF',
                  ),
                  ReusableCategoryItem(
                    image: Icons.watch,
                    text: 'Another Watch',
                    price: '\$45,000 - \$55,000',
                    discount: '50% OFF',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
