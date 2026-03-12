import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/cassette.dart';
import '../models/notification_model.dart';
import '../models/reply.dart';

final mockDataServiceProvider = Provider<MockDataService>((ref) {
  return MockDataService();
});

/// Mock data service for development and testing
/// Replace with real API calls once FastAPI backend is ready
class MockDataService {
  // Mock current user
  final User mockUser = User(
    id: 'user-1',
    name: 'Maya Johnson',
    email: 'maya@example.com',
    profilePhotoUrl: null,
    bio: 'Music lover and nostalgic soul 🎵',
    createdAt: DateTime.now().subtract(const Duration(days: 60)),
  );

  // Mock users
  final List<User> mockUsers = [
    User(
      id: 'user-2',
      name: 'Alex Rivera',
      email: 'alex@example.com',
      profilePhotoUrl: null,
      bio: 'Sending love through songs',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
    User(
      id: 'user-3',
      name: 'Jordan Lee',
      email: 'jordan@example.com',
      profilePhotoUrl: null,
      bio: null,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    User(
      id: 'user-4',
      name: 'Sam Taylor',
      email: 'sam@example.com',
      profilePhotoUrl: null,
      bio: 'Making memories with music',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  // Mock sent cassettes
  List<Cassette> getMockSentCassettes() {
    return [
      Cassette(
        id: 'cassette-sent-1',
        senderId: 'user-1',
        senderName: 'Maya Johnson',
        youtubeLink: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        letterText:
            'Hey! This song reminded me of our road trip last summer. Remember when we got lost and ended up singing at the top of our lungs? Miss those times. 🚗✨',
        photoUrl: null,
        emotionTag: EmotionTag.nostalgic,
        isAnonymous: false,
        shareableLink: 'https://digitalcassette.app/c/cassette-sent-1',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        replyCount: 1,
        isRead: true,
      ),
      Cassette(
        id: 'cassette-sent-2',
        senderId: 'user-1',
        senderName: 'Maya Johnson',
        youtubeLink: 'https://www.youtube.com/watch?v=QDYfEBY9NM4',
        letterText:
            'Happy birthday! You deserve all the joy in the world. Here\'s to another year of amazing memories together. Love you! 🎉💕',
        photoUrl: null,
        emotionTag: EmotionTag.romantic,
        isAnonymous: false,
        shareableLink: 'https://digitalcassette.app/c/cassette-sent-2',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        replyCount: 0,
        isRead: true,
      ),
      Cassette(
        id: 'cassette-sent-3',
        senderId: 'user-1',
        senderName: 'Maya Johnson',
        youtubeLink: 'https://youtu.be/hT_nvWreIhg',
        letterText:
            'I\'m sorry about yesterday. I shouldn\'t have said what I said. This song always helps me think clearly. Can we talk?',
        photoUrl: null,
        emotionTag: EmotionTag.bittersweet,
        isAnonymous: false,
        shareableLink: 'https://digitalcassette.app/c/cassette-sent-3',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        replyCount: 2,
        isRead: true,
      ),
    ];
  }

  // Mock received cassettes
  List<Cassette> getMockReceivedCassettes() {
    return [
      Cassette(
        id: 'cassette-received-1',
        senderId: 'user-2',
        senderName: 'Alex Rivera',
        youtubeLink: 'https://www.youtube.com/watch?v=JGwWNGJdvx8',
        letterText:
            'This song makes me think of you every single time. I miss the way we used to stay up all night talking about everything and nothing. Come visit soon? 💭',
        photoUrl: null,
        emotionTag: EmotionTag.melancholic,
        isAnonymous: false,
        shareableLink: 'https://digitalcassette.app/c/cassette-received-1',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        replyCount: 0,
        isRead: false,
      ),
      Cassette(
        id: 'cassette-received-2',
        senderId: 'user-3',
        senderName: 'Jordan Lee',
        youtubeLink: 'https://www.youtube.com/watch?v=CevxZvSJLk8',
        letterText:
            'You\'re the best friend anyone could ask for. Thanks for always being there. This one\'s for all our adventures together! 🌟',
        photoUrl: null,
        emotionTag: EmotionTag.joyful,
        isAnonymous: false,
        shareableLink: 'https://digitalcassette.app/c/cassette-received-2',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        replyCount: 1,
        isRead: true,
      ),
      Cassette(
        id: 'cassette-received-3',
        senderId: null,
        senderName: null,
        youtubeLink: 'https://youtu.be/fJ9rUzIMcZQ',
        letterText:
            'I saw this and thought of you. Sometimes the best things are said without names. Just know someone out there is thinking of you. ✨',
        photoUrl: null,
        emotionTag: EmotionTag.nostalgic,
        isAnonymous: true,
        shareableLink: 'https://digitalcassette.app/c/cassette-received-3',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        replyCount: 0,
        isRead: true,
      ),
    ];
  }

  // Mock saved cassettes
  List<Cassette> getMockSavedCassettes() {
    final received = getMockReceivedCassettes();
    return [received[1], received[2]]; // Some received cassettes saved
  }

  // Mock notifications
  List<NotificationModel> getMockNotifications() {
    return [
      NotificationModel(
        id: 'notif-1',
        userId: 'user-1',
        type: NotificationType.cassetteReceived,
        cassetteId: 'cassette-received-1',
        senderName: 'Alex Rivera',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NotificationModel(
        id: 'notif-2',
        userId: 'user-1',
        type: NotificationType.replyReceived,
        cassetteId: 'cassette-sent-1',
        senderName: 'Sam Taylor',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      NotificationModel(
        id: 'notif-3',
        userId: 'user-1',
        type: NotificationType.cassetteSaved,
        cassetteId: 'cassette-sent-2',
        senderName: 'Jordan Lee',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'notif-4',
        userId: 'user-1',
        type: NotificationType.replyReceived,
        cassetteId: 'cassette-sent-3',
        senderName: 'Alex Rivera',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  // Mock replies
  List<Reply> getMockReplies(String cassetteId) {
    if (cassetteId == 'cassette-sent-1') {
      return [
        Reply(
          id: 'reply-1',
          cassetteId: cassetteId,
          senderId: 'user-4',
          senderName: 'Sam Taylor',
          youtubeLink: 'https://www.youtube.com/watch?v=ZbZSe6N_BXs',
          replyText:
              'Oh my god, YES! That was the best day. This song takes me right back! We need to do it again soon! 🎶',
          photoUrl: null,
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ];
    } else if (cassetteId == 'cassette-sent-3') {
      return [
        Reply(
          id: 'reply-2',
          cassetteId: cassetteId,
          senderId: 'user-2',
          senderName: 'Alex Rivera',
          youtubeLink: 'https://www.youtube.com/watch?v=nfWlot6h_JM',
          replyText:
              'Hey, it\'s all good. I appreciate you reaching out. Let\'s grab coffee tomorrow?',
          photoUrl: null,
          createdAt: DateTime.now().subtract(const Duration(hours: 10)),
        ),
        Reply(
          id: 'reply-3',
          cassetteId: cassetteId,
          senderId: 'user-1',
          senderName: 'Maya Johnson',
          youtubeLink: 'https://www.youtube.com/watch?v=450p7goxZqg',
          replyText:
              'Absolutely! Thank you for understanding. See you tomorrow. ☕️',
          photoUrl: null,
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
      ];
    } else if (cassetteId == 'cassette-received-2') {
      return [
        Reply(
          id: 'reply-4',
          cassetteId: cassetteId,
          senderId: 'user-1',
          senderName: 'Maya Johnson',
          youtubeLink: 'https://www.youtube.com/watch?v=OPf0YbXqDm0',
          replyText:
              'You\'re amazing! Thank you for always being you. This is our anthem! 🙌',
          photoUrl: null,
          createdAt: DateTime.now().subtract(const Duration(hours: 20)),
        ),
      ];
    }
    return [];
  }

  // Mock cassette by ID
  Cassette? getMockCassetteById(String id) {
    final allCassettes = [
      ...getMockSentCassettes(),
      ...getMockReceivedCassettes(),
    ];
    try {
      return allCassettes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Mock auth
  Future<Map<String, dynamic>> mockLogin(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email == mockUser.email && password == 'password123') {
      return {
        'success': true,
        'token': 'mock_jwt_token_12345',
        'user': mockUser.toJson(),
      };
    }
    throw Exception('Invalid credentials');
  }

  Future<Map<String, dynamic>> mockSignup(
    String name,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final newUser = User(
      id: 'user-new-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );

    return {
      'success': true,
      'token': 'mock_jwt_token_67890',
      'user': newUser.toJson(),
    };
  }
}
