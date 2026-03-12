import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

enum NotificationType { cassetteReceived, replyReceived, cassetteSaved }

@JsonSerializable()
class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String cassetteId;
  final String? senderName;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.cassetteId,
    this.senderName,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? cassetteId,
    String? senderName,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      cassetteId: cassetteId ?? this.cassetteId,
      senderName: senderName ?? this.senderName,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get title {
    switch (type) {
      case NotificationType.cassetteReceived:
        return '${senderName ?? "Someone"} sent you a cassette';
      case NotificationType.replyReceived:
        return '${senderName ?? "Someone"} replied to your cassette';
      case NotificationType.cassetteSaved:
        return '${senderName ?? "Someone"} saved your cassette';
    }
  }

  String get icon {
    switch (type) {
      case NotificationType.cassetteReceived:
        return '📼';
      case NotificationType.replyReceived:
        return '🎵';
      case NotificationType.cassetteSaved:
        return '❤️';
    }
  }
}
