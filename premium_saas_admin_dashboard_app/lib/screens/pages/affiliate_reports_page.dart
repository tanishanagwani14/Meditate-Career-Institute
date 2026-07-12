import 'package:flutter/material.dart';

import '../../widgets/shared/filter_bar.dart';
import '../../widgets/shared/kpi_card.dart';
import '../../widgets/shared/page_header.dart';
import '../../widgets/shared/simple_data_table.dart';
import '../../widgets/shared/status_badge.dart';

class AffiliateReportsPage extends StatelessWidget {
  const AffiliateReportsPage({super.key});

  static const _affiliates = [
    (1, 'StudyBuddy Platform', 'Rohan Gupta', 45, 28, '₹12.6L', '₹1.26L', 'active'),
    (2, 'EduConnect Network', 'Priya Mehta', 38, 22, '₹9.9L', '₹99K', 'active'),
    (3, 'CareerGuidance Portal', 'Amit Sharma', 52, 35, '₹15.8L', '₹1.58L', 'active'),
    (4, 'SchoolConnect', 'Kavita Reddy', 30, 18, '₹8.1L', '₹81K', 'active'),
    (5, 'TestPrep Hub', 'Vikram Joshi', 25, 15, '₹6.8L', '₹68K', 'pending'),
  ];

  static const _conversion = [
    ('Converted', 118, Color(0xFF10B981)),
    ('Pending', 72, Color(0xFFF59E0B)),
  ];

  @override
  Widget build(BuildContext context) {
    final totalReferrals = _affiliates.fold<int>(0, (acc, a) => acc + a.$4);
    final totalConversions = _affiliates.fold<int>(0, (acc, a) => acc + a.$5);
    final activeCount = _affiliates.where((a) => a.$8 == 'active').length;
    final avgConversionRate = totalReferrals == 0 ? 0 : ((totalConversions / totalReferrals) * 100).round();

    double totalCommissionL = 0;
    for (final a in _affiliates) {
      totalCommissionL += _parseCommissionToLakh(a.$7);
    }

    final top3 = [..._affiliates]..sort((a, b) => b.$5.compareTo(a.$5));
    final top = top3.take(3).toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Affiliate Reports',
          subtitle: 'Track affiliate partner performance and commissions',
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
                  title: 'Total Referrals',
                  value: '$totalReferrals',
                  change: 'This month',
                  changeType: ChangeType.neutral,
                  icon: Icons.people_outline,
                  iconBg: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Conversions',
                  value: '$totalConversions',
                  change: '$avgConversionRate% conversion rate',
                  changeType: ChangeType.positive,
                  icon: Icons.trending_up,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                ),
                KpiCard(
                  title: 'Total Commission',
                  value: '₹${totalCommissionL.toStringAsFixed(1)}L',
                  change: 'To be paid',
                  changeType: ChangeType.neutral,
                  icon: Icons.currency_rupee,
                  iconBg: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF9333EA),
                ),
                KpiCard(
                  title: 'Active Partners',
                  value: '$activeCount',
                  change: 'Partnerships',
                  changeType: ChangeType.positive,
                  icon: Icons.emoji_events_outlined,
                  iconBg: const Color(0xFFFFEDD5),
                  iconColor: const Color(0xFFEA580C),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final is3 = c.maxWidth >= 1100;
            if (!is3) {
              return Column(
                children: [
                  const FilterBar(searchPlaceholder: 'Search affiliate partners...'),
                  const SizedBox(height: 16),
                  _AffiliatesTable(affiliates: _affiliates),
                  const SizedBox(height: 16),
                  _SideCards(conversion: _conversion, top: top),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      const FilterBar(searchPlaceholder: 'Search affiliate partners...'),
                      const SizedBox(height: 16),
                      _AffiliatesTable(affiliates: _affiliates),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: _SideCards(conversion: _conversion, top: top)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _AffiliatesTable extends StatelessWidget {
  const _AffiliatesTable({required this.affiliates});
  final List<(int, String, String, int, int, String, String, String)> affiliates;

  @override
  Widget build(BuildContext context) {
    return SimpleDataTable(
      columns: const ['Affiliate Partner', 'Total Referrals', 'Conversions', 'Revenue Generated', 'Commission', 'Status', 'Actions'],
      rows: [
        for (final a in affiliates)
          [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.link, color: Color(0xFF4F46E5)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(a.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 16, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 6),
                Text('${a.$4}', style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${a.$5}', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
                Text('${a.$4 == 0 ? 0 : ((a.$5 / a.$4) * 100).round()}% rate', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
              ],
            ),
            Text(a.$6, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(a.$7, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
            StatusBadge(status: a.$8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
              child: const Text('View Details'),
            ),
          ],
      ],
    );
  }
}

class _SideCards extends StatelessWidget {
  const _SideCards({required this.conversion, required this.top});
  final List<(String, int, Color)> conversion;
  final List<(int, String, String, int, int, String, String, String)> top;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Conversion Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                SizedBox(height: 200, child: _Pie(conversion: conversion)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Top Performers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (var i = 0; i < top.length; i++) ...[
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
                          child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(top[i].$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text('${top[i].$5} conversions', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                            ],
                          ),
                        ),
                        const Icon(Icons.emoji_events_outlined, color: Color(0xFFF59E0B)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Pie extends StatelessWidget {
  const _Pie({required this.conversion});
  final List<(String, int, Color)> conversion;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PiePainter(conversion: conversion),
      child: Center(
        child: Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            for (final c in conversion)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: c.$3, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text('${c.$1}: ${c.$2}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter({required this.conversion});
  final List<(String, int, Color)> conversion;

  @override
  void paint(Canvas canvas, Size size) {
    final total = conversion.fold<int>(0, (acc, c) => acc + c.$2);
    final rect = Rect.fromCircle(center: size.center(Offset.zero), radius: (size.shortestSide / 2) - 16);
    var start = -1.57079632679; // -pi/2
    for (final c in conversion) {
      final sweep = total == 0 ? 0.0 : (c.$2 / total) * 6.28318530718;
      canvas.drawArc(rect, start, sweep, true, Paint()..color = c.$3);
      start += sweep;
    }
    canvas.drawCircle(rect.center, rect.shortestSide * 0.22, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _PiePainter oldDelegate) => oldDelegate.conversion != conversion;
}

double _parseCommissionToLakh(String s) {
  final cleaned = s.replaceAll('₹', '').replaceAll(',', '').trim();
  if (cleaned.endsWith('L')) {
    return double.parse(cleaned.substring(0, cleaned.length - 1));
  }
  if (cleaned.endsWith('K')) {
    return double.parse(cleaned.substring(0, cleaned.length - 1)) / 100.0;
  }
  return double.tryParse(cleaned) ?? 0;
}

