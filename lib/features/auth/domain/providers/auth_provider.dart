import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../data/services/bdapps_auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final StorageService _storageService;
  final BdappsAuthService _bdappsAuthService;

  AuthNotifier(
    this._storageService,
    this._bdappsAuthService,
  ) : super(AuthState.initial()) {
    _checkAuthStatus();
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
          final user = UserModel(
            id: phone,
            name: phone,
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
  Future<void> loginWithPhone(String phone) async {
    state = AuthState.loading();

    try {
      final user = UserModel(
        id: phone,
        name: phone,
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
    } catch (e) {
      state = AuthState.unauthenticated('Login failed. Please try again.');
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

  return AuthNotifier(storageService, bdappsAuthService);
});
