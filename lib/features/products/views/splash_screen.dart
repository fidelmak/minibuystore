import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:minibuy/features/auth/controllers/auth_provider.dart';
// import your auth controller here
// import 'path_to_your_auth_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  // Get the AuthController instance
  late AuthController _authController;

  @override
  void initState() {
    super.initState();

    // Initialize AuthController
    _authController = Get.put(AuthController());

    // Initialize animations
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Start animations
    _animationController.forward();

    // Check authentication after splash delay
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    // Show splash screen for minimum 3 seconds for better UX
    await Future.delayed(Duration(seconds: 3));

    // Check if user is authenticated
    if (_authController.isLoggedIn && _authController.currentUser != null) {
      // User is authenticated, redirect to home
      Get.offAllNamed('/home');
    } else {
      // User is not authenticated, redirect to login
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A), // Dark background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ReusableLogo(),
                    ),
                  );
                },
              ),

              SizedBox(height: 20),

              // Animated App Name
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'MiniBuy',
                      style: TextStyle(
                        fontSize: 36,
                        color: Color(0xff007198),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 10),

              // Animated Tagline
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Your Ultimate Shopping Experience',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 40),

              // Loading indicator with auth status
              Obx(() {
                return Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xff007198),
                      ),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      _getLoadingText(),
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _getLoadingText() {
    if (_authController.isLoading) {
      return 'Checking authentication...';
    } else if (_authController.isLoggedIn) {
      return 'Welcome back, ${_authController.currentUser?.username ?? 'User'}!';
    } else {
      return 'Redirecting to login...';
    }
  }
}

class ReusableLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xff007198).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
        border: Border.all(color: Color(0xff007198).withOpacity(0.5), width: 3),
        image: DecorationImage(
          image: AssetImage('assets/images/minimart.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Alternative Splash Screen with more robust authentication checking
class EnhancedSplashScreen extends StatefulWidget {
  @override
  _EnhancedSplashScreenState createState() => _EnhancedSplashScreenState();
}

class _EnhancedSplashScreenState extends State<EnhancedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AuthController _authController;

  bool _isCheckingAuth = true;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    // Initialize animations
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _animationController.forward();

    // Initialize AuthController
    _authController = Get.put(AuthController());

    // Start authentication check
    await _performAuthenticationCheck();
  }

  Future<void> _performAuthenticationCheck() async {
    try {
      setState(() {
        _statusMessage = 'Checking authentication...';
      });

      // Wait minimum splash time
      await Future.delayed(Duration(seconds: 2));

      // Check authentication status
      if (_authController.isLoggedIn && _authController.currentUser != null) {
        setState(() {
          _statusMessage =
              'Welcome back, ${_authController.currentUser?.username}!';
        });

        // Short delay to show welcome message
        await Future.delayed(Duration(seconds: 1));

        // Navigate to home
        Get.offAllNamed('/home');
      } else {
        setState(() {
          _statusMessage = 'Redirecting to login...';
        });

        await Future.delayed(Duration(seconds: 1));

        // Navigate to login
        Get.offAllNamed('/login');
      }
    } catch (e) {
      // Handle any errors during auth check
      setState(() {
        _statusMessage = 'Authentication error, redirecting...';
      });

      await Future.delayed(Duration(seconds: 1));
      Get.offAllNamed('/login');
    } finally {
      setState(() {
        _isCheckingAuth = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with pulse animation
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.0),
                          duration: Duration(seconds: 1),
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: ReusableLogo(),
                            );
                          },
                        ),

                        SizedBox(height: 30),

                        // App name with typewriter effect
                        TweenAnimationBuilder<int>(
                          tween: IntTween(begin: 0, end: 7),
                          duration: Duration(seconds: 2),
                          builder: (context, value, child) {
                            return Text(
                              'MiniBuy'.substring(0, value),
                              style: TextStyle(
                                fontSize: 38,
                                color: Color(0xff007198),
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3.0,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 15),

                        Text(
                          'Your Ultimate Shopping Experience',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Status and loading section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isCheckingAuth) ...[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xff007198),
                        ),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 20),
                    ],

                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child: Text(
                        _statusMessage,
                        key: ValueKey(_statusMessage),
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
