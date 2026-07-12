import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/attendance_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Attendance Management',
          subtitle: 'Track and manage student attendance across all batches',
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CompactStatBar(
                title: 'Overall',
                value: '${AttendanceData.overallPercent.toStringAsFixed(0)}%',
                icon: Icons.check_circle_outline,
                iconBg: const Color(0xFFDCFCE7),
                iconColor: const Color(0xFF16A34A),
                onTap: () => context.push('/students/attendance/overall'),
              ),
              const SizedBox(width: 8),
              _CompactStatBar(
                title: 'Present',
                value: '${AttendanceData.presentToday}',
                icon: Icons.people_outline,
                iconBg: const Color(0xFFDBEAFE),
                iconColor: const Color(0xFF2563EB),
                onTap: () => context.push('/students/attendance/present'),
              ),
              const SizedBox(width: 8),
              _CompactStatBar(
                title: 'Absent',
                value: '${AttendanceData.absentToday}',
                icon: Icons.cancel_outlined,
                iconBg: const Color(0xFFFEE2E2),
                iconColor: const Color(0xFFDC2626),
                onTap: () => context.push('/students/attendance/absent'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.push('/students/attendance/weekly'),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Weekly Attendance Trend',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 20, color: Theme.of(context).hintColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final d in AttendanceData.weeklyTrend)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        height: 1.3 * d.percent,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4F46E5),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    d.label,
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SimpleDataTable(
          columns: const ['Batch', 'Date', 'Present', 'Absent', 'Total Students', 'Attendance %'],
          onRowTap: (index) => context.push('/students/attendance/batch/$index'),
          rows: [
            for (final r in AttendanceData.batches)
              [
                Text(r.batch, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(r.date),
                Row(
                  children: [
                    const Icon(Icons.check_circle, size: 16, color: Color(0xFF22C55E)),
                    const SizedBox(width: 6),
                    Text(
                      '${r.presentCount}',
                      style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.cancel, size: 16, color: Color(0xFFEF4444)),
                    const SizedBox(width: 6),
                    Text(
                      '${r.absentCount}',
                      style: const TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Text('${r.total}'),
                _PercentageCell(value: r.percent),
              ],
          ],
        ),
      ],
    );
  }
}

class _CompactStatBar extends StatelessWidget {
  const _CompactStatBar({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: muted, height: 1.1),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PercentageCell extends StatelessWidget {
  const _PercentageCell({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    final Color c = value >= 90
        ? const Color(0xFF22C55E)
        : (value >= 75 ? const Color(0xFFEAB308) : const Color(0xFFEF4444));
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              color: c,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.toStringAsFixed(value % 1 == 0 ? 0 : 1)}%',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}
