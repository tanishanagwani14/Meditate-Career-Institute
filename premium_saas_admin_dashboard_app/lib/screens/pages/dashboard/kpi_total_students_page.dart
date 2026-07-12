import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class KpiTotalStudentsPage extends StatelessWidget {
  const KpiTotalStudentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Total Students',
          subtitle: '1,284 enrolled students',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < DashboardData.totalStudents.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => context.push('/dashboard/kpi/students/$i'),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFDBEAFE),
                child: Text(
                  _initials(DashboardData.totalStudents[i].name),
                  style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
              title: Text(
                DashboardData.totalStudents[i].name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${DashboardData.totalStudents[i].course} · ${DashboardData.totalStudents[i].batch}',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Enrolled ${DashboardData.totalStudents[i].enrolledOn}',
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(status: DashboardData.totalStudents[i].status),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: muted, size: 22),
                ],
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
