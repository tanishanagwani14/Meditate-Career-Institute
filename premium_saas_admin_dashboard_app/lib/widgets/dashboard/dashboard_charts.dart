import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Revenue (₹ thousands) and student count by month.
const revenueStudentData = [
  (month: 'Jan', revenue: 45.0, students: 120.0),
  (month: 'Feb', revenue: 52.0, students: 145.0),
  (month: 'Mar', revenue: 48.0, students: 138.0),
  (month: 'Apr', revenue: 61.0, students: 165.0),
  (month: 'May', revenue: 55.0, students: 152.0),
  (month: 'Jun', revenue: 67.0, students: 178.0),
];

const enrollmentSlices = [
  (label: 'JEE Preparation', value: 450.0, color: Color(0xFF4F46E5)),
  (label: 'NEET Coaching', value: 380.0, color: Color(0xFF7C3AED)),
  (label: 'Foundation', value: 290.0, color: Color(0xFFEC4899)),
  (label: 'Skill Development', value: 180.0, color: Color(0xFFF59E0B)),
];

const performanceBars = [
  (label: 'Attendance', value: 92.0),
  (label: 'Assignment Submission', value: 85.0),
  (label: 'Test Performance', value: 78.0),
  (label: 'Parent Engagement', value: 68.0),
];

class RevenueStudentGrowthChart extends StatelessWidget {
  const RevenueStudentGrowthChart({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _LegendDot(color: const Color(0xFF4F46E5), label: 'Revenue (₹K)', muted: muted),
            const SizedBox(width: 16),
            _LegendDot(color: const Color(0xFF10B981), label: 'Students', muted: muted),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: CustomPaint(
            painter: _DualLineChartPainter(
              revenueStudentData,
              revenueColor: const Color(0xFF4F46E5),
              studentsColor: const Color(0xFF10B981),
              gridColor: Theme.of(context).dividerColor,
              labelColor: muted ?? Colors.grey,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }
}

class CourseEnrollmentChart extends StatelessWidget {
  const CourseEnrollmentChart({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: CustomPaint(
            painter: _DonutChartPainter(enrollmentSlices),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final s in enrollmentSlices)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(s.label, style: TextStyle(fontSize: 12, color: muted), overflow: TextOverflow.ellipsis),
                      ),
                      Text('${s.value.toInt()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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

class PerformanceMetricsChart extends StatelessWidget {
  const PerformanceMetricsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;
    return Column(
      children: [
        for (final bar in performanceBars)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(bar.label, style: TextStyle(fontSize: 12, color: muted), overflow: TextOverflow.ellipsis),
                    ),
                    Text('${bar.value.toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: bar.value / 100,
                    minHeight: 8,
                    backgroundColor: primary.withValues(alpha: 0.08),
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label, this.muted});
  final Color color;
  final String label;
  final Color? muted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, color: muted)),
      ],
    );
  }
}

class _DualLineChartPainter extends CustomPainter {
  _DualLineChartPainter(
    this.data, {
    required this.revenueColor,
    required this.studentsColor,
    required this.gridColor,
    required this.labelColor,
  });

  final List<({String month, double revenue, double students})> data;
  final Color revenueColor;
  final Color studentsColor;
  final Color gridColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const leftPad = 8.0;
    const bottomPad = 22.0;
    const topPad = 8.0;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad - topPad;

    final maxRev = data.map((e) => e.revenue).reduce(math.max);
    final maxStu = data.map((e) => e.students).reduce(math.max);

    for (var i = 0; i <= 3; i++) {
      final y = topPad + chartH * i / 3;
      canvas.drawLine(Offset(leftPad, y), Offset(size.width, y), Paint()..color = gridColor.withValues(alpha: 0.5));
    }

    final stepX = chartW / (data.length - 1);

    Offset point(int i, double v, double maxV) {
      final x = leftPad + stepX * i;
      final y = topPad + chartH - (v / maxV) * chartH;
      return Offset(x, y);
    }

    void drawLine(Color color, double Function(({String month, double revenue, double students}) e) getter, double maxV) {
      final path = Path();
      for (var i = 0; i < data.length; i++) {
        final p = point(i, getter(data[i]), maxV);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
      for (var i = 0; i < data.length; i++) {
        final p = point(i, getter(data[i]), maxV);
        canvas.drawCircle(p, 4, Paint()..color = color);
      }
    }

    drawLine(revenueColor, (e) => e.revenue, maxRev);
    drawLine(studentsColor, (e) => e.students, maxStu);

    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < data.length; i++) {
      tp.text = TextSpan(text: data[i].month, style: TextStyle(fontSize: 10, color: labelColor));
      tp.layout();
      final x = leftPad + stepX * i - tp.width / 2;
      tp.paint(canvas, Offset(x.clamp(0, size.width - tp.width), size.height - bottomPad + 4));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter(this.slices);
  final List<({String label, double value, Color color})> slices;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<double>(0, (s, e) => s + e.value);
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.85;
    var start = -math.pi / 2;

    for (final slice in slices) {
      final sweep = 2 * math.pi * (slice.value / total);
      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.45
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.775),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
