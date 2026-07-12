import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/shared/page_header.dart';

class StudentReportsPage extends StatelessWidget {
  const StudentReportsPage({super.key});

  static const _performance = [
    ('Physics', 85.0, 95.0, 62.0),
    ('Chemistry', 78.0, 92.0, 58.0),
    ('Mathematics', 82.0, 98.0, 65.0),
    ('Biology', 88.0, 96.0, 70.0),
  ];

  static const _progress = [
    ('Jan', 72.0),
    ('Feb', 75.0),
    ('Mar', 78.0),
    ('Apr', 81.0),
    ('May', 84.0),
  ];

  static const _top = [
    (1, 'Aarav Sharma', 95.5, 'JEE Advanced'),
    (2, 'Diya Patel', 94.2, 'NEET'),
    (3, 'Ananya Singh', 92.8, 'JEE Mains'),
    (4, 'Reyansh Joshi', 91.5, 'JEE Advanced'),
    (5, 'Saanvi Gupta', 90.3, 'Foundation'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Student Reports & Analytics',
          subtitle: 'Comprehensive performance analysis and insights',
          action: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Export Reports'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
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
              // Taller on 1-col layouts to prevent bottom overflow.
              childAspectRatio: is2 ? 1.65 : 1.10,
              children: [
                _ChartCard(
                  title: 'Subject-wise Performance',
                  onTap: () => context.push('/students/reports/subjects'),
                  child: _GroupedBars(
                    labels: _performance.map((e) => e.$1).toList(growable: false),
                    series: [
                      _BarSeries('Average', const Color(0xFF4F46E5), _performance.map((e) => e.$2).toList(growable: false)),
                      _BarSeries('Top Score', const Color(0xFF10B981), _performance.map((e) => e.$3).toList(growable: false)),
                      _BarSeries('Lowest', const Color(0xFFEF4444), _performance.map((e) => e.$4).toList(growable: false)),
                    ],
                  ),
                ),
                _ChartCard(
                  title: 'Progress Over Time',
                  onTap: () => context.push('/students/reports/progress'),
                  child: _LineMiniChart(
                    points: _progress.map((e) => e.$2).toList(growable: false),
                    labels: _progress.map((e) => e.$1).toList(growable: false),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final is2 = c.maxWidth >= 950;
            final topCard = _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.emoji_events_outlined, color: Color(0xFFF59E0B)),
                      SizedBox(width: 8),
                      Text('Top Performers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (!is2)
                    for (final s in _top) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: Color(0xFF4F46E5), shape: BoxShape.circle),
                              child: Text('${s.$1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text(s.$4, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                                ],
                              ),
                            ),
                            Text(
                              '${s.$3}%',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: _top.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final s = _top[i];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(color: Color(0xFF4F46E5), shape: BoxShape.circle),
                                  child: Text('${s.$1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      Text(s.$4, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${s.$3}%',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );

            final insightsCard = _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.trending_up, color: Color(0xFF22C55E)),
                      SizedBox(width: 8),
                      Text('Key Insights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (!is2) ...[
                    _Insight(
                      icon: Icons.menu_book_outlined,
                      iconColor: Color(0xFF16A34A),
                      bg: Color(0xFFECFDF5),
                      border: Color(0xFFBBF7D0),
                      title: 'Strong Biology Performance',
                      body: 'Students showing 12% improvement in biology with 88% average score',
                      titleColor: Color(0xFF14532D),
                      bodyColor: Color(0xFF15803D),
                      onTap: () => context.push('/students/reports/insights/0'),
                    ),
                    const SizedBox(height: 12),
                    _Insight(
                      icon: Icons.trending_up,
                      iconColor: Color(0xFFCA8A04),
                      bg: Color(0xFFFFFBEB),
                      border: Color(0xFFFDE68A),
                      title: 'Chemistry Needs Attention',
                      body: 'Consider additional workshops for chemistry topics',
                      titleColor: Color(0xFF713F12),
                      bodyColor: Color(0xFFB45309),
                      onTap: () => context.push('/students/reports/insights/1'),
                    ),
                    const SizedBox(height: 12),
                    _Insight(
                      icon: Icons.emoji_events_outlined,
                      iconColor: Color(0xFF2563EB),
                      bg: Color(0xFFEFF6FF),
                      border: Color(0xFFBFDBFE),
                      title: 'Overall Progress Trend',
                      body: 'Consistent 3-4% month-over-month improvement across all batches',
                      titleColor: Color(0xFF1E3A8A),
                      bodyColor: Color(0xFF1D4ED8),
                      onTap: () => context.push('/students/reports/insights/2'),
                    ),
                  ] else
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          _Insight(
                            icon: Icons.menu_book_outlined,
                            iconColor: Color(0xFF16A34A),
                            bg: Color(0xFFECFDF5),
                            border: Color(0xFFBBF7D0),
                            title: 'Strong Biology Performance',
                            body: 'Students showing 12% improvement in biology with 88% average score',
                            titleColor: Color(0xFF14532D),
                            bodyColor: Color(0xFF15803D),
                            onTap: () => context.push('/students/reports/insights/0'),
                          ),
                          const SizedBox(height: 12),
                          _Insight(
                            icon: Icons.trending_up,
                            iconColor: Color(0xFFCA8A04),
                            bg: Color(0xFFFFFBEB),
                            border: Color(0xFFFDE68A),
                            title: 'Chemistry Needs Attention',
                            body: 'Consider additional workshops for chemistry topics',
                            titleColor: Color(0xFF713F12),
                            bodyColor: Color(0xFFB45309),
                            onTap: () => context.push('/students/reports/insights/1'),
                          ),
                          const SizedBox(height: 12),
                          _Insight(
                            icon: Icons.emoji_events_outlined,
                            iconColor: Color(0xFF2563EB),
                            bg: Color(0xFFEFF6FF),
                            border: Color(0xFFBFDBFE),
                            title: 'Overall Progress Trend',
                            body: 'Consistent 3-4% month-over-month improvement across all batches',
                            titleColor: Color(0xFF1E3A8A),
                            bodyColor: Color(0xFF1D4ED8),
                            onTap: () => context.push('/students/reports/insights/2'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );

            if (!is2) {
              return Column(
                children: [
                  topCard,
                  const SizedBox(height: 16),
                  insightsCard,
                ],
              );
            }

            return SizedBox(
              height: 420,
              child: Row(
                children: [
                  Expanded(child: topCard),
                  const SizedBox(width: 16),
                  Expanded(child: insightsCard),
                ],
              ),
            );
          },
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
  const _ChartCard({required this.title, required this.child, this.onTap});
  final String title;
  final Widget child;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                  if (onTap != null) const Icon(Icons.chevron_right, size: 18, color: Color(0xFF9CA3AF)),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _Insight extends StatelessWidget {
  const _Insight({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.border,
    required this.title,
    required this.body,
    required this.titleColor,
    required this.bodyColor,
    this.onTap,
  });
  final IconData icon;
  final Color iconColor;
  final Color bg;
  final Color border;
  final String title;
  final String body;
  final Color titleColor;
  final Color bodyColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12), border: Border.all(color: border)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: titleColor)),
                    const SizedBox(height: 4),
                    Text(body, style: TextStyle(color: bodyColor)),
                  ],
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: bodyColor),
              ],
            ],
          ),
        ),
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

class _LineMiniChart extends StatelessWidget {
  const _LineMiniChart({required this.points, required this.labels});
  final List<double> points;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LinePainter(points: points),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              for (final l in labels)
                Expanded(child: Center(child: Text(l, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))))),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({required this.points});
  final List<double> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4F46E5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final grid = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final minV = points.reduce((a, b) => a < b ? a : b);
    final maxV = points.reduce((a, b) => a > b ? a : b);
    final span = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final t = (points[i] - minV) / span;
      final y = size.height - (t * (size.height - 32)) - 6;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 4.5, Paint()..color = const Color(0xFF4F46E5));
      canvas.drawCircle(Offset(x, y), 8, Paint()..color = const Color(0x334F46E5));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) => oldDelegate.points != points;
}

