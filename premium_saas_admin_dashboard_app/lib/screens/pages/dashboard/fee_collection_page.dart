import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/status_badge.dart';

class FeeCollectionPage extends StatelessWidget {
  const FeeCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Fee Collection',
          subtitle: '₹8.4L collected this week',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < DashboardData.feeCollections.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => context.push('/dashboard/fee-collection/$i'),
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE0E7FF),
                child: Text(
                  _initials(DashboardData.feeCollections[i].$1),
                  style: const TextStyle(
                    color: Color(0xFF4338CA),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(DashboardData.feeCollections[i].$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                '${DashboardData.feeCollections[i].$2} · ${DashboardData.feeCollections[i].$4} · ${DashboardData.feeCollections[i].$5}',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DashboardData.feeCollections[i].$3,
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
                  ),
                  const SizedBox(height: 4),
                  StatusBadge(status: DashboardData.feeCollections[i].$6),
                ],
              ),
              isThreeLine: true,
            ),
          ),
      ],
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}
