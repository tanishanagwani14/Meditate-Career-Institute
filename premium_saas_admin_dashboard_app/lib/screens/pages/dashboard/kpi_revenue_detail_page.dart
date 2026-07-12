import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';

class KpiRevenueDetailPage extends StatelessWidget {
  const KpiRevenueDetailPage({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final item = DashboardData.monthlyRevenueAt(index);

    if (item == null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Revenue Detail',
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Revenue record not found')),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: item.title,
          subtitle: '${item.amount} · ${item.period}',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.currency_rupee, color: Color(0xFF16A34A), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.amount,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(item.students, style: TextStyle(color: muted)),
                      const SizedBox(height: 8),
                      Text(item.body, style: TextStyle(color: muted, height: 1.45)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Breakdown', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                for (final d in item.details)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 140,
                          child: Text(d.$1, style: TextStyle(color: muted, fontSize: 13)),
                        ),
                        Expanded(
                          child: Text(
                            d.$2,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
