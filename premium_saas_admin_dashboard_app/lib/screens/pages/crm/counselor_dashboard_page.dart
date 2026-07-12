import 'package:flutter/material.dart';

import '../../../widgets/shared/kpi_card.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';

class CounselorDashboardPage extends StatelessWidget {
  const CounselorDashboardPage({super.key});

  static const _performance = [
    ('Counselor A', 45, 28, 62),
    ('Counselor B', 38, 22, 58),
    ('Counselor C', 52, 35, 67),
    ('Counselor D', 30, 18, 60),
  ];

  @override
  Widget build(BuildContext context) {
    final totalLeads = _performance.fold<int>(0, (acc, c) => acc + c.$2);
    final totalConverted = _performance.fold<int>(0, (acc, c) => acc + c.$3);
    final avgConversion = totalLeads == 0 ? 0 : ((totalConverted / totalLeads) * 100).round();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Counselor Dashboard',
          subtitle: 'Monitor counselor performance and lead conversion metrics',
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
                  title: 'Total Leads',
                  value: '$totalLeads',
                  change: 'This month',
                  changeType: ChangeType.neutral,
                  icon: Icons.people_outline,
                  iconBg: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Converted',
                  value: '$totalConverted',
                  change: '$avgConversion% conversion',
                  changeType: ChangeType.positive,
                  icon: Icons.track_changes_outlined,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                ),
                KpiCard(
                  title: 'Avg Conversion Rate',
                  value: '$avgConversion%',
                  change: '+4% from last month',
                  changeType: ChangeType.positive,
                  icon: Icons.trending_up,
                  iconBg: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF9333EA),
                ),
                const KpiCard(
                  title: 'Active Counselors',
                  value: '4',
                  change: 'All active',
                  changeType: ChangeType.neutral,
                  icon: Icons.people_outline,
                  iconBg: Color(0xFFFFEDD5),
                  iconColor: Color(0xFFEA580C),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final is2 = c.maxWidth >= 950;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: is2 ? 2 : 1,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: is2 ? 1.65 : 1.35,
              children: const [
                _ChartCard(title: 'Counselor Performance', child: _CounselorBars()),
                _ChartCard(title: 'Lead Sources', child: _LeadSourcesPie()),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const _ChartCard(
          title: 'Activity Summary',
          child: _ActivityTable(),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

class _CounselorBars extends StatelessWidget {
  const _CounselorBars();

  static const data = [
    ('Counselor A', 45.0, 28.0),
    ('Counselor B', 38.0, 22.0),
    ('Counselor C', 52.0, 35.0),
    ('Counselor D', 30.0, 18.0),
  ];

  @override
  Widget build(BuildContext context) {
    final maxV = data.map((e) => e.$2).reduce((a, b) => a > b ? a : b);
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final d in data)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 220 * (d.$2 / maxV),
                                    decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Container(
                                    height: 220 * (d.$3 / maxV),
                                    decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(d.$1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          children: const [
            _LegendDot(color: Color(0xFF4F46E5), label: 'Total Leads'),
            _LegendDot(color: Color(0xFF10B981), label: 'Converted'),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
      ],
    );
  }
}

class _LeadSourcesPie extends StatelessWidget {
  const _LeadSourcesPie();

  static const data = [
    ('Website', 120, Color(0xFF4F46E5)),
    ('Referral', 85, Color(0xFF10B981)),
    ('Social Media', 95, Color(0xFFF59E0B)),
    ('Walk-in', 45, Color(0xFFEC4899)),
  ];

  @override
  Widget build(BuildContext context) {
    final total = data.fold<int>(0, (acc, s) => acc + s.$2);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(painter: _PiePainter(data: data)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            for (final s in data)
              _LegendDot(
                color: s.$3,
                label: '${s.$1}: ${total == 0 ? 0 : ((s.$2 / total) * 100).round()}%',
              ),
          ],
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter({required this.data});
  final List<(String, int, Color)> data;

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<int>(0, (acc, s) => acc + s.$2);
    final rect = Offset.zero & size;
    var start = -1.57079632679; // -pi/2
    for (final s in data) {
      final sweep = total == 0 ? 0.0 : (s.$2 / total) * 6.28318530718; // 2pi
      final paint = Paint()..color = s.$3;
      canvas.drawArc(rect, start, sweep, true, paint);
      start += sweep;
    }
    canvas.drawCircle(size.center(Offset.zero), size.shortestSide * 0.22, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) => oldDelegate.data != data;
}

class _ActivityTable extends StatelessWidget {
  const _ActivityTable();

  static const activities = [
    ('Counselor A', 24, 18, 8, 5),
    ('Counselor B', 20, 15, 6, 4),
    ('Counselor C', 28, 22, 10, 7),
    ('Counselor D', 16, 12, 5, 3),
  ];

  @override
  Widget build(BuildContext context) {
    return SimpleDataTable(
      columns: const ['Counselor', 'Calls Made', 'Emails Sent', 'Meetings', 'Demos Given'],
      rows: [
        for (final a in activities)
          [
            Text(a.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('${a.$2}'),
            Text('${a.$3}'),
            Text('${a.$4}'),
            Text('${a.$5}'),
          ],
      ],
    );
  }
}

