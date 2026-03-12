// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cassette.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cassette _$CassetteFromJson(Map<String, dynamic> json) => Cassette(
      id: json['id'] as String,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      youtubeLink: json['youtubeLink'] as String,
      letterText: json['letterText'] as String,
      photoUrl: json['photoUrl'] as String?,
      emotionTag: $enumDecode(_$EmotionTagEnumMap, json['emotionTag']),
      isAnonymous: json['isAnonymous'] as bool,
      shareableLink: json['shareableLink'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      replyCount: (json['replyCount'] as num?)?.toInt() ?? 0,
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$CassetteToJson(Cassette instance) => <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'youtubeLink': instance.youtubeLink,
      'letterText': instance.letterText,
      'photoUrl': instance.photoUrl,
      'emotionTag': _$EmotionTagEnumMap[instance.emotionTag]!,
      'isAnonymous': instance.isAnonymous,
      'shareableLink': instance.shareableLink,
      'createdAt': instance.createdAt.toIso8601String(),
      'replyCount': instance.replyCount,
      'isRead': instance.isRead,
    };

const _$EmotionTagEnumMap = {
  EmotionTag.joyful: 'joyful',
  EmotionTag.melancholic: 'melancholic',
  EmotionTag.nostalgic: 'nostalgic',
  EmotionTag.hopeful: 'hopeful',
  EmotionTag.romantic: 'romantic',
  EmotionTag.bittersweet: 'bittersweet',
  EmotionTag.peaceful: 'peaceful',
  EmotionTag.energetic: 'energetic',
};
