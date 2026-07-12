import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/attendance_data.dart';
import '../../../../widgets/shared/page_header.dart';

class AttendanceBatchDetailPage extends StatelessWidget {
  const AttendanceBatchDetailPage({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final batch = (index >= 0 && index < AttendanceData.batches.length)
        ? AttendanceData.batches[index]
        : null;

    if (batch == null) {
      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: 'Batch Attendance',
              action: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back'),
              ),
            ),
            const SizedBox(height: 24),
            const Center(child: Text('Batch not found')),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: batch.batch,
              subtitle: 'Attendance for ${batch.date}',
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
                  children: [
                    _countTile(
                      label: 'Present',
                      count: batch.presentCount,
                      color: const Color(0xFF16A34A),
                      bg: const Color(0xFFDCFCE7),
                    ),
                    const SizedBox(width: 12),
                    _countTile(
                      label: 'Absent',
                      count: batch.absentCount,
                      color: const Color(0xFFDC2626),
                      bg: const Color(0xFFFEE2E2),
                    ),
                    const SizedBox(width: 12),
                    _countTile(
                      label: 'Total',
                      count: batch.total,
                      color: const Color(0xFF2563EB),
                      bg: const Color(0xFFDBEAFE),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${batch.percent.toStringAsFixed(batch.percent % 1 == 0 ? 0 : 1)}%',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        Text('Attendance', style: TextStyle(color: muted, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const TabBar(
              tabs: [
                Tab(text: 'Present'),
                Tab(text: 'Absent'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 420,
              child: TabBarView(
                children: [
                  _StudentList(
                    students: batch.presentStudents,
                    present: true,
                    muted: muted,
                  ),
                  _StudentList(
                    students: batch.absentStudents,
                    present: false,
                    muted: muted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _countTile({
    required String label,
    required int count,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

class _StudentList extends StatelessWidget {
  const _StudentList({
    required this.students,
    required this.present,
    required this.muted,
  });

  final List<String> students;
  final bool present;
  final Color? muted;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return Center(
        child: Text(
          present ? 'No students marked present' : 'No absent students',
          style: TextStyle(color: muted),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: students.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final name = students[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: present ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              child: Text(
                _initials(name),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: present ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                ),
              ),
            ),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: Icon(
              present ? Icons.check_circle : Icons.cancel,
              color: present ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
              size: 20,
            ),
          );
        },
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
