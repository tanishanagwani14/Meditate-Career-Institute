import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class TeacherDetailPage extends StatelessWidget {
  const TeacherDetailPage({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final item = (index >= 0 && index < DashboardData.activeTeachers.length)
        ? DashboardData.activeTeachers[index]
        : null;

    if (item == null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Teacher Detail',
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Teacher not found')),
        ],
      );
    }

    final name = item.$1;
    final subject = item.$2;
    final programs = item.$3;
    final batches = item.$4;
    final rating = item.$5;
    final status = item.$6;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Teacher Detail',
          subtitle: 'Profile & performance overview',
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
                  backgroundColor: const Color(0xFFF3E8FF),
                  child: Text(
                    _initials(name),
                    style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('$subject · $programs', style: TextStyle(color: muted)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _Pill(label: 'Batches', value: batches),
                          _Pill(label: 'Rating', value: rating),
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
                _kv('Name', name, muted),
                _kv('Subject', subject, muted),
                _kv('Programs', programs, muted),
                _kv('Batches', batches, muted),
                _kv('Rating', rating, muted),
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

