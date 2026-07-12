import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class NewEnrollmentsPage extends StatelessWidget {
  const NewEnrollmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'New Enrollments',
          subtitle: '156 students enrolled this month',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < DashboardData.newEnrollments.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => context.push('/dashboard/enrollments/$i'),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFDBEAFE),
                child: Text(
                  DashboardData.newEnrollments[i].$1
                      .split(' ')
                      .map((w) => w.isNotEmpty ? w[0] : '')
                      .take(2)
                      .join(),
                  style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
              title: Text(DashboardData.newEnrollments[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${DashboardData.newEnrollments[i].$2} · ${DashboardData.newEnrollments[i].$3}',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DashboardData.newEnrollments[i].$4, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  StatusBadge(status: DashboardData.newEnrollments[i].$6),
                ],
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}
