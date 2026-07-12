import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class EnrollmentDetailPage extends StatelessWidget {
  const EnrollmentDetailPage({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final item = (index >= 0 && index < DashboardData.newEnrollments.length)
        ? DashboardData.newEnrollments[index]
        : null;

    if (item == null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Enrollment Detail',
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Enrollment not found')),
        ],
      );
    }

    final student = item.$1;
    final course = item.$2;
    final batch = item.$3;
    final fee = item.$4;
    final time = item.$5;
    final status = item.$6;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Enrollment Detail',
          subtitle: 'Student enrollment information',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Text(
                    _initials(student),
                    style: const TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('$course · $batch', style: TextStyle(color: muted)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _Pill(label: 'Fee', value: fee),
                          _Pill(label: 'Enrolled', value: time),
                          StatusBadge(status: status),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Summary', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _kv('Student', student, muted),
                _kv('Course', course, muted),
                _kv('Batch', batch, muted),
                _kv('Fee', fee, muted),
                _kv('Enrolled', time, muted),
                _kv('Status', status, muted),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _kv(String k, String v, Color? muted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(k, style: TextStyle(color: muted, fontSize: 13))),
          Expanded(child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label: $value', style: TextStyle(fontSize: 12, color: muted, fontWeight: FontWeight.w600)),
    );
  }
}

