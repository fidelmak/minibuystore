import 'package:flutter/material.dart';
import 'package:minibuy/features/auth/widgets/custom_btn.dart';
import 'package:minibuy/features/auth/widgets/custom_social_icon.dart';
import 'package:minibuy/features/auth/widgets/custom_text_field.dart';
import 'package:minibuy/features/products/views/home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ReusableTextField(label: 'Username or Email', icon: Icons.person),
            SizedBox(height: 10),
            ReusableTextField(
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20),
            ReusableButton(text: 'Login', color: Colors.red),
            SizedBox(height: 20),
            Text('- OR Continue with -', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            ReusableSocialButtons(),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: Text(
                'Create An Account Sign Up',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
