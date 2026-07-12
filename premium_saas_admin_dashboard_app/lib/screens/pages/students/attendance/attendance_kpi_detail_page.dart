import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/attendance_data.dart';
import '../../../../widgets/shared/page_header.dart';

enum AttendanceMetric { overall, present, absent }

class AttendanceKpiDetailPage extends StatelessWidget {
  const AttendanceKpiDetailPage({super.key, required this.metric});

  final AttendanceMetric metric;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: _title,
            subtitle: _subtitle,
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 16),
          if (metric == AttendanceMetric.overall) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _metricIcon(Icons.check_circle_outline, const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AttendanceData.overallPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                          ),
                          Text('Institute-wide average today', style: TextStyle(color: muted)),
                          const SizedBox(height: 6),
                          Text(
                            '+2.3% from last week',
                            style: TextStyle(color: muted, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('By batch', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (var i = 0; i < AttendanceData.batches.length; i++)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _percentBg(AttendanceData.batches[i].percent),
                    child: Text(
                      '${AttendanceData.batches[i].percent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _percentColor(AttendanceData.batches[i].percent),
                      ),
                    ),
                  ),
                  title: Text(AttendanceData.batches[i].batch, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${AttendanceData.batches[i].presentCount} present · ${AttendanceData.batches[i].absentCount} absent',
                    style: TextStyle(color: muted),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/students/attendance/batch/$i'),
                ),
              ),
          ] else ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _metricIcon(
                      metric == AttendanceMetric.present ? Icons.people_outline : Icons.cancel_outlined,
                      metric == AttendanceMetric.present ? const Color(0xFFDBEAFE) : const Color(0xFFFEE2E2),
                      metric == AttendanceMetric.present ? const Color(0xFF2563EB) : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${metric == AttendanceMetric.present ? AttendanceData.presentToday : AttendanceData.absentToday}',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            metric == AttendanceMetric.present
                                ? 'Out of ${AttendanceData.totalStudents} students'
                                : '${((AttendanceData.absentToday / AttendanceData.totalStudents) * 100).toStringAsFixed(1)}% absenteeism',
                            style: TextStyle(color: muted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              metric == AttendanceMetric.present ? 'Present students' : 'Absent students',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  for (final name in _students)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: metric == AttendanceMetric.present
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEE2E2),
                        child: Text(
                          _initials(name),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: metric == AttendanceMetric.present
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ),
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: Icon(
                        metric == AttendanceMetric.present ? Icons.check_circle : Icons.cancel,
                        color: metric == AttendanceMetric.present
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFEF4444),
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String get _title => switch (metric) {
        AttendanceMetric.overall => 'Overall Attendance',
        AttendanceMetric.present => 'Present Today',
        AttendanceMetric.absent => 'Absent Today',
      };

  String get _subtitle => switch (metric) {
        AttendanceMetric.overall => 'Batch-wise breakdown for today',
        AttendanceMetric.present => 'Students marked present across all batches',
        AttendanceMetric.absent => 'Students marked absent across all batches',
      };

  List<String> get _students => switch (metric) {
        AttendanceMetric.present => AttendanceData.allPresentToday,
        AttendanceMetric.absent => AttendanceData.allAbsentToday,
        AttendanceMetric.overall => const [],
      };

  static Widget _metricIcon(IconData icon, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, color: color, size: 28),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  static Color _percentColor(double v) {
    if (v >= 90) return const Color(0xFF16A34A);
    if (v >= 75) return const Color(0xFFCA8A04);
    return const Color(0xFFDC2626);
  }

  static Color _percentBg(double v) {
    if (v >= 90) return const Color(0xFFDCFCE7);
    if (v >= 75) return const Color(0xFFFEF9C3);
    return const Color(0xFFFEE2E2);
  }
}
