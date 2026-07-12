import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/attendance_data.dart';
import '../../../../widgets/shared/page_header.dart';

class AttendanceWeeklyDetailPage extends StatelessWidget {
  const AttendanceWeeklyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final avg = AttendanceData.weeklyTrend.map((d) => d.percent).reduce((a, b) => a + b) /
        AttendanceData.weeklyTrend.length;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Weekly Attendance Trend',
            subtitle: '${avg.toStringAsFixed(1)}% average this week',
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
              child: SizedBox(
                height: 220,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final d in AttendanceData.weeklyTrend)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${d.percent.toStringAsFixed(0)}%',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    width: double.infinity,
                                    height: 2.0 * d.percent,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4F46E5),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(d.label, style: TextStyle(fontSize: 11, color: muted)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Day-wise breakdown', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final d in AttendanceData.weeklyTrend)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    d.label,
                    style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF4F46E5)),
                  ),
                ),
                title: Text('${d.percent.toStringAsFixed(0)}% attendance', style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  '${d.present} present · ${d.absent} absent · ${d.batchesMarked} batches',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                trailing: _TrendChip(percent: d.percent),
              ),
            ),
        ],
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.percent});
  final double percent;

  @override
  Widget build(BuildContext context) {
    final color = percent >= 90
        ? const Color(0xFF16A34A)
        : (percent >= 85 ? const Color(0xFFCA8A04) : const Color(0xFFDC2626));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        percent >= 90 ? 'Good' : (percent >= 85 ? 'Fair' : 'Low'),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
