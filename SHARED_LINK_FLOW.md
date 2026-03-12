# Shared Link Flow Documentation

## Overview
The shared link flow allows users to share cassettes publicly via unique shareable links. Recipients can unlock and experience cassettes without authentication, with optional login for save/reply actions.

## Architecture

### Data Model
**File**: `lib/features/unlock/domain/models/shared_cassette_model.dart`

The `SharedCassetteModel` contains all cassette data needed for the unlock/experience flow:

```dart
class SharedCassetteModel {
  final String id;
  final String shareCode;          // 6-8 char alphanumeric
  final String shareUrl;            // https://digitalcassette.app/unlock/{code}
  final String title;
  final String youtubeVideoId;
  final String letterText;
  final String? photoUrl;
  final String emotionTag;
  final String emotionEmoji;
  final String senderName;
  final bool senderIsAnonymous;
  final String password;            // Unlock password
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool isActive;
  final bool isDeleted;
  final int unlockCount;
  final int? maxUnlocks;
}
```

**Key Methods**:
- `isExpired`: Checks if cassette has passed expiration date
- `canUnlock`: Validates if cassette can be unlocked (active, not deleted, not expired, under max unlocks)
- `displaySenderName`: Returns sender name or "Someone Special" if anonymous

### Service Layer
**File**: `lib/features/unlock/domain/services/cassette_share_service.dart`

The `CassetteShareService` handles all business logic for sharing:

**Core Methods**:
- `generateShareCode()`: Creates unique 6-character alphanumeric code (avoids confusing chars: 0, O, I, 1)
- `generateShareUrl(code)`: Builds full share URL
- `getCassetteByShareCode(code)`: Fetches cassette data
- `validatePassword(id, password)`: Verifies unlock password
- `incrementUnlockCount(id)`: Tracks unlock attempts
- `saveCassetteToLibrary(id, userId)`: Saves cassette to user's library (requires auth)
- `validateCassette(cassette)`: Returns validation result

**Validation Results**:
```dart
enum CassetteValidationResult {
  valid,
  deleted,
  inactive,
  expired,
  maxUnlocksReached,
  notFound
}
```

Each result includes `errorTitle` and `errorMessage` for display.

**Current State**: Mock implementation with 800ms delay and sample data. Ready for API integration.

### State Management
**File**: `lib/features/unlock/domain/providers/shared_cassette_provider.dart`

The `SharedCassetteProvider` manages cassette unlock state:

**State Properties**:
```dart
class SharedCassetteState {
  final bool isLoading;
  final SharedCassetteModel? cassette;
  final String? errorMessage;
  final CassetteValidationResult? validationResult;
  final bool isUnlocked;
  final int failedAttempts;
}
```

**Key Methods**:
- `loadCassette(shareCode)`: Fetches and validates cassette
- `unlockCassette(password)`: Validates password, tracks attempts
- `saveCassette(userId)`: Saves to library (requires auth)
- `reset()`: Clears state

### Error Handling
**File**: `lib/features/unlock/presentation/screens/cassette_error_screen.dart`

Reusable error screen with factory constructors for each error type:

**Error Screen Variants**:
1. **notFound()**: Invalid or non-existent share code
2. **deleted()**: Cassette removed by sender
3. **expired()**: Past expiration date
4. **maxUnlocksReached()**: Hit unlock limit
5. **wrongPassword(attemptsRemaining)**: Shows remaining attempts (dynamic)
6. **tooManyAttempts()**: 30-minute lockout after 5 failed attempts

**Design**: Consistent UX with icon, title, message, CTA button, optional back button.

## User Flow

### 1. Receive Link
User receives link: `https://digitalcassette.app/unlock/ABC123`

**App Installed**: Deep link opens app directly to unlock screen  
**App Not Installed**: Web page with fallback (download prompts + web player)

### 2. Unlock Screen
**File**: `lib/features/unlock/presentation/screens/unlock_screen.dart`

