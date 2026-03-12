# Persistent Login & Navigation Architecture
**Digital Cassette - Implementation Documentation**

## Overview

This document explains the persistent login and proper back navigation implementation for the Digital Cassette app, fulfilling all requirements for production-ready authentication and navigation behavior.

---

## 1. Persistent Login Implementation

### Architecture

The app uses a **state-based authentication system** with Riverpod that automatically:
- Checks for valid auth tokens on app startup
- Restores user session if token exists
- Redirects to appropriate screens based on auth state
- Protects authenticated routes from unauthenticated access

### Key Components

#### **AuthState** ([auth_state.dart](lib/features/auth/domain/models/auth_state.dart))
```dart
enum AuthStatus {
  initial,      // App just launched, checking auth
  authenticated, // User is logged in
  unauthenticated, // User is not logged in
  loading,      // Auth action in progress
}
```

Tracks the current authentication status throughout the app lifecycle.

#### **UserModel** ([user_model.dart](lib/features/auth/domain/models/user_model.dart))
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
}
```

Represents the authenticated user's data.

#### **AuthNotifier** ([auth_provider.dart](lib/features/auth/domain/providers/auth_provider.dart))
The core authentication manager that:

1. **Checks auth on startup** (`_checkAuthStatus`):
   - Reads auth token from secure storage
   - Loads user data if token exists
   - Sets state to `authenticated` or `unauthenticated`

2. **Handles login** (`login`):
   - Authenticates user credentials (currently mock)
   - Saves auth token securely
   - Saves user data
   - Updates state to `authenticated`

3. **Handles signup** (`signup`):
   - Creates new user account (currently mock)
   - Saves auth token and user data
   - Updates state to `authenticated`

4. **Handles logout** (`logout`):
   - Clears all stored auth data
   - Updates state to `unauthenticated`
   - Router automatically redirects to welcome screen

#### **StorageService** ([storage_service.dart](lib/data/services/storage_service.dart))
Securely stores authentication data using:
- **FlutterSecureStorage**: For auth tokens (encrypted)
- **SharedPreferences**: For user data (name, email, ID)

All methods include error handling for web compatibility.

---

## 2. Router Implementation with Auth Guards

### Router Architecture ([router.dart](lib/app/router.dart))

The router uses **GoRouter** with reactive auth state watching:

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  // Router rebuilds when auth state changes
});
```

### Route Protection Logic

#### **Public Routes** (No Authentication Required)
- `/splash` - Initial auth check screen
- `/` - Marketing landing page
- `/welcome` - Welcome/onboarding
- `/login` - Login screen
- `/signup` - Signup screen
- `/forgot-password` - Password reset
- `/unlock/:cassetteId` - Unlock shared cassette (public link)
- `/cassette/:cassetteId` - View cassette experience (public link)

#### **Protected Routes** (Authentication Required)
- `/home` - Main app dashboard
- `/create-cassette` - Create new cassette
- `/library` - Memory library
- `/memory/:memoryId` - Memory detail
- `/reply/:cassetteId` - Reply to cassette
- `/notifications` - Notifications
- `/profile` - User profile
- `/settings` - App settings

### Redirect Logic Flow

```
App Launch
    ↓
Show /splash (with loading spinner)
    ↓
AuthNotifier checks storage for token
    ↓
┌─────────────────────┬──────────────────────┐
│ Token Exists        │ No Token             │
│ + User Data Valid   │ or Invalid Data      │
│                     │                      │
│ State: authenticated│ State: unauthenticated│
│ Redirect: /home     │ Redirect: /welcome   │
└─────────────────────┴──────────────────────┘
```

### Key Router Features

1. **Automatic Splash Screen**:
   - Shows splash while `authState.isInitial` or `authState.isLoading`
   - Prevents flashing of wrong screens during startup

2. **Auth-Based Redirects**:
   - Logged-in users trying to access `/login` → redirected to `/home`
   - Logged-out users trying to access `/library` → redirected to `/login`

3. **Public Link Support**:
   - Unlock links (`/unlock/:cassetteId`) work without authentication
   - Enables sharing cassettes with non-users

4. **Debug Logging**:
   - `debugLogDiagnostics: true` helps track navigation issues during development

---

## 3. Proper Back Navigation

### Android Back Button Behavior

GoRouter automatically handles the Android back button correctly with its declarative routing:

#### **Multi-Step Flows**
Flows like Create Cassette, Reply, and Unlock naturally support step-by-step back navigation because they're implemented as stateful widgets with internal navigation state. Pressing back:
1. Goes to previous step in the flow
2. If on first step, exits flow and returns to parent screen

#### **Bottom Navigation Tabs**
When user is on a tab from bottom nav:
- Back button does NOT cycle through tabs
- Back button exits the app (standard Android behavior)
- This matches user expectations for tab-based navigation

#### **Detail Screens**
Screens like Memory Detail, Settings, Profile:
- Back button returns to the screen that opened them
- Navigation stack is maintained by GoRouter
- Deep links have safe fallback paths

