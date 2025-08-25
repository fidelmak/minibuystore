import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:minibuy/features/auth/controllers/auth_provider.dart';
import 'package:minibuy/features/auth/widgets/custom_text_field.dart';
import 'package:minibuy/features/products/widgets/custom_button.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await _authController.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      Get.snackbar(
        'Success',
        _authController.successMessage,
        backgroundColor: Colors.green,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offNamed('/login'); // Go to login page
    } else {
      Get.snackbar(
        'Error',
        _authController.errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[20],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 30),

                // Welcome Text
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Register to get started',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),

                // Username Field
                CustomTextField(
                  label: 'Username',
                  hintText: 'Enter your username',
                  controller: _usernameController,
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),

                  borderColor: Colors.grey[600],
                  focusedBorderColor: Color(0xFFF17547),
                ),
                SizedBox(height: 20),

                // Email Field
                CustomTextField(
                  label: 'Email',
                  hintText: 'Enter your email',
                  controller: _emailController,
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  borderColor: Colors.grey[600],
                  focusedBorderColor: Color(0xFFF17547),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),

                // Password Field
                CustomPasswordField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  borderColor: Colors.grey[600],
                  focusedBorderColor: Color(0xFFF17547),
                ),
                SizedBox(height: 20),

                // Confirm Password Field
                CustomPasswordField(
                  label: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  labelStyle: TextStyle(color: Colors.black, fontSize: 16),
                  borderColor: Colors.grey[600],
                  focusedBorderColor: Color(0xFFF17547),
                ),
                SizedBox(height: 40),

                // Register Button
                Obx(
                  () => _authController.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFF17547),
                            ),
                          ),
                        )
                      : CustomButton(
                          text: 'REGISTER',
                          onPressed: _register,
                          color: Color(0xFFF17547),
                          textColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                ),
                SizedBox(height: 30),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    TextButton(
                      onPressed: () => Get.offNamed('/login'),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFFF17547),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