**Flow**:
1. Auto-loads cassette via `sharedCassetteProvider.loadCassette(cassetteId)`
2. Shows loading state: spinner + "Loading cassette..."
3. Validates cassette: routes to appropriate error screen if invalid
4. Displays unlock form:
   - Emotional header: "{sender} sent you a memory"
   - Emotion tag and emoji
   - Password input (autofocus, toggle visibility)
   - Unlock button

**Password Attempts**:
- Max 5 attempts per session
- Shows "X attempts remaining" after failures
- Clears input on failure
- Toast message: "Incorrect password. X attempts remaining"
- After 5 failures: Routes to `CassetteErrorScreen.tooManyAttempts()`

**Success**: Navigates to `/cassette/{id}` (experience screen)

**Design**: Dark background (`AppColors.deepBrown`), white text, golden accent borders

### 3. Experience Screen
**File**: `lib/features/unlock/presentation/screens/cassette_experience_screen.dart`

**Layout**:
- Header: Back button + Save bookmark icon
- Cassette visual: Gradient box with emotion emoji, title, emotion tag
- "Play Song on YouTube" button (TODO: open YouTube player)
- Sender info: "From: {name}"
- Letter: Handwritten font on paper background
- Photo: If attached
- Reply button: "💬 Reply with a Cassette"
- CTA: "Create your own cassette →"

**Auth-Gated Actions**:

**Save to Library**:
- Logged in: Saves via `sharedCassetteProvider.saveCassette(userId)`
- Not logged in: Shows `LoginPromptModal` with "Save this Memory" title
- Success: Bookmark icon fills, shows toast "Saved to your library"

**Reply**:
- Logged in: Navigates to `/reply/{cassetteId}`
- Not logged in: Shows `LoginPromptModal` with "Reply to this Cassette" title
- On login: Continues to reply flow

### 4. Login Prompt Modal
**File**: `lib/features/unlock/presentation/widgets/login_prompt_modal.dart`

Bottom sheet with:
- Drag handle
- Icon (person outline in golden circle)
- Title (e.g., "Save this Memory")
- Message (warm emotional copy)
- Buttons:
  - "Sign Up" (primary)
  - "Log In" (outline)
  - "Maybe Later" (text button)

Returns `true` if user wants to login, `false` if cancelled.

## Route Configuration

**Public Routes** (no auth required):
- `/unlock/:id` → UnlockScreen
- `/cassette/:id` → CassetteExperienceScreen

Both routes accessible when logged out. Auth-gated actions prompt login.

## Deep Linking Setup

### Android Configuration
**File**: `android/app/src/main/AndroidManifest.xml`

Add intent filters for App Links:
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="digitalcassette.app"
        android:pathPrefix="/unlock" />
</intent-filter>
```

**Asset Links**: Host `assetlinks.json` at `https://digitalcassette.app/.well-known/assetlinks.json`

### iOS Configuration
**File**: `ios/Runner/Info.plist`

Add associated domains:
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:digitalcassette.app</string>
</array>
```

**File**: `ios/Runner/AppDelegate.swift`

Handle universal links in AppDelegate.

**Apple App Site Association**: Host `apple-app-site-association` at `https://digitalcassette.app/.well-known/apple-app-site-association`

### Web Fallback
**File**: `web/unlock/[code]/index.html` (or Firebase Dynamic Link)

Fallback page when app not installed:
- Show cassette preview (sender, emotion, message teaser)
- App store download buttons (iOS/Android)
- "Open in Web" option (optional web player)
- Social meta tags for link previews

## Error Scenarios

| Scenario | Detection | User Experience |
|----------|-----------|-----------------|
| Invalid share code | `getCassetteByShareCode` returns null | Error screen: "Cassette Not Found" |
| Deleted cassette | `cassette.isDeleted == true` | Error screen: "Cassette Removed" |
| Expired cassette | `cassette.isExpired == true` | Error screen: "Cassette Expired" |
| Inactive cassette | `cassette.isActive == false` | Error screen: "Cassette Not Available" |
| Max unlocks reached | `unlockCount >= maxUnlocks` | Error screen: "Unlock Limit Reached" |
| Wrong password (1-4 tries) | Password validation fails | Toast + attempts remaining |
| Wrong password (5 tries) | `failedAttempts >= 5` | Error screen: "Too Many Attempts" (30-min lockout) |
| Save when not logged in | Check `authProvider.isAuthenticated` | Login prompt modal |
| Reply when not logged in | Check `authProvider.isAuthenticated` | Login prompt modal |

