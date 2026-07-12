import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';

class KpiMonthlyRevenuePage extends StatelessWidget {
  const KpiMonthlyRevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Monthly Revenue',
          subtitle: '₹6.7L total this month',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < DashboardData.monthlyRevenue.length; i++)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              onTap: () => context.push('/dashboard/kpi/revenue/$i'),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.currency_rupee, color: Color(0xFF16A34A)),
              ),
              title: Text(
                DashboardData.monthlyRevenue[i].title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${DashboardData.monthlyRevenue[i].students} · ${DashboardData.monthlyRevenue[i].period}',
                style: TextStyle(color: muted, fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DashboardData.monthlyRevenue[i].amount,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF16A34A),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: muted, size: 22),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
