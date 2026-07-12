import 'package:flutter/material.dart';

import '../widgets/app_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics', style: TextStyle(fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Overview', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _kpi(context, 'Engagement', '74%')),
                    const SizedBox(width: 12),
                    Expanded(child: _kpi(context, 'Retention', '61%')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly Activity', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final v in const [0.2, 0.5, 0.35, 0.75, 0.6, 0.9, 0.7])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Container(
                              height: 160 * v,
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text('Tap bars to drill down (UI placeholder)', style: TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kpi(BuildContext context, String label, String value) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 18)),
        ],
      ),
    );
  }
}

