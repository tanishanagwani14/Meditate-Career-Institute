import 'package:flutter/material.dart';

import '../../../data/notifications_data.dart';
import '../../../widgets/shared/page_header.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final n = NotificationsData.byId(id);

    if (n == null) {
      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            PageHeader(title: 'Notification'),
            SizedBox(height: 24),
            Center(child: Text('Notification not found')),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: n.title,
            subtitle: '${n.sentOn} · ${n.channel}',
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Message', style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(n.message, style: const TextStyle(fontSize: 15, height: 1.3)),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'Recipients', value: n.recipients),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Sent by', value: n.sentBy),
                  const SizedBox(height: 10),
                  _InfoRow(label: 'Status', value: n.status),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Text(label, style: TextStyle(color: muted, fontWeight: FontWeight.w700)),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
      ],
    );
  }
}

