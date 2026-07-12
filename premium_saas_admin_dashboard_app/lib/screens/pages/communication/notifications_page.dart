import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/notifications_data.dart';
import '../../../widgets/shared/page_header.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = GoRouter.of(context).canPop();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Notifications',
            subtitle: 'All sent notifications',
            action: OutlinedButton.icon(
              onPressed: () => canPop ? context.pop() : context.go('/'),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                for (var i = 0; i < NotificationsData.items.length; i++) ...[
                  _NotificationTile(item: NotificationsData.items[i]),
                  if (i != NotificationsData.items.length - 1) const Divider(height: 1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final statusColor = item.status == 'completed' ? const Color(0xFF16A34A) : const Color(0xFFCA8A04);

    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFEEF2FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.notifications_none, color: Color(0xFF4F46E5)),
      ),
      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(item.message, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: muted)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(text: item.sentOn),
              _Chip(text: item.channel),
              _Chip(text: item.recipients),
              _Chip(text: item.status, fg: statusColor, bg: statusColor.withValues(alpha: 0.10)),
            ],
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/communication/notifications/${item.id}'),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, this.fg, this.bg});

  final String text;
  final Color? fg;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final c = fg ?? muted ?? const Color(0xFF6B7280);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg ?? const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c)),
    );
  }
}

