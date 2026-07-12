import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';

/// Lightweight chart placeholders matching Recharts layout (no extra deps).
class SimpleAreaChart extends StatelessWidget {
  const SimpleAreaChart({
    super.key,
    required this.points,
    this.lineColor = EnterpriseTheme.indigo600,
    this.height = 280,
  });

  final List<({String label, double value})> points;
  final Color lineColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _AreaPainter(points: points, lineColor: lineColor),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _AreaPainter extends CustomPainter {
  _AreaPainter({required this.points, required this.lineColor});

  final List<({String label, double value})> points;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    final maxY = points.map((e) => e.value).reduce(math.max) * 1.1;
    final padL = 36.0;
    final padR = 12.0;
    final padT = 12.0;
    final padB = 28.0;
    final w = size.width - padL - padR;
    final h = size.height - padT - padB;

    final gridPaint = Paint()
      ..color = EnterpriseTheme.gray200
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = padT + h * i / 4;
      canvas.drawLine(Offset(padL, y), Offset(padL + w, y), gridPaint..strokeWidth = i == 4 ? 1 : 0.5);
    }

    final path = Path();
    final fillPath = Path();
    for (var i = 0; i < points.length; i++) {
      final x = padL + w * i / (points.length - 1).clamp(1, 999);
      final y = padT + h * (1 - points[i].value / maxY);
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, padT + h);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(padL + w, padT + h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.25),
          lineColor.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(padL, padT, w, h));
    canvas.drawPath(fillPath, fillPaint);

    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..isAntiAlias = true,
    );

    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < points.length; i++) {
      final x = padL + w * i / (points.length - 1).clamp(1, 999);
      tp.text = TextSpan(
        text: points[i].label,
        style: const TextStyle(fontSize: 11, color: EnterpriseTheme.gray500),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, padT + h + 4));
    }
  }

  @override
  bool shouldRepaint(covariant _AreaPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.lineColor != lineColor;
}

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.bars,
    this.barColor = const Color(0xFF8B5CF6),
    this.height = 280,
  });

  final List<({String label, double value})> bars;
  final Color barColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarPainter(bars: bars, barColor: barColor),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({required this.bars, required this.barColor});

  final List<({String label, double value})> bars;
  final Color barColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    final maxY = bars.map((e) => e.value).reduce(math.max) * 1.15;
    final padL = 36.0;
    final padB = 28.0;
    final padT = 12.0;
    final w = size.width - padL - 16;
    final h = size.height - padT - padB;
    final gap = 8.0;
    final barW = (w - gap * (bars.length + 1)) / bars.length;

    for (var i = 0; i < bars.length; i++) {
      final x = padL + gap + i * (barW + gap);
      final bh = h * bars[i].value / maxY;
      final r = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, padT + h - bh, barW, bh),
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      );
      canvas.drawRRect(r, Paint()..color = barColor);

      final tp = TextPainter(
        text: TextSpan(
          text: bars[i].label,
          style: const TextStyle(fontSize: 11, color: EnterpriseTheme.gray500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x + barW / 2 - tp.width / 2, padT + h + 4));
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      oldDelegate.bars != bars || oldDelegate.barColor != barColor;
}

class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({
    super.key,
    required this.series,
    this.height = 280,
    this.colorA = EnterpriseTheme.indigo600,
    this.colorB = const Color(0xFFEF4444),
  });

  final List<({String label, double a, double b})> series;
  final double height;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _DualLinePainter(series: series, colorA: colorA, colorB: colorB),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _DualLinePainter extends CustomPainter {
  _DualLinePainter({
    required this.series,
    required this.colorA,
    required this.colorB,
  });

  final List<({String label, double a, double b})> series;
  final Color colorA;
  final Color colorB;

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;
    final maxY = series
        .map((e) => math.max(e.a, e.b))
        .reduce(math.max)
        .clamp(1.0, double.infinity) * 1.1;
    final padL = 40.0;
    final padT = 12.0;
    final padB = 28.0;
    final w = size.width - padL - 12;
    final h = size.height - padT - padB;

    void drawLine(List<double> vals, Color color) {
      final path = Path();
      for (var i = 0; i < vals.length; i++) {
        final x = padL + w * i / (vals.length - 1).clamp(1, 999);
        final y = padT + h * (1 - vals[i] / maxY);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..isAntiAlias = true,
      );
    }

    drawLine(series.map((e) => e.a).toList(), colorA);
    drawLine(series.map((e) => e.b).toList(), colorB);

    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < series.length; i++) {
      final x = padL + w * i / (series.length - 1).clamp(1, 999);
      tp.text = TextSpan(
        text: series[i].label,
        style: const TextStyle(fontSize: 10, color: EnterpriseTheme.gray500),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, padT + h + 2));
    }
  }

  @override
  bool shouldRepaint(covariant _DualLinePainter oldDelegate) =>
      oldDelegate.series != series ||
      oldDelegate.colorA != colorA ||
      oldDelegate.colorB != colorB;
}

class SimpleDonutLegend extends StatelessWidget {
  const SimpleDonutLegend({
    super.key,
    required this.items,
    this.size = 160,
  });

  final List<({String name, double value, Color color})> items;
  final double size;

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (s, e) => s + e.value);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DonutPainter(items: items, total: total),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final i in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: i.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          i.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: EnterpriseTheme.gray600,
                          ),
                        ),
                      ),
                      Text(
                        '${i.value.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: EnterpriseTheme.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.items, required this.total});

  final List<({String name, double value, Color color})> items;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final outer = math.min(size.width, size.height) / 2;
    final inner = outer * 0.72;
    var start = -math.pi / 2;
    for (final item in items) {
      final sweep = (item.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = outer - inner
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: (outer + inner) / 2),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.items != items || oldDelegate.total != total;
}
