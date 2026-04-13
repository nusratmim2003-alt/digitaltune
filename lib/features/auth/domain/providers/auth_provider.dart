import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../data/services/bdapps_auth_service.dart';
import '../../../../data/services/api_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final StorageService _storageService;
  final BdappsAuthService _bdappsAuthService;
  final ApiService _apiService;

  AuthNotifier(
    this._storageService,
    this._bdappsAuthService,
    this._apiService,
  ) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  String _buildEmailFromPhone(String phone) => 'bdapps_$phone@tuneletter.app';
  String _buildPasswordFromPhone(String phone) => 'bdapps-$phone-otp';
  String _buildDisplayNameFromPhone(String phone) => 'TuneLetter User';

  Future<bool> _ensureBackendSession(String phone) async {
    final email = _buildEmailFromPhone(phone);
    final password = _buildPasswordFromPhone(phone);

    try {
      final loginResponse = await _apiService.login(
        email: email,
        password: password,
      );

      final token = loginResponse.data['accessToken']?.toString();
      if (token == null || token.isEmpty) return false;

      await _storageService.saveAuthToken(token);
      return true;
    } on DioException catch (e) {
      // If account doesn't exist yet (or login fails), try register then login.
      if (e.response?.statusCode == 401 || e.response?.statusCode == 404) {
        try {
          await _apiService.register(
            name: _buildDisplayNameFromPhone(phone),
            email: email,
            password: password,
          );
        } on DioException catch (registerErr) {
          // 400 usually means already exists - continue to login attempt.
          if (registerErr.response?.statusCode != 400) {
            return false;
          }
        } catch (_) {
          return false;
        }

        try {
          final loginResponse = await _apiService.login(
            email: email,
            password: password,
          );
          final token = loginResponse.data['accessToken']?.toString();
          if (token == null || token.isEmpty) return false;

          await _storageService.saveAuthToken(token);
          return true;
        } catch (_) {
          return false;
        }
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// Check auth status on app startup (frontend-only BDApps session)
  Future<void> _checkAuthStatus() async {
    state = AuthState.loading();

    try {
      final isLoggedIn = await _storageService.getBool('isLoggedIn') ?? false;
      final phone = await _storageService.getString('userPhone');

      if (isLoggedIn && phone != null && phone.isNotEmpty) {
        final subscribed =
            await _bdappsAuthService.checkAlreadySubscribed(phone);

        if (subscribed) {
          final backendSessionReady = await _ensureBackendSession(phone);
          if (!backendSessionReady) {
            await _storageService.clearAll();
            state = AuthState.unauthenticated(
              'Login expired. Please login again.',
            );
            return;
          }

          final user = UserModel(
            id: phone,
            name: _buildDisplayNameFromPhone(phone),
            email: '$phone@bdapps.local',
          );

          await _storageService.saveUserData(
            userId: user.id,
            name: user.name,
            email: user.email,
          );

          state = AuthState.authenticated(user);
        } else {
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

  /// Complete login after successful BDApps subscription/OTP verification
  Future<bool> loginWithPhone(String phone) async {
    state = AuthState.loading();

    try {
      final backendSessionReady = await _ensureBackendSession(phone);
      if (!backendSessionReady) {
        state = AuthState.unauthenticated(
          'Backend session failed. Please try again.',
        );
        return false;
      }

      final user = UserModel(
        id: phone,
        name: _buildDisplayNameFromPhone(phone),
        email: '$phone@bdapps.local',
      );

      await _storageService.setBool('isLoggedIn', true);
      await _storageService.setString('userPhone', phone);

      await _storageService.saveUserData(
        userId: user.id,
        name: user.name,
        email: user.email,
      );

      state = AuthState.authenticated(user);
      return true;
    } catch (e) {
      state = AuthState.unauthenticated('Login failed. Please try again.');
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    state = AuthState.loading();

    try {
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
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  final bdappsAuthService = ref.watch(bdappsAuthServiceProvider);
  final apiService = ref.watch(apiServiceProvider);

  return AuthNotifier(storageService, bdappsAuthService, apiService);
});
