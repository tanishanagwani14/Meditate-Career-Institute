import 'package:flutter/material.dart';

import '../widgets/app_card.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar', style: TextStyle(fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                for (final e in const [
                  ('Live Class', 'Physics - Mechanics', '10:00 AM'),
                  ('Doubt Session', 'Chemistry - Organic', '2:00 PM'),
                  ('Test Review', 'JEE 2024 Batch', '6:00 PM'),
                ]) ...[
                  _event(context, primary, muted, e.$1, e.$2, e.$3),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _event(BuildContext context, Color primary, Color? muted, String type, String title, String time) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.event_note_outlined, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: TextStyle(color: muted, fontSize: 12)),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: muted, fontSize: 12)),
        ],
      ),
    );
  }
}

