import 'dart:math';

import 'package:flutter/material.dart';

import '../../../widgets/shared/page_header.dart';

class TeacherPerformancePage extends StatelessWidget {
  const TeacherPerformancePage({super.key});

  static const _performance = [
    ('Dr. Rajesh', 4.8, 95.0, 92.0, 88.0),
    ('Prof. Meera', 4.9, 98.0, 96.0, 94.0),
    ('Dr. Amit', 4.7, 90.0, 88.0, 85.0),
    ('Mrs. Priya', 4.6, 93.0, 90.0, 87.0),
  ];

  static const _radar = [
    ('Student Rating', 4.8),
    ('Course Completion', 94.0),
    ('Attendance Rate', 91.0),
    ('Engagement', 88.0),
    ('Content Quality', 92.0),
    ('Communication', 90.0),
  ];

  static const _achievements = [
    ('Prof. Meera Iyer', 'Best Teacher Award 2026', Icons.emoji_events_outlined, Color(0xFFFEF9C3), Color(0xFFA16207)),
    ('Dr. Rajesh Singh', '100% Student Satisfaction', Icons.people_outline, Color(0xFFDCFCE7), Color(0xFF15803D)),
    ('Mrs. Priya Sharma', 'Highest Course Completion Rate', Icons.menu_book_outlined, Color(0xFFDBEAFE), Color(0xFF1D4ED8)),
    ('Dr. Amit Kumar', 'Most Improved Performance', Icons.trending_up, Color(0xFFF3E8FF), Color(0xFF6B21A8)),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Teacher Performance Analytics',
          subtitle: 'Track and analyze faculty performance metrics',
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
                  title: 'Overall Performance Metrics',
                  child: _GroupedBars(
                    labels: _performance.map((e) => e.$1).toList(growable: false),
                    series: [
                      _BarSeries('Course Completion %', const Color(0xFF4F46E5), _performance.map((e) => e.$3).toList(growable: false)),
                      _BarSeries('Attendance %', const Color(0xFF10B981), _performance.map((e) => e.$4).toList(growable: false)),
                      _BarSeries('Engagement %', const Color(0xFFF59E0B), _performance.map((e) => e.$5).toList(growable: false)),
                    ],
                  ),
                ),
                _ChartCard(
                  title: 'Performance Radar',
                  child: _RadarChart(values: _radar),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Recent Achievements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, c) {
                  final cols = c.maxWidth >= 950 ? 2 : 1;
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: cols,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: cols == 1 ? 3.2 : 3.6,
                    children: [
                      for (final a in _achievements)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: a.$4, borderRadius: BorderRadius.circular(12)),
                                child: Icon(a.$3, color: a.$5),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(a.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(a.$2, style: const TextStyle(color: Color(0xFF4B5563))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: child));
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BarSeries {
  const _BarSeries(this.name, this.color, this.values);
  final String name;
  final Color color;
  final List<double> values;
}

class _GroupedBars extends StatelessWidget {
  const _GroupedBars({required this.labels, required this.series});
  final List<String> labels;
  final List<_BarSeries> series;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (final s in series)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Container(
                                        height: 2.6 * s.values[i],
                                        decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(labels[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
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
          runSpacing: 8,
          children: [
            for (final s in series)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text(s.name, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              )
          ],
        ),
      ],
    );
  }
}

class _RadarChart extends StatelessWidget {
  const _RadarChart({required this.values});
  final List<(String, double)> values;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadarPainter(values: values),
      child: const SizedBox.expand(),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.values});
  final List<(String, double)> values;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 12;
    final spokes = values.length;

    final grid = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final fill = Paint()
      ..color = const Color(0x994F46E5)
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = const Color(0xFF4F46E5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var ring = 1; ring <= 4; ring++) {
      final r = radius * (ring / 4);
      final path = Path();
      for (var i = 0; i < spokes; i++) {
        final a = -pi / 2 + (2 * pi * i / spokes);
        final p = center + Offset(cos(a) * r, sin(a) * r);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      path.close();
      canvas.drawPath(path, grid);
    }

    for (var i = 0; i < spokes; i++) {
      final a = -pi / 2 + (2 * pi * i / spokes);
      final p = center + Offset(cos(a) * radius, sin(a) * radius);
      canvas.drawLine(center, p, grid);
    }

    final path = Path();
    for (var i = 0; i < spokes; i++) {
      final a = -pi / 2 + (2 * pi * i / spokes);
      final v = values[i].$2;
      final t = (v <= 5.0) ? (v / 5.0) : (v / 100.0);
      final r = radius * t.clamp(0.0, 1.0);
      final p = center + Offset(cos(a) * r, sin(a) * r);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawCircle(p, 4, Paint()..color = const Color(0xFF4F46E5));
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => oldDelegate.values != values;
}

