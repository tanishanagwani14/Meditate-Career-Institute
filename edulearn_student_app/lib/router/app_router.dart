import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/achievements_screen.dart';
import '../screens/ask_doubt_screen.dart';
import '../screens/course_detail_screen.dart';
import '../screens/courses_marketplace_screen.dart';
import '../screens/doubts_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/live_class_room_screen.dart';
import '../screens/live_classes_screen.dart';
import '../screens/login_screen.dart';
import '../screens/my_courses_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/otp_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/test_taking_screen.dart';
import '../screens/tests_screen.dart';
import '../screens/video_player_screen.dart';
import '../widgets/main_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (c, s) => const SignupScreen()),
      GoRoute(
        path: '/otp-verification',
        builder: (c, s) => OtpScreen(phone: s.uri.queryParameters['phone'] ?? ''),
      ),
      GoRoute(path: '/forgot-password', builder: (c, s) => const ForgotPasswordScreen()),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/home', builder: (c, s) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/courses',
                builder: (c, s) => const CoursesMarketplaceScreen(),
                routes: [
                  GoRoute(path: 'my-courses', builder: (c, s) => const MyCoursesScreen()),
                  GoRoute(
                    path: ':courseId',
                    builder: (c, s) => CourseDetailScreen(
                      courseId: s.pathParameters['courseId']!,
                      from: s.uri.queryParameters['from'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/live-classes',
                builder: (c, s) => LiveClassesScreen(
                  from: s.uri.queryParameters['from'],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/doubts',
                builder: (c, s) => DoubtsScreen(
                  initialTab: s.uri.queryParameters['tab'],
                  from: s.uri.queryParameters['from'],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen())],
          ),
        ],
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/video-player/:id',
        builder: (c, s) => VideoPlayerScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/live-class/:id',
        builder: (c, s) => LiveClassRoomScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/test/:id',
        builder: (c, s) => TestTakingScreen(id: s.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/ask-doubt',
        builder: (c, s) => const AskDoubtScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/notifications',
        builder: (c, s) => const NotificationsScreen(),
        routes: [
          GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            path: ':id',
            builder: (c, s) {
              final id = int.tryParse(s.pathParameters['id'] ?? '') ?? -1;
              return NotificationDetailScreen(id: id);
            },
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/achievements',
        builder: (c, s) => AchievementsScreen(
          from: s.uri.queryParameters['from'],
        ),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/tests',
        builder: (c, s) => const TestsScreen(),
      ),
    ],
  );
}
