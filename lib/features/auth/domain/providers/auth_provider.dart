import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/services/google_auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final StorageService _storageService;
  final ApiService _apiService;
  final GoogleAuthService _googleAuthService;

  AuthNotifier(
    this._storageService,
    this._apiService,
    this._googleAuthService,
  ) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check auth status on app startup
  Future<void> _checkAuthStatus() async {
    state = AuthState.loading();

    try {
      final token = await _storageService.getAuthToken();

      if (token != null && token.isNotEmpty) {
        try {
          final response = await _apiService.getMe();

          final userData = response.data['user'] ?? response.data;

          final user = UserModel(
            id: userData['id'],
            name: userData['name'],
            email: userData['email'],
          );

          state = AuthState.authenticated(user);
        } catch (e) {
          await _storageService.clearAll();
          state = AuthState.unauthenticated();
        }
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated('Failed to check auth status');
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    state = AuthState.loading();

    try {
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      final data = response.data;

      final token = data['accessToken'];

      if (token == null || token.toString().isEmpty) {
        throw Exception("Token missing from login response");
      }

      await _storageService.saveAuthToken(token.toString());

      final meResponse = await _apiService.getMe();
      final userData = meResponse.data['user'] ?? meResponse.data;

      final user = UserModel(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
      );

      await _storageService.saveUserData(
        userId: user.id,
        name: user.name,
        email: user.email,
      );

      state = AuthState.authenticated(user);
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      state = AuthState.unauthenticated(errorMessage);
    }
  }

  /// Signup
  Future<void> signup(String name, String email, String password) async {
    state = AuthState.loading();

    try {
      await _apiService.register(
        name: name,
        email: email,
        password: password,
      );

      final loginResponse = await _apiService.login(
        email: email,
        password: password,
      );

      final loginData = loginResponse.data;
      final token = loginData['accessToken'];

      if (token == null || token.toString().isEmpty) {
        throw Exception("Token missing from signup/login response");
      }

      await _storageService.saveAuthToken(token.toString());

      final meResponse = await _apiService.getMe();
      final userData = meResponse.data['user'] ?? meResponse.data;

      final user = UserModel(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
      );

      await _storageService.saveUserData(
        userId: user.id,
        name: user.name,
        email: user.email,
      );

      state = AuthState.authenticated(user);
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      state = AuthState.unauthenticated(errorMessage);
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    state = AuthState.loading();

    try {
      print('🚀 Starting Google login flow...');

      // Get Google ID token
      final idToken = await _googleAuthService.signInWithGoogle();

      if (idToken == null) {
        // User cancelled
        print('⚠️ Google login cancelled by user');
        state = AuthState.unauthenticated();
        return;
      }

      print('📤 Sending ID token to backend...');

      // Send ID token to backend
      final response = await _apiService.googleLogin(idToken: idToken);
      final data = response.data;

      print('✅ Backend response received');

      final token = data['accessToken'];

      if (token == null || token.toString().isEmpty) {
        throw Exception('Token missing from Google login response');
      }

      await _storageService.saveAuthToken(token.toString());
      print('💾 Access token saved');

      // Get user data
      final meResponse = await _apiService.getMe();
      final userData = meResponse.data['user'] ?? meResponse.data;

      final user = UserModel(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
      );

      await _storageService.saveUserData(
        userId: user.id,
        name: user.name,
        email: user.email,
      );

      print('🎉 Google login successful! Welcome ${user.name}');
      state = AuthState.authenticated(user);
    } catch (e) {
      print('❌ Google login failed: $e');
      final errorMessage = _extractErrorMessage(e);
      state = AuthState.unauthenticated(errorMessage);
    }
  }

  /// Logout
  Future<void> logout() async {
    state = AuthState.loading();

    try {
      await _googleAuthService.signOut();
      await _storageService.clearAll();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.unauthenticated(
        'Logout failed: ${e.toString()}',
      );
    }
  }

  /// Refresh auth status
  Future<void> refreshAuthStatus() async {
    await _checkAuthStatus();
  }

  /// Extract meaningful error message
  String _extractErrorMessage(dynamic error) {
    final message = error.toString();

    if (message.contains('401')) {
      return 'Invalid email or password';
    }

    if (message.contains('400')) {
      return 'Email already registered';
    }

    if (message.contains('Network')) {
      return 'Network error. Please check your connection.';
    }

    return 'Authentication failed. Please try again.';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final apiService = ref.watch(apiServiceProvider);
  final googleAuthService = ref.watch(googleAuthServiceProvider);

  return AuthNotifier(storageService, apiService, googleAuthService);
});
