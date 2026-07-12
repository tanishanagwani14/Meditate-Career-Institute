import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/fees_data.dart';
import '../../../../widgets/shared/page_header.dart';
import '../../../../widgets/shared/status_badge.dart';

enum FeeMetric { collected, pending, overdue, rate }

class FeesKpiListPage extends StatelessWidget {
  const FeesKpiListPage({super.key, required this.metric});

  final FeeMetric metric;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    final filtered = switch (metric) {
      FeeMetric.collected => FeesData.records.where((r) => r.status == 'paid').toList(),
      FeeMetric.pending => FeesData.records.where((r) => r.status == 'pending').toList(),
      FeeMetric.overdue => FeesData.records.where((r) => r.status == 'overdue').toList(),
      FeeMetric.rate => FeesData.records,
    };

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: _title,
            subtitle: _subtitle,
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 16),
          if (metric == FeeMetric.rate)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Collection rate', style: TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text(
                            '${FeesData.collectionRate.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text('Based on current records', style: TextStyle(color: muted)),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: FeesData.collectionRate / 100,
                          minHeight: 10,
                          backgroundColor: const Color(0xFFE5E7EB),
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < filtered.length; i++) ...[
                  ListTile(
                    title: Text(filtered[i].studentName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${filtered[i].course} · ${filtered[i].batch}', style: TextStyle(color: muted)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatusBadge(
                          status: filtered[i].status == 'paid'
                              ? 'completed'
                              : (filtered[i].status == 'pending' ? 'pending' : 'overdue'),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      final index = FeesData.records.indexOf(filtered[i]);
                      context.push('/students/fees/student/$index');
                    },
                  ),
                  if (i != filtered.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _title => switch (metric) {
        FeeMetric.collected => 'Total Collected',
        FeeMetric.pending => 'Pending Collection',
        FeeMetric.overdue => 'Overdue Payments',
        FeeMetric.rate => 'Collection Rate',
      };

  String get _subtitle => switch (metric) {
        FeeMetric.collected => 'Students who have paid',
        FeeMetric.pending => 'Payments pending before due date',
        FeeMetric.overdue => 'Payments past due date',
        FeeMetric.rate => 'Overall payment performance',
      };
}

