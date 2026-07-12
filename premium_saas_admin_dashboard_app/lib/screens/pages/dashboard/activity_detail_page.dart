import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final activity = DashboardData.instance.activityById(id);
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    if (activity == null) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Activity',
            action: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
          ),
          const SizedBox(height: 24),
          const Center(child: Text('Activity not found')),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: activity.title,
          subtitle: activity.time,
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
                  decoration: BoxDecoration(color: activity.bg, borderRadius: BorderRadius.circular(14)),
                  child: Icon(activity.icon, color: activity.fg, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activity.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(activity.body, style: TextStyle(color: muted, height: 1.5)),
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
                const Text('Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 12),
                for (final d in activity.details)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(width: 140, child: Text(d.$1, style: TextStyle(color: muted, fontSize: 13))),
                        Expanded(child: Text(d.$2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
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
