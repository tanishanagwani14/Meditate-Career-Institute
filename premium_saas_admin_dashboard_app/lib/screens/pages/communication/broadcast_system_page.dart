import 'package:flutter/material.dart';

import '../../../widgets/shared/page_header.dart';

class BroadcastSystemPage extends StatefulWidget {
  const BroadcastSystemPage({super.key});

  @override
  State<BroadcastSystemPage> createState() => _BroadcastSystemPageState();
}

class _BroadcastSystemPageState extends State<BroadcastSystemPage> {
  final Set<String> selectedChannels = {'email'};
  String selectedAudience = 'all-students';

  final subjectController = TextEditingController();
  final messageController = TextEditingController();

  static const channels = [
    ('email', 'Email', Icons.mail_outline, Color(0xFFDBEAFE), Color(0xFF2563EB)),
    ('sms', 'SMS', Icons.chat_bubble_outline, Color(0xFFDCFCE7), Color(0xFF16A34A)),
    ('push', 'Push Notification', Icons.smartphone_outlined, Color(0xFFF3E8FF), Color(0xFF9333EA)),
  ];

  static const audiences = [
    ('all-students', 'All Students', 1284),
    ('all-teachers', 'All Teachers', 42),
    ('jee-students', 'JEE Students Only', 450),
    ('neet-students', 'NEET Students Only', 380),
    ('custom', 'Custom Selection', 0),
  ];

  int get _estimatedReach {
    return audiences.where((a) => a.$1 == selectedAudience).map((a) => a.$3).firstOrNull ?? 0;
  }

  @override
  void dispose() {
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _toggleChannel(String id) {
    setState(() {
      if (selectedChannels.contains(id)) {
        selectedChannels.remove(id);
      } else {
        selectedChannels.add(id);
      }
      if (selectedChannels.isEmpty) {
        selectedChannels.add('email');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Broadcast System',
          subtitle: 'Send mass communications to students and teachers',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final is3 = c.maxWidth >= 1100;
            if (!is3) {
              return Column(
                children: [
                  _LeftPane(
                    selectedChannels: selectedChannels,
                    onToggleChannel: _toggleChannel,
                    subjectController: subjectController,
                    messageController: messageController,
                  ),
                  const SizedBox(height: 16),
                  _RightPane(
                    selectedAudience: selectedAudience,
                    onSelectAudience: (v) => setState(() => selectedAudience = v),
                    estimatedReach: _estimatedReach,
                    channelCount: selectedChannels.length,
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _LeftPane(
                    selectedChannels: selectedChannels,
                    onToggleChannel: _toggleChannel,
                    subjectController: subjectController,
                    messageController: messageController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _RightPane(
                    selectedAudience: selectedAudience,
                    onSelectAudience: (v) => setState(() => selectedAudience = v),
                    estimatedReach: _estimatedReach,
                    channelCount: selectedChannels.length,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _LeftPane extends StatelessWidget {
  const _LeftPane({
    required this.selectedChannels,
    required this.onToggleChannel,
    required this.subjectController,
    required this.messageController,
  });

  final Set<String> selectedChannels;
  final void Function(String id) onToggleChannel;
  final TextEditingController subjectController;
  final TextEditingController messageController;

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
                const Text('Select Communication Channels', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, c) {
                    final cols = c.maxWidth >= 800 ? 3 : c.maxWidth >= 520 ? 2 : 1;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: cols,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: cols == 1 ? 3.2 : 1.55,
                      children: [
                        for (final ch in _BroadcastSystemPageState.channels)
                          _ChannelCard(
                            id: ch.$1,
                            name: ch.$2,
                            icon: ch.$3,
                            iconBg: ch.$4,
                            iconColor: ch.$5,
                            selected: selectedChannels.contains(ch.$1),
                            onTap: () => onToggleChannel(ch.$1),
                          ),
                      ],
                    );
                  },
                ),
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
                const Text('Compose Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                const Text('Subject', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                const SizedBox(height: 8),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(hintText: 'Enter message subject', isDense: true),
                ),
                const SizedBox(height: 14),
                const Text('Message', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                const SizedBox(height: 8),
                TextField(
                  controller: messageController,
                  minLines: 8,
                  maxLines: 8,
                  decoration: const InputDecoration(hintText: 'Type your message here...', isDense: true),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text('Send Broadcast'),
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 46)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 46)),
                      child: const Text('Save Draft'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.id,
    required this.name,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.selected,
    required this.onTap,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB), width: 2),
          color: selected ? const Color(0xFFEFF6FF) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(height: 10),
            Text(name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _RightPane extends StatelessWidget {
  const _RightPane({
    required this.selectedAudience,
    required this.onSelectAudience,
    required this.estimatedReach,
    required this.channelCount,
  });

  final String selectedAudience;
  final ValueChanged<String> onSelectAudience;
  final int estimatedReach;
  final int channelCount;

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
                const Text('Select Audience', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                for (final a in _BroadcastSystemPageState.audiences) ...[
                  _AudienceTile(
                    value: a.$1,
                    label: a.$2,
                    count: a.$3,
                    selected: selectedAudience == a.$1,
                    onTap: () => onSelectAudience(a.$1),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color(0xFFEFF6FF),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.people_outline, color: Color(0xFF2563EB)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estimated Reach', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1E3A8A))),
                      const SizedBox(height: 4),
                      Text(
                        'Your broadcast will reach approximately $estimatedReach recipients via $channelCount channel(s).',
                        style: const TextStyle(color: Color(0xFF1D4ED8)),
                      ),
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
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Recent Broadcasts', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                for (final b in const [
                  ('Fee Payment Reminder', '2026-05-01', 1284),
                  ('Class Rescheduled', '2026-05-01', 50),
                  ('Holiday Announcement', '2026-04-29', 1326),
                ]) ...[
                  _RecentBroadcastRow(title: b.$1, date: b.$2, count: b.$3),
                  const Divider(height: 18, color: Color(0xFFF3F4F6)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AudienceTile extends StatelessWidget {
  const _AudienceTile({
    required this.value,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String value;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB), width: 2),
          color: selected ? const Color(0xFFEFF6FF) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? const Color(0xFF4F46E5) : const Color(0xFFD1D5DB), width: 2),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4F46E5)),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
                  if (count > 0) Text('$count recipients', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentBroadcastRow extends StatelessWidget {
  const _RecentBroadcastRow({required this.title, required this.date, required this.count});
  final String title;
  final String date;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            const SizedBox(width: 8),
            const Text('•', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
            const SizedBox(width: 8),
            Text('$count recipients', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
          ],
        ),
      ],
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

