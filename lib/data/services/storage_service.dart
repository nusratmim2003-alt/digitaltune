import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const String _keyAccessToken = 'access_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Auth token management (secure storage)
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _keyAccessToken, value: token);
    } catch (e) {
      print('Error saving auth token: $e');
    }
  }

  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: _keyAccessToken);
    } catch (e) {
      print('Error reading auth token: $e');
      return null;
    }
  }

  Future<void> deleteAuthToken() async {
    try {
      await _secureStorage.delete(key: _keyAccessToken);
    } catch (e) {
      print('Error deleting auth token: $e');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // User data management (shared preferences)
  Future<void> saveUserData({
    required String userId,
    required String name,
    required String email,
  }) async {
    await init();
    await _prefs?.setString(_keyUserId, userId);
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
  }

  Future<String?> getUserId() async {
    await init();
    return _prefs?.getString(_keyUserId);
  }

  Future<String?> getUserName() async {
    await init();
    return _prefs?.getString(_keyUserName);
  }

  Future<String?> getUserEmail() async {
    await init();
    return _prefs?.getString(_keyUserEmail);
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    try {
      await init();
      await _secureStorage.deleteAll();
      await _prefs?.clear();
    } catch (e) {
      print('Error clearing storage: $e');
    }
  }

  // Settings
  Future<void> setBool(String key, bool value) async {
    await init();
    await _prefs?.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    await init();
    return _prefs?.getBool(key);
  }

  Future<void> setString(String key, String value) async {
    await init();
    await _prefs?.setString(key, value);
  }

  Future<String?> getString(String key) async {
    await init();
    return _prefs?.getString(key);
  }
}
