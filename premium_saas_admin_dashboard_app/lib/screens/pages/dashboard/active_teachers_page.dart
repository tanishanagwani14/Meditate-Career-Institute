import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class ActiveTeachersPage extends StatelessWidget {
  const ActiveTeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Active Teachers',
          subtitle: '42 teaching staff currently active',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < DashboardData.activeTeachers.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => context.push('/dashboard/active-teachers/$i'),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFF3E8FF),
                child: Text(
                  DashboardData.activeTeachers[i].$1
                      .split(' ')
                      .where((w) => w.isNotEmpty)
                      .map((w) => w[0])
                      .take(2)
                      .join(),
                  style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
              title: Text(DashboardData.activeTeachers[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${DashboardData.activeTeachers[i].$2} · ${DashboardData.activeTeachers[i].$3} · ${DashboardData.activeTeachers[i].$4}',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(DashboardData.activeTeachers[i].$5, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  StatusBadge(status: DashboardData.activeTeachers[i].$6),
                ],
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}
