import 'package:go_router/go_router.dart';

import '../screens/admin_profile_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/institute_management_screen.dart';
import '../screens/moderation_screen.dart';
import '../screens/multi_region_screen.dart';
import '../screens/onboard_institute_screen.dart';
import '../screens/user_add_screen.dart';
import '../screens/platform_overview_screen.dart';
import '../screens/saas_billing_screen.dart';
import '../screens/security_monitoring_screen.dart';
import '../screens/security_screen.dart';
import '../screens/support_screen.dart';
import '../screens/system_settings_screen.dart';
import '../screens/user_management_screen.dart';
import '../widgets/enterprise_shell.dart';

final GoRouter enterpriseRouter = GoRouter(
  initialLocation: '/overview',
  routes: [
    ShellRoute(
      builder: (context, state, child) => EnterpriseShell(child: child),
      routes: [
        GoRoute(
          path: '/overview',
          pageBuilder: (c, s) => const NoTransitionPage(child: PlatformOverviewScreen()),
        ),
        GoRoute(
          path: '/institutes',
          pageBuilder: (c, s) => const NoTransitionPage(child: InstituteManagementScreen()),
        ),
        GoRoute(
          path: '/institutes/onboard',
          builder: (c, s) => const OnboardInstituteScreen(),
        ),
        GoRoute(
          path: '/users',
          pageBuilder: (c, s) => const NoTransitionPage(child: UserManagementScreen()),
        ),
        GoRoute(
          path: '/users/add',
          builder: (c, s) => const UserAddScreen(),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (c, s) => const NoTransitionPage(child: AnalyticsScreen()),
        ),
        GoRoute(
          path: '/moderation',
          pageBuilder: (c, s) => const NoTransitionPage(child: ModerationScreen()),
        ),
        GoRoute(
          path: '/support',
          pageBuilder: (c, s) => const NoTransitionPage(child: SupportScreen()),
        ),
        GoRoute(
          path: '/security',
          pageBuilder: (c, s) => const NoTransitionPage(child: SecurityScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (c, s) => const NoTransitionPage(child: SystemSettingsScreen()),
        ),
        GoRoute(
          path: '/profile',
          builder: (c, s) => const AdminProfileScreen(),
        ),
        GoRoute(
          path: '/regions',
          pageBuilder: (c, s) => const NoTransitionPage(child: MultiRegionScreen()),
        ),
        GoRoute(
          path: '/monitoring',
          pageBuilder: (c, s) => const NoTransitionPage(child: SecurityMonitoringScreen()),
        ),
        GoRoute(
          path: '/billing',
          pageBuilder: (c, s) => const NoTransitionPage(child: SaaSBillingScreen()),
        ),
      ],
    ),
  ],
);
