import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minibuy/features/auth/controllers/auth_provider.dart';
import 'package:minibuy/features/auth/widgets/custom_text_field.dart';
import 'package:minibuy/features/products/widgets/custom_button.dart';

// LOGIN PAGE
class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      Get.offAllNamed('/home'); // Navigate to home and clear stack
    } else {
      Get.snackbar(
        'Error',
        _authController.errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address first',
        backgroundColor: Colors.orange,
        colorText: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final success = await _authController.sendPasswordResetEmail(
      _emailController.text.trim(),
    );

    if (success) {
      Get.snackbar(
        'Success',
        _authController.successMessage,
        backgroundColor: Colors.green,
        colorText: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        _authController.errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.black87,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[20],
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),

              // Welcome Text
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Login to your account',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),

              // Email Field
              CustomTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: _emailController,
                labelStyle: TextStyle(color: Colors.black87, fontSize: 16),
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
                labelStyle: TextStyle(color: Colors.black87, fontSize: 16),
                borderColor: Colors.grey[600],
                focusedBorderColor: Color(0xFFF17547),
              ),
              SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _forgotPassword,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFFF17547)),
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Login Button
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
                        text: 'LOGIN',
                        onPressed: _login,
                        color: Color(0xFFF17547),
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
              ),
              SizedBox(height: 30),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/register'),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFF17547),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
