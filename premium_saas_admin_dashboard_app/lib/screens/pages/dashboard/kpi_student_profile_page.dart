import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class KpiStudentProfilePage extends StatelessWidget {
  const KpiStudentProfilePage({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final student = DashboardData.studentProfileAt(index);

    if (student == null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Student Profile',
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Student not found')),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Student Profile',
          subtitle: student.name,
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
                  radius: 32,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Text(
                    _initials(student.name),
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('${student.course} · ${student.batch}', style: TextStyle(color: muted)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusBadge(status: student.status),
                          _Pill(label: 'Fee', value: student.feeStatus),
                          _Pill(label: 'Attendance', value: student.attendance),
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
                const Text('About', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(student.about, style: TextStyle(color: muted, height: 1.45)),
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
                const Text('Contact & enrollment', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _kv('Email', student.email, muted),
                _kv('Phone', student.phone, muted),
                _kv('Parent / guardian', student.parentName, muted),
                _kv('Counselor', student.counselor, muted),
                _kv('Enrolled on', student.enrolledOn, muted),
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
                const Text('Academic summary', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                for (final d in student.details)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 140, child: Text(d.$1, style: TextStyle(color: muted, fontSize: 13))),
                        Expanded(
                          child: Text(d.$2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label: $value', style: TextStyle(fontSize: 12, color: muted, fontWeight: FontWeight.w600)),
    );
  }
}
