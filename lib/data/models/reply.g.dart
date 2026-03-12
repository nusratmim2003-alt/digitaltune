// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reply _$ReplyFromJson(Map<String, dynamic> json) => Reply(
      id: json['id'] as String,
      cassetteId: json['cassetteId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      youtubeLink: json['youtubeLink'] as String,
      replyText: json['replyText'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'id': instance.id,
      'cassetteId': instance.cassetteId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'youtubeLink': instance.youtubeLink,
      'replyText': instance.replyText,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
    };
