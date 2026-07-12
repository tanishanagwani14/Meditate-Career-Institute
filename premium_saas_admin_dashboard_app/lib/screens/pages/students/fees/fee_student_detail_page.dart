import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/fees_data.dart';
import '../../../../widgets/shared/page_header.dart';
import '../../../../widgets/shared/status_badge.dart';

class FeeStudentDetailPage extends StatelessWidget {
  const FeeStudentDetailPage({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final r = (index >= 0 && index < FeesData.records.length) ? FeesData.records[index] : null;

    if (r == null) {
      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: 'Student Fee Profile',
              action: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back'),
              ),
            ),
            const SizedBox(height: 24),
            const Center(child: Text('Student record not found')),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: r.studentName,
            subtitle: '${r.course} · ${r.batch}',
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFEEF2FF),
                    child: Text(
                      _initials(r.studentName),
                      style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.studentName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text(r.email, style: TextStyle(color: muted)),
                        const SizedBox(height: 2),
                        Text(r.phone, style: TextStyle(color: muted)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            StatusBadge(status: r.status == 'paid' ? 'completed' : (r.status == 'pending' ? 'pending' : 'overdue')),
                            const SizedBox(width: 10),
                            Text(r.paidOn == null ? 'Due: ${r.dueDate}' : 'Paid: ${r.paidOn}', style: TextStyle(color: muted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fee details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  _InfoRow(label: 'Amount', value: FeesData.formatInr(r.feeAmountInr)),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Due date', value: r.dueDate),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Paid on', value: r.paidOn ?? '-'),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Receipt', value: r.receiptId ?? '-'),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (r.status != 'paid')
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Collect Fee coming soon')),
                            );
                          },
                          child: const Text('Collect Fee'),
                        )
                      else
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Receipt view coming soon')),
                            );
                          },
                          child: const Text('View Receipt'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90, child: Text(label, style: TextStyle(color: muted, fontWeight: FontWeight.w700))),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700))),
      ],
    );
  }
}

