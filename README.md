# 📼 Digital Cassette

**Send songs like handwritten letters.** Digital Cassette is a nostalgic mobile app where users share YouTube music with personal letters and optional photos in password-protected experiences.

## ✨ Features

### Core Functionality
- 🎵 **YouTube Integration**: Share music videos with personal messages
- ✍️ **Handwritten Letters**: Express yourself with styled text in a handwritten aesthetic
- 📸 **Photos**: Add optional images to your cassettes
- 🔒 **Password Protection**: Secure each cassette with a custom password
- 🎭 **Anonymous Mode**: Send cassettes without revealing your identity
- 🏷️ **Emotion Tags**: Categorize cassettes (Love, Nostalgia, Friendship, Missing You, Apology)

### User Flows
- **Authentication**: Welcome, Login, Sign Up, Password Reset, Profile Setup
- **Home Dashboard**: View sent, received, and saved cassettes
- **Create Cassette**: 6-step wizard (YouTube → Letter → Photo → Emotion → Password → Preview)
- **Unlock Experience**: Password entry with animated reveal
- **Memory Library**: Search, filter, and organize cassettes by emotion
- **Reply Flow**: Respond to cassettes with your own song and message
- **Notifications**: Track new cassettes and replies
- **Profile & Settings**: Manage account, privacy, and app preferences

## 🛠️ Tech Stack

### Framework & Core
- **Flutter 3.x**: Cross-platform mobile framework
- **Dart 3.x**: Programming language

### State Management & Navigation
- **Riverpod 2.4.0**: State management with Provider pattern
- **go_router 12.0.0**: Declarative routing with deep linking

### Data & Networking
- **Dio 5.3.0**: HTTP client for API calls
- **json_serializable + freezed**: JSON serialization
- **shared_preferences**: Local data storage
- **flutter_secure_storage**: Secure token storage

### UI & Media
- **Material 3**: Design system
- **cached_network_image**: Image caching
- **image_picker**: Camera/gallery access
- **youtube_player_flutter**: YouTube video playback

## 📁 Project Structure

```
lib/
├── app/
│   ├── app.dart                 # MaterialApp configuration
│   └── router.dart              # go_router navigation setup
├── core/
│   ├── theme/                   # Design system (colors, typography, spacing)
│   └── widgets/                 # Reusable widgets (buttons, cards, state widgets)
├── data/
│   ├── models/                  # Data models (User, Cassette, Reply, Notification)
│   └── services/                # API, Storage, and Mock data services
└── features/
    ├── auth/                    # Authentication screens
    ├── home/                    # Home dashboard
    ├── create_cassette/         # Create cassette flow
    ├── unlock/                  # Unlock & experience screens
    ├── library/                 # Memory library & detail
    ├── reply/                   # Reply flow
    ├── notifications/           # Notifications screen
    └── profile/                 # Profile & settings screens
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK 3.x or higher
- Dart 3.x or higher
- Android Studio / Xcode (for emulators)

### Installation

1. **Clone the repository**
   ```bash
   cd e:\flutterproject\digitalcassettee
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Demo Credentials
For testing, use these demo credentials on the login screen:

- **Email**: `maya@example.com`
- **Password**: `password123`

## 🎨 Design System

### Color Palette
- **Paper Tone**: `#F5EFE6` - Warm, nostalgic background
- **Deep Brown**: `#3E2723` - Primary text color
- **Amber Accent**: `#FF6F00` - Interactive elements and CTAs
- **Cream**: `#FFF8E1` - Cards and containers

### Typography
- **Headings**: Merriweather (serif) - Classic, timeless feel
- **Handwritten**: Patrick Hand - Personal letter aesthetic
- **Body**: System fonts (Roboto/SF Pro) - Readable interface text

### Spacing
- Base unit: **4px**
- Scale: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64px

## 🔌 Backend Integration

The app is ready for FastAPI backend integration. The `ApiService` class (`lib/data/services/api_service.dart`) defines all required endpoints:

### Auth Endpoints
- `POST /auth/signup`: User registration
- `POST /auth/login`: User login
- `POST /auth/forgot-password`: Password reset
- `POST /auth/logout`: User logout

### Cassette Endpoints
- `POST /cassettes`: Create a new cassette
- `GET /cassettes/{id}`: Get cassette by ID
- `POST /cassettes/{id}/unlock`: Unlock cassette with password
- `GET /cassettes/sent`: Get sent cassettes
- `GET /cassettes/inbox`: Get received cassettes

### Library Endpoints
- `GET /library/saved`: Get saved cassettes
- `POST /library/save/{cassetteId}`: Save a cassette
- `DELETE /library/save/{cassetteId}`: Unsave a cassette

### Reply Endpoints
- `POST /cassettes/{id}/reply`: Create a reply
- `GET /cassettes/{id}/replies`: Get conversation thread

### Notification Endpoints
- `GET /notifications`: Get user notifications
- `PUT /notifications/{id}/read`: Mark notification as read

### Profile Endpoints
- `GET /profile/me`: Get current user profile
- `PUT /profile/me`: Update profile
- `POST /upload/photo`: Upload photo

### Mock Data
Currently, the app uses `MockDataService` for development without a backend. Switch to live API by:

1. Update `API_BASE_URL` in `api_service.dart`
2. Replace mock service calls with API service calls
3. Handle real authentication tokens

## 📝 Development Notes

### Code Generation
After modifying any model files with JSON serialization annotations, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Adding a New Feature
1. Create feature folder under `lib/features/`
2. Add screens in `presentation/screens/`
3. Register routes in `lib/app/router.dart`
4. Create state providers if needed

### Assets & Fonts
To add custom fonts:
1. Place font files in `assets/fonts/`
2. Update `pubspec.yaml`:
   ```yaml
   fonts:
     - family: Merriweather
       fonts:
         - asset: assets/fonts/Merriweather-Regular.ttf
   ```
3. Update `lib/core/theme/app_typography.dart`

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Widget Testing
```bash
flutter test test/widget_test.dart
```

## 🐛 Known Issues & TODOs

- [ ] Generate JSON serialization files (`.g.dart`)
- [ ] Add actual font files or update to system fonts
- [ ] Implement image picker functionality
- [ ] Add Lottie animations for unlock experience
- [ ] Connect to live FastAPI backend
- [ ] Add unit tests for services and models
- [ ] Add widget tests for key user flows
- [ ] Implement deep link handling for shared cassettes
- [ ] Add offline support with local database
- [ ] Implement push notifications

## 📱 Screens

### Authentication
1. Welcome Screen
2. Login Screen
3. Sign Up Screen
4. Forgot Password Screen
5. Profile Setup Screen

### Main App
6. Home Dashboard
7. Create Cassette Flow (6 steps)
8. Unlock Screen
9. Cassette Experience Screen
10. Library Screen (with tabs)
11. Memory Detail Screen
12. Reply Flow (3 steps)
13. Notifications Screen
14. Profile Screen
15. Settings Screen

## 🤝 Contributing

This is a Flutter project following clean architecture principles:
- **Feature-first organization**: Each feature is self-contained
- **Provider pattern**: Riverpod for dependency injection
- **Separation of concerns**: Data, domain, and presentation layers
- **Reusable components**: Shared widgets in `core/widgets/`

## 📄 License

© 2024 Digital Cassette. All rights reserved.

## 📧 Support

For questions or issues, contact the development team.

---

**Built with ❤️ using Flutter**
