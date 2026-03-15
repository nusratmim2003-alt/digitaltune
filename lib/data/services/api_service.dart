import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'storage_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiService(storageService);
});

class ApiService {
  final StorageService _storageService;
  late final Dio _dio;

  // Change to your PC's IP when testing on phone
  // Use 'http://localhost:8000/api' for web/desktop
  // Use 'http://192.168.5.173:8000/api' for phone on same WiFi
  static const String baseUrl = 'https://digitalcassette-api.onrender.com/api';

  ApiService(this._storageService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _storageService.deleteAuthToken();
          }
          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  // ========================================
  // AUTH
  // ========================================

  Future<Response> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return _dio.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> getMe() async {
    return _dio.get('/auth/me');
  }

  Future<Response> googleLogin({required String idToken}) async {
    return _dio.post('/auth/google', data: {'idToken': idToken});
  }

  // ========================================
  // CASSETTES
  // ========================================

  Future<Response> createCassette({
    required String youtubeUrl,
    required String letterText,
    required String emotionTag,
    required String password,
    required bool senderIsAnonymous,
    String? coverImageUrl,
  }) async {
    return _dio.post(
      '/cassettes',
      data: {
        'youtubeUrl': youtubeUrl,
        'letterText': letterText,
        'emotionTag': emotionTag,
        'password': password,
        'senderIsAnonymous': senderIsAnonymous,
        'coverImageUrl': coverImageUrl,
      },
    );
  }

  Future<Response> getCassetteByShareCode(String shareCode) async {
    return _dio.get('/cassettes/$shareCode');
  }

  Future<Response> unlockCassette({
    required String shareCode,
    required String password,
  }) async {
    return _dio.post(
      '/cassettes/$shareCode/unlock',
      data: {'password': password},
    );
  }

  // ========================================
  // LIBRARY
  // ========================================

  Future<Response> getSentCassettes() async {
    return _dio.get('/library/sent');
  }

  Future<Response> getSavedCassettes() async {
    return _dio.get('/library/saved');
  }

  Future<Response> getInboxCassettes() async {
    return _dio.get('/library/inbox');
  }

  Future<Response> saveCassette(String cassetteId) async {
    return _dio.post('/library/save/$cassetteId');
  }

  Future<Response> unsaveCassette(String cassetteId) async {
    return _dio.delete('/library/save/$cassetteId');
  }

  // ========================================
  // REPLIES
  // ========================================

  Future<Response> createReply({
    required String cassetteId,
    required String youtubeUrl,
    required String replyText,
    String? coverImageUrl,
  }) async {
    return _dio.post(
      '/replies/$cassetteId',
      data: {
        'youtubeUrl': youtubeUrl,
        'replyText': replyText,
        'coverImageUrl': coverImageUrl,
      },
    );
  }

  Future<Response> getReplies(String cassetteId) async {
    return _dio.get('/replies/$cassetteId');
  }

  Future<Response> getCassetteById(String cassetteId) async {
    return _dio.get('/cassettes/by-id/$cassetteId');
  }

  // ========================================
  // UPTIME / HEALTH
  // ========================================

  /// Silent keep-alive ping — hits /health directly (not /api).
  /// Called periodically so the Render free-tier instance never sleeps.
  Future<void> pingHealth() async {
    try {
      await Dio().get(
        'https://digitalcassette-api.onrender.com/health',
        options: Options(
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
    } catch (_) {
      // Intentionally silent — this is just a keep-alive probe.
    }
  }
}
