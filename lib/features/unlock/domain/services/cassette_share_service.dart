import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shared_cassette_model.dart';
import '../../../../data/services/api_service.dart';

final cassetteShareServiceProvider = Provider<CassetteShareService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CassetteShareService(apiService);
});

class CassetteShareService {
  final ApiService _apiService;

  CassetteShareService(this._apiService);

  // Base URL for the app (will be configured in production)
  static const String _baseUrl = 'https://digitalcassette.app';

  /// Generate a unique share code (6-8 alphanumeric characters)
  String generateShareCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Avoid confusing chars
    final random = Random();
    final length = 6;

    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Generate shareable URL from share code
  String generateShareUrl(String shareCode) {
    return '$_baseUrl/unlock/$shareCode';
  }

  /// Fetch cassette by share code
  Future<SharedCassetteModel?> getCassetteByShareCode(String shareCode) async {
    try {
      final response = await _apiService.getCassetteByShareCode(shareCode);
      final data = response.data;

      // Backend returns camelCase fields
      return SharedCassetteModel(
        id: data['id'] ?? shareCode, // Use actual UUID from backend
        shareCode: data['shareCode'],
        shareUrl: generateShareUrl(data['shareCode']),
        title: data['title'] ?? 'Untitled',
        youtubeVideoId: data['youtubeEmbedUrl'] ?? '',
        letterText: '', // Not available until unlocked
        photoUrl: data['thumbnailUrl'],
        emotionTag: data['emotionTag'],
        emotionEmoji: data['emotionEmoji'],
        senderName:
            data['senderIsAnonymous'] == true ? 'Anonymous' : 'Someone special',
        senderIsAnonymous: data['senderIsAnonymous'] ?? false,
        password: '', // Don't expose password
        createdAt: DateTime.now(), // Not available in metadata
        expiresAt: null,
        isActive: true,
        isDeleted: false,
        unlockCount: data['unlockCount'] ?? 0,
        maxUnlocks: 0,
      );
    } catch (e) {
      print('Error loading cassette: $e');
      // Return null if cassette not found or error
      return null;
    }
  }

  /// Validate password and get unlocked cassette data
  Future<Map<String, dynamic>?> unlockCassetteWithPassword(
    String shareCode,
    String password,
  ) async {
    try {
      final response = await _apiService.unlockCassette(
        shareCode: shareCode,
        password: password,
      );
      // Return the unlocked data if successful
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('Error unlocking cassette: $e');
      // Wrong password or other error
      return null;
    }
  }

  /// Save cassette to user's library
  Future<bool> saveCassetteToLibrary(
    String cassetteId,
    String userId,
  ) async {
    try {
      final response = await _apiService.saveCassette(cassetteId);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Check if cassette is valid and can be unlocked
  CassetteValidationResult validateCassette(SharedCassetteModel cassette) {
    if (cassette.isDeleted) {
      return CassetteValidationResult.deleted;
    }

    if (!cassette.isActive) {
      return CassetteValidationResult.inactive;
    }

    if (cassette.isExpired) {
      return CassetteValidationResult.expired;
    }

    if (cassette.maxUnlocks > 0 &&
        cassette.unlockCount >= cassette.maxUnlocks) {
      return CassetteValidationResult.maxUnlocksReached;
    }

    return CassetteValidationResult.valid;
  }
}

enum CassetteValidationResult {
  valid,
  deleted,
  inactive,
  expired,
  maxUnlocksReached,
  notFound,
}

extension CassetteValidationResultExtension on CassetteValidationResult {
  String get errorTitle {
    switch (this) {
      case CassetteValidationResult.valid:
        return 'Valid';
      case CassetteValidationResult.deleted:
        return 'Cassette Removed';
      case CassetteValidationResult.inactive:
        return 'Cassette Unavailable';
      case CassetteValidationResult.expired:
        return 'Cassette Expired';
      case CassetteValidationResult.maxUnlocksReached:
        return 'Unlock Limit Reached';
      case CassetteValidationResult.notFound:
        return 'Cassette Not Found';
    }
  }

  String get errorMessage {
    switch (this) {
      case CassetteValidationResult.valid:
        return '';
      case CassetteValidationResult.deleted:
        return 'This cassette has been removed by the sender.';
      case CassetteValidationResult.inactive:
        return 'This cassette is no longer available.';
      case CassetteValidationResult.expired:
        return 'This cassette has expired and can no longer be opened.';
      case CassetteValidationResult.maxUnlocksReached:
        return 'This cassette has reached its maximum unlock limit.';
      case CassetteValidationResult.notFound:
        return 'We couldn\'t find this cassette. The link may be invalid.';
    }
  }
}
