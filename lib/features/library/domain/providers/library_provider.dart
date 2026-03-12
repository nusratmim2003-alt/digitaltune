import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/services/api_service.dart';
import '../../../../data/models/cassette.dart';

// Library state
class LibraryState {
  final bool isLoading;
  final List<Cassette> sentCassettes;
  final List<Cassette> inboxCassettes;
  final List<Cassette> savedCassettes;
  final String? errorMessage;

  LibraryState({
    this.isLoading = false,
    this.sentCassettes = const [],
    this.inboxCassettes = const [],
    this.savedCassettes = const [],
    this.errorMessage,
  });

  LibraryState copyWith({
    bool? isLoading,
    List<Cassette>? sentCassettes,
    List<Cassette>? inboxCassettes,
    List<Cassette>? savedCassettes,
    String? errorMessage,
  }) {
    return LibraryState(
      isLoading: isLoading ?? this.isLoading,
      sentCassettes: sentCassettes ?? this.sentCassettes,
      inboxCassettes: inboxCassettes ?? this.inboxCassettes,
      savedCassettes: savedCassettes ?? this.savedCassettes,
      errorMessage: errorMessage,
    );
  }
}

// Library notifier
class LibraryNotifier extends StateNotifier<LibraryState> {
  final ApiService _apiService;

  LibraryNotifier(this._apiService) : super(LibraryState());

  // Fetch sent cassettes
  Future<void> fetchSentCassettes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.getSentCassettes();
      final data = response.data;
      final items =
          (data['items'] as List).map((item) => _parseCassette(item)).toList();

      state = state.copyWith(
        isLoading: false,
        sentCassettes: items,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load sent cassettes',
      );
    }
  }

  // Fetch inbox cassettes
  Future<void> fetchInboxCassettes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.getInboxCassettes();
      final data = response.data;
      final items =
          (data['items'] as List).map((item) => _parseCassette(item)).toList();

      state = state.copyWith(
        isLoading: false,
        inboxCassettes: items,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load inbox',
      );
    }
  }

  // Fetch saved cassettes
  Future<void> fetchSavedCassettes() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.getSavedCassettes();
      final data = response.data;
      final items =
          (data['items'] as List).map((item) => _parseCassette(item)).toList();

      state = state.copyWith(
        isLoading: false,
        savedCassettes: items,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load saved cassettes',
      );
    }
  }

  // Parse cassette from API response
  Cassette _parseCassette(Map<String, dynamic> item) {
    return Cassette(
      id: (item['cassetteId'] ?? item['id']).toString(),
      senderId: item['senderId'] ?? item['sender_id'],
      senderName: item['senderName'] ??
          item['sender_name'] ??
          item['latestReplySenderName'] ??
          'Unknown',
      youtubeLink: item['youtubeLink'] ?? item['youtube_link'] ?? '',
      letterText: item['letterText'] ?? item['letter_text'] ?? '',
      photoUrl: item['coverImageUrl'] ?? item['cover_image_url'],
      emotionTag:
          _parseEmotionTag(item['emotionTag'] ?? item['emotion_tag'] ?? 'love'),
      isAnonymous:
          item['senderIsAnonymous'] ?? item['sender_is_anonymous'] ?? false,
      shareableLink: item['shareableLink'] ?? item['shareable_link'] ?? '',
      createdAt: DateTime.parse(item['createdAt'] ??
          item['created_at'] ??
          DateTime.now().toIso8601String()),
      replyCount: item['replyCount'] ?? item['reply_count'] ?? 0,
      isRead: item['isRead'] ?? item['is_read'] ?? false,
    );
  }

  // Parse emotion tag string to enum
  EmotionTag _parseEmotionTag(String tag) {
    switch (tag.toLowerCase()) {
      case 'joyful':
        return EmotionTag.joyful;
      case 'melancholic':
        return EmotionTag.melancholic;
      case 'nostalgic':
        return EmotionTag.nostalgic;
      case 'hopeful':
        return EmotionTag.hopeful;
      case 'romantic':
        return EmotionTag.romantic;
      case 'bittersweet':
        return EmotionTag.bittersweet;
      case 'peaceful':
        return EmotionTag.peaceful;
      case 'energetic':
        return EmotionTag.energetic;
      default:
        return EmotionTag.joyful;
    }
  }
}

// Provider
final libraryProvider =
    StateNotifierProvider<LibraryNotifier, LibraryState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return LibraryNotifier(apiService);
});
