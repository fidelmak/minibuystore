import 'package:get/get.dart';
import 'package:minibuy/features/auth/models/user_model.dart';
import 'package:minibuy/features/auth/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Reactive state variables
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _successMessage = ''.obs;

  // Getters
  UserModel? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  String get errorMessage => _errorMessage.value;
  String get successMessage => _successMessage.value;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  // Initialize authentication state
  void _initializeAuth() {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        _getCurrentUserData();
      } else {
        _currentUser.value = null;
        _isLoggedIn.value = false;
      }
    });
  }

  // Get current user data
  Future<void> _getCurrentUserData() async {
    try {
      final userData = await _authService.getCurrentUserData();
      if (userData != null) {
        _currentUser.value = userData;
        _isLoggedIn.value = true;
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  // Clear messages
  void clearMessages() {
    _errorMessage.value = '';
    _successMessage.value = '';
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      _isLoading.value = true;
      clearMessages();

      final request = LoginRequest(email: email, password: password);
      final user = await _authService.loginUser(request);

      _currentUser.value = user;
      _isLoggedIn.value = true;
      _successMessage.value = 'Login successful!';

      return true;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Register
  Future<bool> register(String email, String password) async {
    try {
      _isLoading.value = true;
      clearMessages();

      final request = RegistrationRequest(
        email: email,
        password: password,
        username: email.split('@')[0],
      );

      final user = await _authService.registerUser(request);

      _successMessage.value = 'Registration successful! Please login.';
      return true;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _isLoading.value = true;
      await _authService.logoutUser();

      _currentUser.value = null;
      _isLoggedIn.value = false;
      _successMessage.value = 'Logged out successfully!';
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading.value = false;
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _isLoading.value = true;
      clearMessages();

      await _authService.sendPasswordResetEmail(email);
      _successMessage.value = 'Password reset email sent!';
      return true;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Update profile
  Future<bool> updateProfile(String username) async {
    try {
      _isLoading.value = true;
      clearMessages();

      if (_currentUser.value == null) {
        throw Exception('No user logged in');
      }

      final updatedUser = _currentUser.value!.copyWith(username: username);
      final user = await _authService.updateUserProfile(updatedUser);

      _currentUser.value = user;
      _successMessage.value = 'Profile updated successfully!';
      return true;
    } catch (e) {
      _errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
