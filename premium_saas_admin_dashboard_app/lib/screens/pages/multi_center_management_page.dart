import 'package:flutter/material.dart';

import '../../widgets/shared/page_header.dart';
import '../../widgets/shared/simple_data_table.dart';

class MultiCenterManagementPage extends StatelessWidget {
  const MultiCenterManagementPage({super.key});

  static const _centerPerformance = [
    ('Mumbai Central', 450, 1850000.0, 94.0, 4.8),
    ('Pune West', 320, 1420000.0, 91.0, 4.6),
    ('Delhi NCR', 580, 2480000.0, 93.0, 4.9),
    ('Bangalore South', 410, 1750000.0, 92.0, 4.7),
    ('Hyderabad', 280, 1200000.0, 89.0, 4.5),
  ];

  static const _monthly = [
    ('Jan', 420.0, 300.0, 550.0, 390.0),
    ('Feb', 435.0, 310.0, 565.0, 400.0),
    ('Mar', 440.0, 315.0, 570.0, 405.0),
    ('Apr', 445.0, 318.0, 575.0, 408.0),
    ('May', 450.0, 320.0, 580.0, 410.0),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Multi-Center Management',
          subtitle: 'Compare performance across multiple institute locations',
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
              childAspectRatio: cols == 1 ? 2.4 : 1.9,
              children: const [
                _GradientStat(
                  title: 'Total Centers',
                  value: '5',
                  subtitle: 'Active locations',
                  icon: Icons.apartment_outlined,
                  c1: Color(0xFF3B82F6),
                  c2: Color(0xFF2563EB),
                ),
                _GradientStat(
                  title: 'Total Enrollment',
                  value: '2,040',
                  subtitle: 'Students across centers',
                  icon: Icons.people_outline,
                  c1: Color(0xFF22C55E),
                  c2: Color(0xFF16A34A),
                ),
                _GradientStat(
                  title: 'Avg Growth',
                  value: '+12%',
                  subtitle: 'Month over month',
                  icon: Icons.trending_up,
                  c1: Color(0xFFA855F7),
                  c2: Color(0xFF7C3AED),
                ),
                _GradientStat(
                  title: 'Top Performer',
                  value: 'Delhi',
                  subtitle: 'Highest revenue',
                  icon: Icons.emoji_events_outlined,
                  c1: Color(0xFFF97316),
                  c2: Color(0xFFEA580C),
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
              children: [
                _ChartCard(
                  title: 'Revenue Comparison',
                  child: _RevenueBars(data: _centerPerformance),
                ),
                _ChartCard(
                  title: 'Student Enrollment Trend',
                  child: _EnrollmentLines(months: _monthly),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'Center Performance Metrics',
          child: SimpleDataTable(
            columns: const ['Center', 'Students', 'Revenue', 'Attendance', 'Rating'],
            rows: [
              for (final c in _centerPerformance)
                [
                  Row(
                    children: [
                      const Icon(Icons.apartment_outlined, size: 18, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 8),
                      Text(c.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Text('${c.$2}'),
                  Text('₹${(c.$3 / 100000).toStringAsFixed(1)}L', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
                  Row(
                    children: [
                      Text('${c.$4.toStringAsFixed(0)}%'),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: (c.$4 / 100).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: const Color(0xFFE5E7EB),
                            color: const Color(0xFF22C55E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.emoji_events_outlined, size: 16, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 6),
                      Text(c.$5.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GradientStat extends StatelessWidget {
  const _GradientStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.c1,
    required this.c2,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color c1;
  final Color c2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [c1, c2]),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(color: Color(0xFFE5E7EB)))),
              Icon(icon, color: const Color(0xFFE5E7EB)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Color(0xFFE5E7EB))),
        ],
      ),
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

class _RevenueBars extends StatelessWidget {
  const _RevenueBars({required this.data});
  final List<(String, int, double, double, double)> data;

  @override
  Widget build(BuildContext context) {
    final maxV = data.map((d) => d.$3).reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final d in data)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 240 * (d.$3 / maxV),
                        decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(d.$1, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _EnrollmentLines extends StatelessWidget {
  const _EnrollmentLines({required this.months});
  final List<(String, double, double, double, double)> months;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinesPainter(months: months),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              for (final m in months)
                Expanded(child: Center(child: Text(m.$1, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))))),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinesPainter extends CustomPainter {
  _LinesPainter({required this.months});
  final List<(String, double, double, double, double)> months;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final values = <double>[
      for (final m in months) ...[m.$2, m.$3, m.$4, m.$5]
    ];
    final minV = values.reduce((a, b) => a < b ? a : b);
    final maxV = values.reduce((a, b) => a > b ? a : b);
    final span = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);

    void draw(Color color, double Function((String, double, double, double, double)) pick) {
      final paint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      final path = Path();
      for (var i = 0; i < months.length; i++) {
        final x = i * size.width / (months.length - 1);
        final v = pick(months[i]);
        final t = (v - minV) / span;
        final y = size.height - (t * (size.height - 32)) - 6;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    draw(const Color(0xFF4F46E5), (m) => m.$2); // Mumbai
    draw(const Color(0xFF10B981), (m) => m.$3); // Pune
    draw(const Color(0xFFF59E0B), (m) => m.$4); // Delhi
    draw(const Color(0xFFEC4899), (m) => m.$5); // Bangalore
  }

  @override
  bool shouldRepaint(covariant _LinesPainter oldDelegate) => oldDelegate.months != months;
}

