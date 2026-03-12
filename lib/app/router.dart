import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/auth/domain/providers/auth_provider.dart';
import '../features/home/presentation/screens/landing_home_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/create_cassette/presentation/screens/create_cassette_flow_screen.dart';
import '../features/unlock/presentation/screens/unlock_screen.dart';
import '../features/unlock/presentation/screens/cassette_experience_screen.dart';
import '../features/library/presentation/screens/library_screen.dart';
import '../features/library/presentation/screens/memory_detail_screen.dart';
import '../features/reply/presentation/screens/reply_flow_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';

// Public routes that don't require authentication
const _publicRoutes = [
  '/',
  '/welcome',
  '/login',
  '/signup',
];

// Routes that should be accessible even when checking if a link leads to unlock
bool _isPublicRoute(String location) {
  return _publicRoutes.contains(location) ||
      location.startsWith('/unlock/') ||
      location.startsWith('/cassette/');
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,

    // Global redirect logic
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublic = _isPublicRoute(location);

      // Show splash while checking auth status
      if (authState.isInitial || authState.isLoading) {
        if (location != '/splash' &&
            !location.startsWith('/unlock/') &&
            !location.startsWith('/cassette/')) {
          return '/splash';
        }
        return null;
      }

      // After splash, redirect based on auth state
      if (location == '/splash') {
        if (authState.isAuthenticated) {
          return '/';
        } else {
          return '/welcome';
        }
      }

      // Protect authenticated routes
      if (!isPublic && authState.isUnauthenticated) {
        return '/login';
      }

      // Redirect logged-in users away from auth screens
      if (authState.isAuthenticated &&
          (location == '/welcome' ||
              location == '/login' ||
              location == '/signup')) {
        return '/';
      }

      return null;
    },

    routes: [
      // Splash screen (auth check)
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Public marketing landing page
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingHomeScreen(),
      ),

      // Auth routes (public)
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // Unlock cassette (public, shareable link)
      GoRoute(
        path: '/unlock/:cassetteId',
        builder: (context, state) {
          final cassetteId = state.pathParameters['cassetteId']!;
          return UnlockScreen(cassetteId: cassetteId);
        },
      ),
      GoRoute(
        path: '/cassette/:cassetteId',
        builder: (context, state) {
          final cassetteId = state.pathParameters['cassetteId']!;
          return CassetteExperienceScreen(cassetteId: cassetteId);
        },
      ),

      // ===========================
      // AUTHENTICATED ROUTES BELOW
      // ===========================

      // Main app home (authenticated)
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Create cassette flow
      GoRoute(
        path: '/create-cassette',
        builder: (context, state) => const CreateCassetteFlowScreen(),
      ),

      // Library and memory detail
      GoRoute(
        path: '/library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: '/memory/:memoryId',
        builder: (context, state) {
          final memoryId = state.pathParameters['memoryId']!;
          return MemoryDetailScreen(memoryId: memoryId);
        },
      ),

      // Reply to cassette
      GoRoute(
        path: '/reply/:cassetteId',
        builder: (context, state) {
          final cassetteId = state.pathParameters['cassetteId']!;
          return ReplyFlowScreen(cassetteId: cassetteId);
        },
      ),

      // Notifications
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      // Profile and settings
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => const LandingHomeScreen(),
  );
});