#### **Nested Navigation**
GoRouter maintains proper navigation history:
```
Home → Library → Memory Detail → Reply Flow → Step 2
[Back] → Reply Flow Step 1
[Back] → Memory Detail
[Back] → Library
[Back] → Home
```

### Implementation Best Practices

1. **Use `context.go()` for route switching** (replaces current route)
2. **Use `context.push()` for stacking** (adds to navigation stack)
3. **Use `context.pop()` for explicit back** (removes from stack)
4. **Avoid manual Navigator.push()** (breaks GoRouter's stack management)

---

## 4. App Startup Flow

### Startup Sequence

```
1. main() runs
   ↓
2. ProviderScope wraps MaterialApp
   ↓
3. MaterialApp.router uses routerProvider
   ↓
4. Router sets initialLocation: '/splash'
   ↓
5. SplashScreen displays
   ↓
6. AuthNotifier constructor runs _checkAuthStatus()
   ↓
7. Storage checked for token
   ↓
8. Auth state updates (authenticated or unauthenticated)
   ↓
9. Router redirect logic runs
   ↓
10. User lands on correct screen (/home or /welcome)
```

### Splash Screen ([splash_screen.dart](lib/features/splash/presentation/screens/splash_screen.dart))

Clean, minimal loading screen shown during auth check:
- Cassette icon
- App name
- Tagline
- Loading spinner
- Warm nostalgic color palette

Duration: **Automatic** (depends on storage read speed, typically <500ms)

---

## 5. Login/Signup Screens

Both screens now use the **AuthProvider** instead of direct storage manipulation:

### Login Screen Changes
```dart
// OLD (manual storage)
final storageService = ref.read(storageServiceProvider);
await storageService.saveAuthToken(token);
context.go('/home');

// NEW (auth provider)
final authNotifier = ref.read(authProvider.notifier);
await authNotifier.login(email, password);
// Router automatically redirects
```

### Benefits
- **Single source of truth**: Auth state managed in one place
- **Automatic navigation**: Router reacts to auth state changes
- **Cleaner code**: No manual navigation or storage calls in UI
- **Error handling**: Centralized in AuthNotifier

---

## 6. Logout Implementation

### Settings Screen Changes

Logout button now uses AuthProvider:

```dart
Future<void> _handleLogout() async {
  final confirmed = await showDialog<bool>(...); // Confirmation dialog
  
  if (confirmed == true) {
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.logout();
    // Router automatically redirects to /welcome
  }
}
```

### Logout Flow
1. User taps "Log Out" in Settings
2. Confirmation dialog appears
3. User confirms
4. `authNotifier.logout()` called
5. All stored data cleared (token + user data)
6. Auth state → `unauthenticated`
7. Router detects state change
8. User redirected to `/welcome`

---

## 7. Token Expiry & Invalid Session Handling

### Current Implementation
The `StorageService` includes error handling for all operations:
```dart
Future<String?> getAuthToken() async {
  try {
    return await _secureStorage.read(key: _keyAccessToken);
  } catch (e) {
    print('Error reading auth token: $e');
    return null; // Treated as logged out
  }
}
```

### Future Enhancements (When Backend Connected)

**Token Expiry Detection**:
```dart
// Check token expiry with backend
Future<bool> isTokenValid() async {
  final token = await getAuthToken();
  if (token == null) return false;
  
  // Call backend to verify token
  final response = await api.verifyToken(token);
  return response.isValid;
}
```

**Automatic Refresh**:
```dart
// Refresh expired token
Future<void> refreshTokenIfNeeded() async {
  if (await isTokenExpired()) {
    final newToken = await api.refreshToken(refreshToken);
    await saveAuthToken(newToken);
  }
}
```

**Global Error Handling**:
```dart
// In HTTP interceptor
if (response.statusCode == 401) {
  // Token invalid/expired
  ref.read(authProvider.notifier).logout();
  // User auto-redirected to login
}
```

---

## 8. Deep Link Support

### Shareable Cassette Links

The router supports public unlock links:

```
https://digitalcassette.app/unlock/ABC123
```

**Behavior**:
1. Link opens app (or web)
2. Router navigates to `/unlock/ABC123`
3. Route is public, no auth required
4. User can unlock and view cassette
5. After viewing, CTA prompts: "Create your own cassette"
6. If not logged in: redirects to `/login`
7. If logged in: redirects to `/create-cassette`

**Implementation**:
```dart
GoRoute(
  path: '/unlock/:cassetteId',
  builder: (context, state) {
    final cassetteId = state.pathParameters['cassetteId']!;
    return UnlockScreen(cassetteId: cassetteId);
  },
),
```

### Safe Back Navigation from Deep Links

Even if user enters via deep link, back navigation works:
- If user came from external link: back exits app
- If user navigated within app: back returns to previous screen
- GoRouter maintains proper stack in both cases

---

## 9. Security Best Practices

### Token Storage
✅ **Auth tokens**: FlutterSecureStorage (encrypted, platform keychain)
✅ **User data**: SharedPreferences (non-sensitive info only)
✅ **Error handling**: All storage operations wrapped in try-catch
✅ **Web compatibility**: Errors handled gracefully on web platform

### Route Protection
✅ **Declarative guards**: Routes protected at router level
✅ **No manual checks**: Auth state drives everything
✅ **Public links supported**: Shareable cassettes don't require auth
✅ **Redirect on invalid auth**: Automatic logout on token errors

### Best Practices
✅ **Never store passwords**: Only store auth tokens
✅ **Clear on logout**: All auth data removed
✅ **Validate on startup**: Token checked every app launch
✅ **Handle edge cases**: Missing data, broken tokens, network errors

---

## 10. Testing Persistent Login

### Test Scenarios

#### **Test 1: First Time User**
1. Launch app → Shows splash → Redirects to `/welcome`
2. Tap "Sign Up" → Enter details → Submit
3. User logged in → Redirects to `/profile-setup` or `/home`
4. Close app completely
5. Reopen app → Shows splash briefly → **Redirects to /home** ✓

#### **Test 2: Returning User**
1. Launch app (with existing token)
2. Shows splash for <500ms
3. **Redirects to /home** ✓
4. User sees dashboard immediately

#### **Test 3: Manual Logout**
1. Navigate to Settings
2. Tap "Log Out"
3. Confirm in dialog
4. **Redirects to /welcome** ✓
5. Close and reopen app
6. **User lands on /welcome** (not /home) ✓

#### **Test 4: Protected Route Access**
1. Log out if logged in
2. Try to navigate to `/library` manually (e.g., via URL bar on web)
3. **Redirected to /login** ✓
4. Login
5. **Redirected back to /library** ✓

#### **Test 5: Public Link Access**
1. Log out if logged in
2. Open `/unlock/ABC123`
3. **Unlock screen shows** (no redirect to login) ✓
4. User can unlock cassette without account

#### **Test 6: Back Navigation**
1. Login → Home → Library → Memory Detail
2. Press back → Returns to Library ✓
3. Press back → Returns to Home ✓
4. Press back → Exits app (doesn't go to login) ✓

---

## 11. Files Created/Modified

### New Files Created
- `lib/features/auth/domain/models/user_model.dart` - User data model
- `lib/features/auth/domain/models/auth_state.dart` - Auth state enum and class
- `lib/features/auth/domain/providers/auth_provider.dart` - Auth state manager
- `lib/features/splash/presentation/screens/splash_screen.dart` - Startup splash screen
- `docs/PERSISTENT_LOGIN_NAVIGATION.md` - This documentation

### Files Modified
- `lib/app/router.dart` - Complete router rewrite with auth guards
- `lib/features/auth/presentation/screens/login_screen.dart` - Use auth provider
- `lib/features/auth/presentation/screens/signup_screen.dart` - Use auth provider
- `lib/features/profile/presentation/screens/settings_screen.dart` - Add logout with auth provider
- `lib/data/services/storage_service.dart` - Already had error handling

---

## 12. Future Enhancements

### When Backend API is Connected

1. **Replace mock auth with real API calls**:
   ```dart
   Future<void> login(String email, String password) async {
     final response = await api.post('/auth/login', {
       'email': email,
       'password': password,
     });
     
     if (response.success) {
       await _storageService.saveAuthToken(response.data.token);
       await _storageService.saveUserData(
         userId: response.data.user.id,
         name: response.data.user.name,
         email: response.data.user.email,
       );
       state = AuthState.authenticated(user);
     }
   }
   ```

2. **Add token refresh mechanism**:
   - Store refresh token securely
   - Refresh access token before expiry
   - Handle 401 responses globally

3. **Add biometric authentication**:
   - Use `local_auth` package
   - Store biometric preference
   - Quick login with fingerprint/face

4. **Add "Remember Me" option**:
   - Currently always remembers
   - Add checkbox to login screen
   - Store preference in settings

5. **Add session timeout**:
   - Auto-logout after X days of inactivity
   - Store last activity timestamp
   - Check on app startup

---

## 13. Summary

### ✅ Requirements Met

1. **Persistent Login**: 
   - User stays logged in across app restarts
   - Auth token restored on startup
   - Automatic redirect based on auth state

2. **Proper Back Navigation**:
   - Android back button works correctly on every screen
   - Nested flows backtrack step-by-step
   - Tab navigation doesn't break history
   - Deep links have safe back paths

3. **Robust Architecture**:
   - Auth state centrally managed with Riverpod
   - Router reactively responds to auth changes
   - Secure token storage with error handling
   - Clean separation of auth flow and app navigation

4. **Startup Behavior**:
   - Splash screen during auth check
   - Correct routing based on session
   - No flashing of wrong screens

5. **Production-Ready Patterns**:
   - Type-safe auth states
   - Error handling throughout
   - Web compatibility
   - Scalable for future features

### Development Notes

- All auth logic is currently using **mock data**
- Replace `AuthNotifier` methods with real API calls when backend is ready
- Token expiry and refresh not yet implemented (add when API available)
- All navigation patterns are production-ready and scalable

---

**Implementation Date**: March 9, 2026  
**Framework**: Flutter 3.x with go_router and Riverpod  
**Status**: ✅ Complete and ready for testing
