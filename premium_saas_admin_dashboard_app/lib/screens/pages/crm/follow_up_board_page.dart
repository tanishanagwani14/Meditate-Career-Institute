import 'package:flutter/material.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class FollowUpBoardPage extends StatelessWidget {
  const FollowUpBoardPage({super.key});

  static const _followUps = [
    (
      1,
      'Rahul Verma',
      '+91 98765 12345',
      'Counselor A',
      '2026-04-28',
      '2026-05-02',
      'high',
      'pending',
      'Interested in JEE course'
    ),
    (2, 'Priya Desai', '+91 98765 12346', 'Counselor B', '2026-04-29', '2026-05-03', 'medium', 'pending', 'Requested fee structure'),
    (3, 'Ankit Sharma', '+91 98765 12347', 'Counselor A', '2026-04-30', '2026-05-01', 'high', 'overdue', 'Demo completed, waiting decision'),
    (4, 'Sneha Patel', '+91 98765 12348', 'Counselor C', '2026-04-27', '2026-04-30', 'high', 'overdue', 'Proposal sent, no response'),
    (5, 'Meera Reddy', '+91 98765 12350', 'Counselor B', '2026-05-01', '2026-05-05', 'low', 'pending', 'Just browsing'),
  ];

  @override
  Widget build(BuildContext context) {
    final overdueCount = _followUps.where((f) => f.$8 == 'overdue').length;
    final highPriorityCount = _followUps.where((f) => f.$7 == 'high').length;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Follow-up Board',
          subtitle: 'Track and manage lead follow-ups and communications',
        ),
        const SizedBox(height: 16),
        if (overdueCount > 0) ...[
          Card(
            color: const Color(0xFFFEF2F2),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Overdue Follow-ups', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF7F1D1D))),
                        const SizedBox(height: 4),
                        Text(
                          'You have $overdueCount overdue follow-ups that require immediate attention.',
                          style: const TextStyle(color: Color(0xFFB91C1C)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 950 ? 3 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: cols == 1 ? 2.8 : 2.6,
              children: [
                _StatCard(
                  label: 'Total Follow-ups',
                  value: '${_followUps.length}',
                  valueColor: const Color(0xFF111827),
                  icon: Icons.calendar_today_outlined,
                  iconColor: const Color(0xFF9CA3AF),
                ),
                _StatCard(
                  label: 'High Priority',
                  value: '$highPriorityCount',
                  valueColor: const Color(0xFFDC2626),
                  icon: Icons.error_outline,
                  iconColor: const Color(0xFFF87171),
                ),
                _StatCard(
                  label: 'Overdue',
                  value: '$overdueCount',
                  valueColor: const Color(0xFFEA580C),
                  icon: Icons.error_outline,
                  iconColor: const Color(0xFFFBBF24),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const FilterBar(searchPlaceholder: 'Search follow-ups by lead name or counselor...'),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Lead Name', 'Assigned To', 'Last Contact', 'Next Follow-up', 'Priority', 'Status', 'Notes', 'Actions'],
          rows: [
            for (final f in _followUps)
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF6B7280)),
                        const SizedBox(width: 6),
                        Text(f.$3, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ],
                ),
                Text(f.$4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Text(f.$5),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Text(f.$6),
                  ],
                ),
                _PriorityChip(priority: f.$7),
                StatusBadge(status: f.$8),
                Text(f.$9, style: const TextStyle(color: Color(0xFF4B5563))),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Calling ${f.$3} (demo)')),
                        );
                      },
                      tooltip: 'Call',
                      icon: const Icon(Icons.phone, size: 18, color: Color(0xFF2563EB)),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Emailing ${f.$4} (demo)')),
                        );
                      },
                      tooltip: 'Email',
                      icon: const Icon(Icons.mail, size: 18, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
              ],
          ],
        ),
      ],
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Color(0xFF4B5563))),
                  const SizedBox(height: 6),
                  Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: valueColor)),
                ],
              ),
            ),
            Icon(icon, size: 32, color: iconColor),
          ],
        ),
      ),
    );
  }
}

