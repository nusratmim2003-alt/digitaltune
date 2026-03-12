import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Server Client ID (Web OAuth Client ID) is required for ID token on Android
    serverClientId:
        '122124697545-oc6vpa00n2tlancqfupu23l1n8ebq0c8.apps.googleusercontent.com',
  );

  /// Sign in with Google and return the ID token
  Future<String?> signInWithGoogle() async {
    try {
      print('🔐 Starting Google Sign-In...');

      // Sign out first to ensure account picker shows
      await _googleSignIn.signOut();
      print('📝 Signed out from previous session');

      // Trigger sign-in flow
      print('👤 Opening account picker...');
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User cancelled the sign-in
        print('❌ User cancelled sign-in');
        return null;
      }

      print('✅ Account selected: ${account.email}');

      // Get authentication details
      final GoogleSignInAuthentication authentication =
          await account.authentication;

      final idToken = authentication.idToken;

      if (idToken == null) {
        print('⚠️ ID token is null! Check serverClientId configuration.');
        return null;
      }

      print('🎫 ID token received (length: ${idToken.length})');

      // Return the ID token to send to backend
      return idToken;
    } catch (e) {
      print('❌ Google Sign-In Error: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print('Google Sign-Out Error: $e');
    }
  }

  /// Check if user is currently signed in
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
