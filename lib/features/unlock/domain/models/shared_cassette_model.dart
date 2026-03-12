class SharedCassetteModel {
  final String id;
  final String shareCode; // Unique 6-8 character code (e.g., "AX34DF")
  final String shareUrl; // Full shareable URL
  final String title;
  final String youtubeVideoId;
  final String letterText;
  final String? photoUrl;
  final String emotionTag;
  final String emotionEmoji;
  final String senderName;
  final bool senderIsAnonymous;
  final String password;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isDeleted;
  final int unlockCount;
  final int maxUnlocks; // 0 = unlimited

  SharedCassetteModel({
    required this.id,
    required this.shareCode,
    required this.shareUrl,
    required this.title,
    required this.youtubeVideoId,
    required this.letterText,
    this.photoUrl,
    required this.emotionTag,
    required this.emotionEmoji,
    required this.senderName,
    required this.senderIsAnonymous,
    required this.password,
    required this.createdAt,
    this.expiresAt,
    required this.isActive,
    required this.isDeleted,
    required this.unlockCount,
    required this.maxUnlocks,
  });

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool get canUnlock =>
      isActive &&
      !isDeleted &&
      !isExpired &&
      (maxUnlocks == 0 || unlockCount < maxUnlocks);

  String get displaySenderName => senderIsAnonymous ? 'Someone' : senderName;

  SharedCassetteModel copyWith({
    String? id,
    String? shareCode,
    String? shareUrl,
    String? title,
    String? youtubeVideoId,
    String? letterText,
    String? photoUrl,
    String? emotionTag,
    String? emotionEmoji,
    String? senderName,
    bool? senderIsAnonymous,
    String? password,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
    bool? isDeleted,
    int? unlockCount,
    int? maxUnlocks,
  }) {
    return SharedCassetteModel(
      id: id ?? this.id,
      shareCode: shareCode ?? this.shareCode,
      shareUrl: shareUrl ?? this.shareUrl,
      title: title ?? this.title,
      youtubeVideoId: youtubeVideoId ?? this.youtubeVideoId,
      letterText: letterText ?? this.letterText,
      photoUrl: photoUrl ?? this.photoUrl,
      emotionTag: emotionTag ?? this.emotionTag,
      emotionEmoji: emotionEmoji ?? this.emotionEmoji,
      senderName: senderName ?? this.senderName,
      senderIsAnonymous: senderIsAnonymous ?? this.senderIsAnonymous,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      unlockCount: unlockCount ?? this.unlockCount,
      maxUnlocks: maxUnlocks ?? this.maxUnlocks,
    );
  }

  factory SharedCassetteModel.fromJson(Map<String, dynamic> json) {
    return SharedCassetteModel(
      id: json['id'] as String,
      shareCode: json['shareCode'] as String,
      shareUrl: json['shareUrl'] as String,
      title: json['title'] as String,
      youtubeVideoId: json['youtubeVideoId'] as String,
      letterText: json['letterText'] as String,
      photoUrl: json['photoUrl'] as String?,
      emotionTag: json['emotionTag'] as String,
      emotionEmoji: json['emotionEmoji'] as String,
      senderName: json['senderName'] as String,
      senderIsAnonymous: json['senderIsAnonymous'] as bool,
      password: json['password'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool,
      unlockCount: json['unlockCount'] as int,
      maxUnlocks: json['maxUnlocks'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shareCode': shareCode,
      'shareUrl': shareUrl,
      'title': title,
      'youtubeVideoId': youtubeVideoId,
      'letterText': letterText,
      'photoUrl': photoUrl,
      'emotionTag': emotionTag,
      'emotionEmoji': emotionEmoji,
      'senderName': senderName,
      'senderIsAnonymous': senderIsAnonymous,
      'password': password,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'isDeleted': isDeleted,
      'unlockCount': unlockCount,
      'maxUnlocks': maxUnlocks,
    };
  }
}
