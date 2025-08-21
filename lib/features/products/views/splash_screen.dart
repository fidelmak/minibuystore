import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 10), () {
      Get.toNamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableLogo(),
            SizedBox(height: 10),
            Text(
              'MiniBuy',
              style: TextStyle(
                fontSize: 32,
                color: const Color.fromARGB(255, 199, 179, 2),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        image: DecorationImage(
          image: AssetImage(
            'assets/images/minimart.jpeg',
          ), // Replace with your logo path
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
