import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bdappsAuthServiceProvider = Provider<BdappsAuthService>((ref) {
  return BdappsAuthService();
});

class BdappsAuthService {
  static const String _baseUrl = 'https://www.flicksize.com/tuneletter/';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      responseType: ResponseType.json,
      headers: {'Accept': 'application/json'},
    ),
  );

  bool isSupportedRobiAirtelNumber(String phone) {
    return RegExp(r'^01(?:6|8)\d{8}$').hasMatch(phone);
  }

  Future<bool> checkAlreadySubscribed(String phone) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/check_subscription.php',
        data: {'user_mobile': phone},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final decoded = response.data;
      if (decoded is! Map) return false;

      final status =
          decoded['subscriptionStatus']?.toString().trim().toUpperCase() ?? '';
      return status == 'REGISTERED';
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await _dio.post(
      '$_baseUrl/send_otp.php',
      data: {'user_mobile': phone},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }

    throw Exception('Invalid server response');
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String referenceNo,
    required String phone,
  }) async {
    final response = await _dio.post(
      '$_baseUrl/verify_otp.php',
      data: {
        'Otp': otp,
        'referenceNo': referenceNo,
        'user_mobile': phone,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }

    throw Exception('Invalid server response');
  }

  Future<bool> waitForSubscriptionSync(String phone) async {
    for (var i = 0; i < 5; i++) {
      await Future.delayed(const Duration(seconds: 1));
      final isSubscribed = await checkAlreadySubscribed(phone);
      if (isSubscribed) return true;
    }

    return false;
  }

  /// Unsubscribe the given phone number from BDApps subscription.
  /// Returns the parsed response map from the unsubscription endpoint.
  Future<Map<String, dynamic>> unsubscribe(String phone) async {
    final response = await _dio.post(
      '$_baseUrl/unsubscription.php',
      data: {'user_mobile': phone},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }

    // Some endpoints may return plain text — try to decode if possible
    try {
      if (response.data is String) {
        return Map<String, dynamic>.from(response.data as Map);
      }
    } catch (_) {}

    throw Exception('Invalid server response from unsubscribe endpoint');
  }
}
