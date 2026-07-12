import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/pages/academic/assignments_page.dart';
import '../screens/pages/academic/batches_page.dart';
import '../screens/pages/academic/content_moderation_page.dart';
import '../screens/pages/academic/courses_page.dart';
import '../screens/pages/academic/create_course_page.dart';
import '../screens/pages/affiliate_reports_page.dart';
import '../screens/pages/crm/counselor_dashboard_page.dart';
import '../screens/pages/crm/follow_up_board_page.dart';
import '../screens/pages/crm/lead_pipeline_page.dart';
import '../screens/pages/dashboard/activity_detail_page.dart';
import '../screens/pages/dashboard/active_teachers_page.dart';
import '../screens/pages/dashboard/fee_collection_page.dart';
import '../screens/pages/dashboard/fee_collection_detail_page.dart';
import '../screens/pages/dashboard/enrollment_detail_page.dart';
import '../screens/pages/dashboard/kpi_active_courses_page.dart';
import '../screens/pages/dashboard/kpi_attendance_page.dart';
import '../screens/pages/dashboard/kpi_monthly_revenue_page.dart';
import '../screens/pages/dashboard/kpi_revenue_detail_page.dart';
import '../screens/pages/dashboard/kpi_student_profile_page.dart';
import '../screens/pages/dashboard/kpi_total_students_page.dart';
import '../screens/pages/dashboard/new_enrollments_page.dart';
import '../screens/pages/dashboard/teacher_detail_page.dart';
import '../screens/pages/dashboard_page.dart';
import '../screens/pages/finance/coupon_management_page.dart';
import '../screens/pages/finance/fee_reports_page.dart';
import '../screens/pages/finance/payments_page.dart';
import '../screens/pages/finance/refund_approvals_page.dart';
import '../screens/pages/franchise_management_page.dart';
import '../screens/pages/multi_center_management_page.dart';
import '../screens/pages/admin_settings_page.dart';
import '../screens/pages/not_found_page.dart';
import '../screens/pages/students/add_student_page.dart';
import '../screens/pages/students/attendance/attendance_batch_detail_page.dart';
import '../screens/pages/students/attendance/attendance_kpi_detail_page.dart';
import '../screens/pages/students/attendance/attendance_weekly_detail_page.dart';
import '../screens/pages/students/attendance_page.dart';
import '../screens/pages/students/fees/fee_student_detail_page.dart';
import '../screens/pages/students/fees/fees_kpi_list_page.dart';
import '../screens/pages/students/fees_page.dart';
import '../screens/pages/students/reports/insight_detail_page.dart';
import '../screens/pages/students/reports/subject_performance_detail_page.dart';
import '../screens/pages/students/student_directory_page.dart';
import '../screens/pages/students/student_reports_page.dart';
import '../screens/pages/support/ticket_dashboard_page.dart';
import '../screens/pages/teachers/faculty_management_page.dart';
import '../screens/pages/teachers/add_teacher_page.dart';
import '../screens/pages/teachers/teacher_performance_page.dart';
import '../screens/pages/teachers/teacher_permissions_page.dart';
import '../screens/pages/teachers/teacher_permissions_edit_page.dart';
import '../screens/pages/communication/broadcast_system_page.dart';
import '../screens/pages/communication/notification_detail_page.dart';
import '../screens/pages/communication/notifications_page.dart';
import '../widgets/root_shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => RootShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (c, s) => const DashboardPage(),
            routes: [
              GoRoute(
                path: 'dashboard/kpi/students',
                builder: (c, s) => const KpiTotalStudentsPage(),
                routes: [
                  GoRoute(
                    path: ':index',
                    builder: (c, s) {
                      final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                      return KpiStudentProfilePage(index: index);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'dashboard/kpi/revenue',
                builder: (c, s) => const KpiMonthlyRevenuePage(),
                routes: [
                  GoRoute(
                    path: ':index',
                    builder: (c, s) {
                      final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                      return KpiRevenueDetailPage(index: index);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'dashboard/kpi/courses',
                builder: (c, s) => const KpiActiveCoursesPage(),
              ),
              GoRoute(
                path: 'dashboard/kpi/attendance',
                builder: (c, s) => const KpiAttendancePage(),
              ),
              GoRoute(
                path: 'dashboard/activity/:id',
                builder: (c, s) {
                  final id = int.tryParse(s.pathParameters['id'] ?? '') ?? -1;
                  return ActivityDetailPage(id: id);
                },
              ),
              GoRoute(
                path: 'dashboard/enrollments',
                builder: (c, s) => const NewEnrollmentsPage(),
              ),
              GoRoute(
                path: 'dashboard/enrollments/:index',
                builder: (c, s) {
                  final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                  return EnrollmentDetailPage(index: index);
                },
              ),
              GoRoute(
                path: 'dashboard/fee-collection',
                builder: (c, s) => const FeeCollectionPage(),
              ),
              GoRoute(
                path: 'dashboard/fee-collection/:index',
                builder: (c, s) {
                  final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                  return FeeCollectionDetailPage(index: index);
                },
              ),
              GoRoute(
                path: 'dashboard/active-teachers',
                builder: (c, s) => const ActiveTeachersPage(),
              ),
              GoRoute(
                path: 'dashboard/active-teachers/:index',
                builder: (c, s) {
                  final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                  return TeacherDetailPage(index: index);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/students',
            builder: (c, s) => const StudentDirectoryPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (c, s) => const AddStudentPage(),
              ),
              GoRoute(
                path: 'notifications',
                builder: (c, s) => const NotificationsPage(),
              ),
              GoRoute(
                path: 'settings',
                builder: (c, s) => const AdminSettingsPage(),
              ),
            ],
          ),
          GoRoute(
            path: '/students/attendance',
            builder: (c, s) => const AttendancePage(),
            routes: [
              GoRoute(
                path: 'overall',
                builder: (c, s) => const AttendanceKpiDetailPage(metric: AttendanceMetric.overall),
              ),
              GoRoute(
                path: 'present',
                builder: (c, s) => const AttendanceKpiDetailPage(metric: AttendanceMetric.present),
              ),
              GoRoute(
                path: 'absent',
                builder: (c, s) => const AttendanceKpiDetailPage(metric: AttendanceMetric.absent),
              ),
              GoRoute(
                path: 'weekly',
                builder: (c, s) => const AttendanceWeeklyDetailPage(),
              ),
              GoRoute(
                path: 'batch/:index',
                builder: (c, s) {
                  final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                  return AttendanceBatchDetailPage(index: index);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/students/fees',
            builder: (c, s) => const FeesPage(),
            routes: [
              GoRoute(
                path: 'collected',
                builder: (c, s) => const FeesKpiListPage(metric: FeeMetric.collected),
              ),
              GoRoute(
                path: 'pending',
                builder: (c, s) => const FeesKpiListPage(metric: FeeMetric.pending),
              ),
              GoRoute(
                path: 'overdue',
                builder: (c, s) => const FeesKpiListPage(metric: FeeMetric.overdue),
              ),
              GoRoute(
                path: 'rate',
                builder: (c, s) => const FeesKpiListPage(metric: FeeMetric.rate),
              ),
              GoRoute(
                path: 'student/:index',
                builder: (c, s) {
                  final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                  return FeeStudentDetailPage(index: index);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/students/reports',
            builder: (c, s) => const StudentReportsPage(),
            routes: [
              GoRoute(
                path: 'subjects',
                builder: (c, s) => const SubjectPerformanceDetailPage(),
                routes: [
                  GoRoute(
                    path: ':index',
                    builder: (c, s) {
                      final index = int.tryParse(s.pathParameters['index'] ?? '') ?? -1;
                      return SubjectPerformanceSubjectDetailPage(index: index);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'insights/:id',
                builder: (c, s) {
                  final id = int.tryParse(s.pathParameters['id'] ?? '') ?? -1;
                  return InsightDetailPage(id: id);
                },
              ),
              // Placeholder route target for the existing progress chart tap.
              GoRoute(
                path: 'progress',
                builder: (c, s) => const SubjectPerformanceDetailPage(),
              ),
            ],
          ),
          GoRoute(
            path: '/teachers',
            builder: (c, s) => const FacultyManagementPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (c, s) => const AddTeacherPage(),
              ),
            ],
          ),
          GoRoute(path: '/teachers/permissions', builder: (c, s) => const TeacherPermissionsPage()),
          GoRoute(path: '/teachers/permissions/edit', builder: (c, s) => const TeacherPermissionsEditPage()),
          GoRoute(path: '/teachers/performance', builder: (c, s) => const TeacherPerformancePage()),
          GoRoute(path: '/academic/courses', builder: (c, s) => const AcademicCoursesPage()),
          GoRoute(path: '/academic/courses/create', builder: (c, s) => const CreateCoursePage()),
          GoRoute(path: '/academic/batches', builder: (c, s) => const AcademicBatchesPage()),
          GoRoute(path: '/academic/assignments', builder: (c, s) => const AcademicAssignmentsPage()),
          GoRoute(path: '/academic/content', builder: (c, s) => const ContentModerationPage()),
          GoRoute(path: '/crm/leads', builder: (c, s) => const LeadPipelinePage()),
          GoRoute(path: '/crm/followup', builder: (c, s) => const FollowUpBoardPage()),
          GoRoute(path: '/crm/counselor', builder: (c, s) => const CounselorDashboardPage()),
          GoRoute(path: '/finance/payments', builder: (c, s) => const PaymentsPage()),
          GoRoute(path: '/finance/reports', builder: (c, s) => const FeeReportsPage()),
          GoRoute(path: '/finance/refunds', builder: (c, s) => const RefundApprovalsPage()),
          GoRoute(path: '/finance/coupons', builder: (c, s) => const CouponManagementPage()),
          GoRoute(path: '/communication/broadcast', builder: (c, s) => const BroadcastSystemPage()),
          GoRoute(path: '/support/tickets', builder: (c, s) => const TicketDashboardPage()),
          GoRoute(path: '/franchise', builder: (c, s) => const FranchiseManagementPage()),
          GoRoute(path: '/multi-center', builder: (c, s) => const MultiCenterManagementPage()),
          GoRoute(path: '/affiliate', builder: (c, s) => const AffiliateReportsPage()),
          GoRoute(path: '/404', builder: (c, s) => const NotFoundPage()),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/settings',
        builder: (c, s) => const AdminSettingsPage(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/communication/notifications',
        builder: (c, s) => const NotificationsPage(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (c, s) {
              final id = int.tryParse(s.pathParameters['id'] ?? '') ?? -1;
              return NotificationDetailPage(id: id);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}

