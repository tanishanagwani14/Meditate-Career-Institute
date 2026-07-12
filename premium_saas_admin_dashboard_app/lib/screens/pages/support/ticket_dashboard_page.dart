import 'package:flutter/material.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/kpi_card.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class TicketDashboardPage extends StatelessWidget {
  const TicketDashboardPage({super.key});

  static const _tickets = [
    (
      'TICK-001',
      'Aarav Sharma',
      'Unable to access course materials',
      'Technical',
      'high',
      'Support Team A',
      '2026-05-01 10:30 AM',
      'pending'
    ),
    ('TICK-002', 'Diya Patel', 'Fee payment not reflecting', 'Billing', 'high', 'Support Team B', '2026-05-01 09:15 AM', 'pending'),
    ('TICK-003', 'Ananya Singh', 'Request for batch transfer', 'Academic', 'medium', 'Support Team A', '2026-04-30 04:20 PM', 'pending'),
    ('TICK-004', 'Vihaan Kumar', 'Course completion certificate', 'Academic', 'low', 'Support Team C', '2026-04-30 02:45 PM', 'completed'),
    ('TICK-005', 'Saanvi Gupta', 'Login password reset', 'Technical', 'medium', 'Support Team B', '2026-04-29 11:30 AM', 'completed'),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingCount = _tickets.where((t) => t.$8 == 'pending').length;
    final completedCount = _tickets.where((t) => t.$8 == 'completed').length;
    final highPriorityCount = _tickets.where((t) => t.$5 == 'high').length;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Support Ticket Dashboard',
          subtitle: 'Manage and track student support requests',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 1100 ? 4 : c.maxWidth >= 700 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: cols == 1 ? 2.2 : 1.7,
              children: [
                KpiCard(
                  title: 'Total Tickets',
                  value: '${_tickets.length}',
                  change: 'This week',
                  changeType: ChangeType.neutral,
                  icon: Icons.chat_bubble_outline,
                  iconBg: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Pending',
                  value: '$pendingCount',
                  change: 'Needs attention',
                  changeType: ChangeType.neutral,
                  icon: Icons.schedule,
                  iconBg: const Color(0xFFFFFBEB),
                  iconColor: const Color(0xFFCA8A04),
                ),
                KpiCard(
                  title: 'Resolved',
                  value: '$completedCount',
                  change: 'This week',
                  changeType: ChangeType.positive,
                  icon: Icons.check_circle_outline,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                ),
                KpiCard(
                  title: 'High Priority',
                  value: '$highPriorityCount',
                  change: 'Urgent attention',
                  changeType: ChangeType.negative,
                  icon: Icons.error_outline,
                  iconBg: const Color(0xFFFEE2E2),
                  iconColor: const Color(0xFFDC2626),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const FilterBar(searchPlaceholder: 'Search tickets by ID, student name, or subject...'),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Ticket ID', 'Student', 'Category', 'Priority', 'Assigned To', 'Created', 'Status', 'Actions'],
          rows: [
            for (final t in _tickets)
              [
                Text(t.$1, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, color: Color(0xFF4F46E5))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(t.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
                _CategoryChip(category: t.$4),
                _PriorityChip(priority: t.$5),
                Text(t.$6),
                Text(t.$7, style: const TextStyle(color: Color(0xFF4B5563))),
                StatusBadge(status: t.$8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                  child: const Text('View'),
                ),
              ],
          ],
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (category) {
      'Technical' => (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
      'Billing' => (const Color(0xFFDCFCE7), const Color(0xFF15803D)),
      _ => (const Color(0xFFF3E8FF), const Color(0xFF6B21A8)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});
  final String priority;

  @override
  Widget build(BuildContext context) {
    final p = priority.toLowerCase();
    final (Color bg, Color fg, Color border) = switch (p) {
      'high' => (const Color(0xFFFEE2E2), const Color(0xFFB91C1C), const Color(0xFFFECACA)),
      'medium' => (const Color(0xFFFEF9C3), const Color(0xFFA16207), const Color(0xFFFDE68A)),
      _ => (const Color(0xFFF3F4F6), const Color(0xFF374151), const Color(0xFFE5E7EB)),
    };
    final label = p[0].toUpperCase() + p.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999), border: Border.all(color: border)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}

