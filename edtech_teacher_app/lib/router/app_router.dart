import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/analytics_screen.dart';
import '../screens/calendar_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/courses_screen.dart';
import '../screens/create_course_screen.dart';
import '../screens/create_test_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/live_class_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/student_profile_screen.dart';
import '../screens/students_screen.dart';
import '../widgets/app_shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) => AppShell(navigationShell: navShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (c, s) => const DashboardScreen())]),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/courses',
                builder: (c, s) => const CoursesScreen(),
                routes: [
                  GoRoute(path: 'create', builder: (c, s) => const CreateCourseScreen()),
                  GoRoute(path: 'create-test', builder: (c, s) => const CreateTestScreen()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(routes: [GoRoute(path: '/students', builder: (c, s) => const StudentsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/messages', builder: (c, s) => const MessagesScreen())]),
        ],
      ),

      // Drawer destinations / full-screen screens.
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/analytics',
        builder: (c, s) => const AnalyticsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/calendar',
        builder: (c, s) => const CalendarScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/live-class',
        builder: (c, s) => const LiveClassScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/profile',
        builder: (c, s) => const ProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/student-profile',
        builder: (c, s) {
          final student = s.extra as StudentProfile?;
          if (student == null) {
            return const Scaffold(
              body: Center(child: Text('Student not found')),
            );
          }
          return StudentProfileScreen(student: student);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/chat',
        builder: (c, s) {
          final arg = s.extra as ChatArg?;
          if (arg == null) {
            return const Scaffold(
              body: Center(child: Text('Conversation not found')),
            );
          }
          return ChatScreen(arg: arg);
        },
      ),
    ],
  );
}

