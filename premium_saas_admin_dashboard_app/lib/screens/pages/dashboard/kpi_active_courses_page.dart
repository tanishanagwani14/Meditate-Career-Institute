import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class KpiActiveCoursesPage extends StatelessWidget {
  const KpiActiveCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Active Courses',
          subtitle: '48 courses currently running',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        for (final c in DashboardData.activeCourses)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.menu_book_outlined, color: Color(0xFF7C3AED)),
              ),
              title: Text(c.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${c.$2} · ${c.$3}', style: TextStyle(color: muted, fontSize: 12)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(c.$4, style: TextStyle(fontSize: 11, color: muted)),
                  const SizedBox(height: 4),
                  StatusBadge(status: c.$5),
                ],
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }
}
