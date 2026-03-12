import 'package:json_annotation/json_annotation.dart';

part 'cassette.g.dart';

enum EmotionTag {
  joyful,
  melancholic,
  nostalgic,
  hopeful,
  romantic,
  bittersweet,
  peaceful,
  energetic
}

@JsonSerializable()
class Cassette {
  final String id;
  final String? senderId;
  final String? senderName;
  final String youtubeLink;
  final String letterText;
  final String? photoUrl;
  final EmotionTag emotionTag;
  final bool isAnonymous;
  final String shareableLink;
  final DateTime createdAt;
  final int replyCount;
  final bool isRead;

  const Cassette({
    required this.id,
    this.senderId,
    this.senderName,
    required this.youtubeLink,
    required this.letterText,
    this.photoUrl,
    required this.emotionTag,
    required this.isAnonymous,
    required this.shareableLink,
    required this.createdAt,
    this.replyCount = 0,
    this.isRead = false,
  });

  factory Cassette.fromJson(Map<String, dynamic> json) =>
      _$CassetteFromJson(json);
  Map<String, dynamic> toJson() => _$CassetteToJson(this);

  Cassette copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? youtubeLink,
    String? letterText,
    String? photoUrl,
    EmotionTag? emotionTag,
    bool? isAnonymous,
    String? shareableLink,
    DateTime? createdAt,
    int? replyCount,
    bool? isRead,
  }) {
    return Cassette(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      letterText: letterText ?? this.letterText,
      photoUrl: photoUrl ?? this.photoUrl,
      emotionTag: emotionTag ?? this.emotionTag,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      shareableLink: shareableLink ?? this.shareableLink,
      createdAt: createdAt ?? this.createdAt,
      replyCount: replyCount ?? this.replyCount,
      isRead: isRead ?? this.isRead,
    );
  }

  String get emotionTagName {
    switch (emotionTag) {
      case EmotionTag.joyful:
        return 'Joyful';
      case EmotionTag.melancholic:
        return 'Melancholic';
      case EmotionTag.nostalgic:
        return 'Nostalgic';
      case EmotionTag.hopeful:
        return 'Hopeful';
      case EmotionTag.romantic:
        return 'Romantic';
      case EmotionTag.bittersweet:
        return 'Bittersweet';
      case EmotionTag.peaceful:
        return 'Peaceful';
      case EmotionTag.energetic:
        return 'Energetic';
    }
  }

  String? get youtubeThumbnail {
    // Extract video ID and construct thumbnail URL
    final videoId = extractYouTubeVideoId(youtubeLink);
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return null;
  }

  static String? extractYouTubeVideoId(String url) {
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]+)'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }
}