## Testing Checklist

### Happy Path
- [ ] Receive link, app opens to unlock screen
- [ ] Enter correct password, view cassette experience
- [ ] Play YouTube song
- [ ] Save cassette (logged in)
- [ ] Reply to cassette (logged in)
- [ ] Create own cassette

### Error Paths
- [ ] Invalid share code → Error screen
- [ ] Deleted cassette → Error screen
- [ ] Expired cassette → Error screen
- [ ] Max unlocks reached → Error screen
- [ ] Wrong password (1 attempt) → Toast with 4 remaining
- [ ] Wrong password (3 attempts) → Toast with 2 remaining
- [ ] Wrong password (5 attempts) → Error screen
- [ ] Save when logged out → Login prompt
- [ ] Reply when logged out → Login prompt
- [ ] Cancel login prompt → Returns to experience

### Deep Linking
- [ ] Android: Link opens app (installed)
- [ ] Android: Link opens web (not installed)
- [ ] iOS: Link opens app (installed)
- [ ] iOS: Link opens web (not installed)
- [ ] Web: Fallback page shows download buttons

## API Integration

Replace mock implementations in `CassetteShareService`:

```dart
// Replace this:
Future<SharedCassetteModel?> getCassetteByShareCode(String shareCode) async {
  await Future.delayed(const Duration(milliseconds: 800));
  // Mock data...
}

// With real API call:
Future<SharedCassetteModel?> getCassetteByShareCode(String shareCode) async {
  try {
    final response = await _dio.get('/api/cassettes/share/$shareCode');
    if (response.statusCode == 200) {
      return SharedCassetteModel.fromJson(response.data);
    }
    return null;
  } catch (e) {
    return null;
  }
}
```

**Endpoints Needed**:
- `GET /api/cassettes/share/{code}` - Fetch cassette by share code
- `POST /api/cassettes/{id}/validate-password` - Validate unlock password
- `POST /api/cassettes/{id}/increment-unlock` - Track unlock count
- `POST /api/cassettes/{id}/save` - Save to user library (requires auth)

## Next Steps

### Immediate (Required for Production)
1. **YouTube Player Integration**: Add `youtube_player_flutter` package, implement player in experience screen
2. **Deep Link Configuration**: Complete Android/iOS setup with asset files
3. **Web Fallback Page**: Build fallback experience for app-not-installed scenario
4. **API Integration**: Replace all mock services with real API calls

### Future Enhancements
1. **QR Codes**: Generate QR code for share link (on create success)
2. **Share Analytics**: Track unlock count, unique viewers, geographic data
3. **Social Previews**: Rich meta tags for beautiful link previews on social platforms
4. **Expiration Warning**: Show countdown timer if cassette expires soon
5. **Reply Chains**: Visual thread showing reply history
6. **Unlock History**: Show "X people unlocked this" counter
7. **Password Hints**: Optional sender-provided hint after 2 failed attempts

## UX Copy Guidelines

**Tone**: Warm, emotional, simple, nostalgic

**Examples**:
- ✅ "{Sender} sent you a memory"
- ✅ "Create an account to save this cassette to your library"
- ✅ "Someone special shared this with you"
- ❌ "Authentication required"
- ❌ "Invalid credentials"
- ❌ "Error: Cassette not found"

**Principles**:
1. Use sender name when available (not anonymous)
2. Emphasize memory/emotion over technical actions
3. Soft calls-to-action ("Maybe Later" not "Cancel")
4. Explain why login is valuable, not just that it's required
5. Show empathy in error messages ("removed by sender" not "deleted")
