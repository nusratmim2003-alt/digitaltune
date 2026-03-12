import 'package:json_annotation/json_annotation.dart';
import 'cassette.dart';

part 'reply.g.dart';

@JsonSerializable()
class Reply {
  final String id;
  final String cassetteId;
  final String senderId;
  final String senderName;
  final String youtubeLink;
  final String replyText;
  final String? photoUrl;
  final DateTime createdAt;

  const Reply({
    required this.id,
    required this.cassetteId,
    required this.senderId,
    required this.senderName,
    required this.youtubeLink,
    required this.replyText,
    this.photoUrl,
    required this.createdAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => _$ReplyFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyToJson(this);

  Reply copyWith({
    String? id,
    String? cassetteId,
    String? senderId,
    String? senderName,
    String? youtubeLink,
    String? replyText,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return Reply(
      id: id ?? this.id,
      cassetteId: cassetteId ?? this.cassetteId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      replyText: replyText ?? this.replyText,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String? get youtubeThumbnail {
    final videoId = Cassette.extractYouTubeVideoId(youtubeLink);
    if (videoId != null) {
      return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
    }
    return null;
  }
}
