import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/shared/page_header.dart';

class FeeReportsPage extends StatelessWidget {
  const FeeReportsPage({super.key});

  static const _monthly = [
    ('Jan', 850000.0, 900000.0),
    ('Feb', 920000.0, 950000.0),
    ('Mar', 880000.0, 900000.0),
    ('Apr', 1050000.0, 1100000.0),
    ('May', 670000.0, 1200000.0),
  ];

  static const _courseRevenue = [
    ('JEE Advanced', 2250000.0),
    ('NEET', 1920000.0),
    ('Foundation', 875000.0),
    ('JEE Mains', 1575000.0),
    ('Skill Dev', 450000.0),
  ];

  static const _modes = [
    ('UPI', 3200000.0, 45),
    ('Net Banking', 2400000.0, 34),
    ('Card', 1200000.0, 17),
    ('Cash', 270000.0, 4),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Fee Reports & Analytics',
          subtitle: 'Comprehensive financial analysis and revenue insights',
          action: FilledButton.icon(
            onPressed: () async {
              final csv = _exportCsv();
              await Clipboard.setData(ClipboardData(text: csv));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fee report exported to clipboard (CSV)')),
                );
              }
            },
            icon: const Icon(Icons.download, size: 18),
            label: const Text('Export Report'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
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
                  title: 'Total Revenue',
                  value: '₹70.7L',
                  subtitle: 'Last 5 months',
                  c1: Color(0xFF22C55E),
                  c2: Color(0xFF16A34A),
                ),
                _GradientStat(
                  title: 'This Month',
                  value: '₹6.7L',
                  subtitle: '56% of target',
                  c1: Color(0xFF3B82F6),
                  c2: Color(0xFF2563EB),
                ),
                _GradientStat(
                  title: 'Collection Rate',
                  value: '92%',
                  subtitle: 'Outstanding 8%',
                  c1: Color(0xFFA855F7),
                  c2: Color(0xFF7C3AED),
                ),
                _GradientStat(
                  title: 'Pending',
                  value: '₹5.3L',
                  subtitle: 'Expected soon',
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
                  title: 'Revenue Trend',
                  child: _RevenueTrend(months: _monthly),
                ),
                _ChartCard(
                  title: 'Course-wise Revenue',
                  child: _CourseBars(data: _courseRevenue),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _ChartCard(
          title: 'Payment Mode Distribution',
          child: _PaymentModes(modes: _modes),
        ),
      ],
    );
  }

  String _exportCsv() {
    String esc(String v) {
      final needs = v.contains(',') || v.contains('"') || v.contains('\n');
      final s = v.replaceAll('"', '""');
      return needs ? '"$s"' : s;
    }

    final lines = <String>['Month,Collected,Target'];
    for (final m in _monthly) {
      lines.add([esc(m.$1), m.$2.toStringAsFixed(0), m.$3.toStringAsFixed(0)].join(','));
    }
    return lines.join('\n');
  }
}

class _GradientStat extends StatelessWidget {
  const _GradientStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.c1,
    required this.c2,
  });

  final String title;
  final String value;
  final String subtitle;
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
              const Icon(Icons.trending_up, color: Color(0xFFE5E7EB)),
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

class _RevenueTrend extends StatelessWidget {
  const _RevenueTrend({required this.months});
  final List<(String, double, double)> months;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrendPainter(months: months),
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

class _TrendPainter extends CustomPainter {
  _TrendPainter({required this.months});
  final List<(String, double, double)> months;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final maxV = months.map((m) => m.$2 > m.$3 ? m.$2 : m.$3).reduce((a, b) => a > b ? a : b);
    final minV = months.map((m) => m.$2 < m.$3 ? m.$2 : m.$3).reduce((a, b) => a < b ? a : b);
    final span = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);

    void drawLine(Color color, bool dashed, double Function((String, double, double)) pick) {
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

      if (!dashed) {
        canvas.drawPath(path, paint);
        return;
      }

      // simple dashed effect
      const dash = 8.0;
      const gap = 6.0;
      final metrics = path.computeMetrics().toList(growable: false);
      for (final m in metrics) {
        var dist = 0.0;
        while (dist < m.length) {
          final seg = m.extractPath(dist, (dist + dash).clamp(0.0, m.length));
          canvas.drawPath(seg, paint);
          dist += dash + gap;
        }
      }
    }

    drawLine(const Color(0xFF10B981), false, (m) => m.$2);
    drawLine(const Color(0xFF6B7280), true, (m) => m.$3);
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) => oldDelegate.months != months;
}

class _CourseBars extends StatelessWidget {
  const _CourseBars({required this.data});
  final List<(String, double)> data;

  @override
  Widget build(BuildContext context) {
    final maxV = data.map((d) => d.$2).reduce((a, b) => a > b ? a : b);
    return Row(
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
                      child: Container(
                        height: 240 * (d.$2 / maxV),
                        decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(10)),
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
    );
  }
}

class _PaymentModes extends StatelessWidget {
  const _PaymentModes({required this.modes});
  final List<(String, double, int)> modes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final m in modes) ...[
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(m.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Text('₹${(m.$2 / 100000).toStringAsFixed(1)}L', style: const TextStyle(color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              Text('${m.$3}%', style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: (m.$3 / 100.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              color: const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

