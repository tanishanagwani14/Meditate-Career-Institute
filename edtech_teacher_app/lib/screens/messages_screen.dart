import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this);

  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tab.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    _search.dispose();
    super.dispose();
  }

  final List<_Conv> _conversations = [
    _Conv(1, 'Rahul Sharma', 'Thank you for clarifying the doubt!', '5 mins ago', unread: 0, online: true),
    _Conv(2, 'Physics - JEE 2024 Batch', 'New doubt posted by Priya', '20 mins ago', unread: 3, isGroup: true),
    _Conv(3, 'Amit Kumar', 'When is the next test scheduled?', '1 hour ago', unread: 1),
    _Conv(4, 'NEET 2024 Batch', 'Assignment submission reminder', '2 hours ago', unread: 0, isGroup: true),
  ];

  final List<_Announcement> _announcements = [
    _Announcement(
      title: 'Test Schedule Updated',
      time: '1 day ago',
      recipients: 245,
      body: 'Dear students, the upcoming weekly test has been rescheduled to Saturday 10:00 AM. Please be prepared.',
    ),
    _Announcement(
      title: 'New Course Material Added',
      time: '2 days ago',
      recipients: 189,
      body: 'New chapters on Organic Chemistry have been added to your course materials. Check the NEET batch.',
    ),
    _Announcement(
      title: 'Holiday Notice',
      time: '5 days ago',
      recipients: 590,
      body: 'Classes will remain closed on national holidays. Please refer to the calendar for the updated schedule.',
    ),
  ];

  List<_Conv> get _filteredConversations {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _conversations;
    return _conversations.where((c) => c.name.toLowerCase().contains(q) || c.message.toLowerCase().contains(q)).toList();
  }

  void _openChat(_Conv c) {
    context.push(
      '/chat',
      extra: ChatArg(name: c.name, isGroup: c.isGroup, online: c.online),
    );
    if (c.unread > 0) {
      setState(() {
        final idx = _conversations.indexWhere((x) => x.id == c.id);
        if (idx >= 0) _conversations[idx] = _conversations[idx].copyWith(unread: 0);
      });
    }
  }

  Future<void> _showNewChatDialog() async {
    final result = await showDialog<_NewChatResult>(
      context: context,
      builder: (ctx) => const _NewChatDialog(),
    );

    if (result != null && mounted) {
      setState(() {
        _conversations.insert(
          0,
          _Conv(
            DateTime.now().millisecondsSinceEpoch,
            result.name,
            result.message.isEmpty ? 'Started a conversation' : result.message,
            'Just now',
            isGroup: result.isGroup,
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Started chat with ${result.name}')),
      );
    }
  }

  Future<void> _showCreateAnnouncementDialog() async {
    final result = await showDialog<_AnnouncementResult>(
      context: context,
      builder: (ctx) => const _CreateAnnouncementDialog(),
    );

    if (result != null && mounted) {
      setState(() {
        _announcements.insert(
          0,
          _Announcement(
            title: result.title,
            time: 'Just now',
            recipients: result.recipients,
            body: result.body,
          ),
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement sent')),
      );
    }
  }

  void _showAnnouncementDetail(_Announcement a) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.notifications_outlined, color: primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                          Text(a.time, style: TextStyle(color: muted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(a.body, style: const TextStyle(fontSize: 14, height: 1.45)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 16, color: muted),
                    const SizedBox(width: 6),
                    Text('Sent to ${a.recipients} students', style: TextStyle(color: muted, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;
    final convs = _filteredConversations;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Messages', style: Theme.of(context).textTheme.titleLarge),
            FilledButton.icon(
              onPressed: _tab.index == 0 ? _showNewChatDialog : _showCreateAnnouncementDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TabBar(
          controller: _tab,
          labelColor: primary,
          unselectedLabelColor: muted,
          indicatorColor: primary,
          tabs: const [
            Tab(icon: Icon(Icons.chat_bubble_outline, size: 18), text: 'Chats'),
            Tab(icon: Icon(Icons.campaign_outlined, size: 18), text: 'Announcements'),
          ],
        ),
        const SizedBox(height: 12),
        if (_tab.index == 0) ...[
          TextField(
            controller: _search,
            decoration: const InputDecoration(hintText: 'Search conversations...', prefixIcon: Icon(Icons.search)),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          if (convs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text('No conversations found', style: TextStyle(color: muted)),
              ),
            )
          else
            for (final c in convs) ...[
              AppCard(
                padding: const EdgeInsets.all(12),
                onTap: () => _openChat(c),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: primary.withValues(alpha: 0.12),
                          child: Text(c.name[0], style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
                        ),
                        if (c.online)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).cardColor, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(child: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                                    if (c.isGroup) ...[
                                      const SizedBox(width: 6),
                                      Icon(Icons.people_outline, size: 16, color: muted),
                                    ],
                                  ],
                                ),
                              ),
                              Text(c.time, style: TextStyle(color: muted, fontSize: 11)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(child: Text(c.message, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: muted, fontSize: 13))),
                              if (c.unread > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: primary.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
                                  child: Text('${c.unread}', style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 12)),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
        ] else ...[
          FilledButton.icon(
            onPressed: _showCreateAnnouncementDialog,
            icon: const Icon(Icons.campaign, size: 18),
            label: const Text('Create Announcement'),
          ),
          const SizedBox(height: 16),
          const Text('Recent Announcements', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          for (final a in _announcements) ...[
            AppCard(
              padding: const EdgeInsets.all(12),
              onTap: () => _showAnnouncementDetail(a),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.notifications_outlined, color: primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(a.time, style: TextStyle(color: muted, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text('Sent to ${a.recipients} students', style: TextStyle(color: muted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: muted),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ],
    );
  }
}

class _Conv {
  const _Conv(this.id, this.name, this.message, this.time, {this.unread = 0, this.online = false, this.isGroup = false});
  final int id;
  final String name;
  final String message;
  final String time;
  final int unread;
  final bool online;
  final bool isGroup;

  _Conv copyWith({String? message, String? time, int? unread}) {
    return _Conv(
      id,
      name,
      message ?? this.message,
      time ?? this.time,
      unread: unread ?? this.unread,
      online: online,
      isGroup: isGroup,
    );
  }
}

class _Announcement {
  _Announcement({
    required this.title,
    required this.time,
    required this.recipients,
    required this.body,
  });

  final String title;
  final String time;
  final int recipients;
  final String body;
}

class _NewChatResult {
  const _NewChatResult({required this.name, required this.message, required this.isGroup});
  final String name;
  final String message;
  final bool isGroup;
}

class _NewChatDialog extends StatefulWidget {
  const _NewChatDialog();

  @override
  State<_NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<_NewChatDialog> {
  final _nameCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _isGroup = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipient')),
      );
      return;
    }
    Navigator.pop(
      context,
      _NewChatResult(name: name, message: _messageCtrl.text.trim(), isGroup: _isGroup),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Conversation'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Recipient',
                hintText: 'e.g., Rahul Sharma or JEE Batch',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageCtrl,
              decoration: const InputDecoration(
                labelText: 'First message (Optional)',
                hintText: 'Say hello...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Group conversation'),
              value: _isGroup,
              onChanged: (v) => setState(() => _isGroup = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Start Chat')),
      ],
    );
  }
}

class _AnnouncementResult {
  const _AnnouncementResult({required this.title, required this.body, required this.recipients});
  final String title;
  final String body;
  final int recipients;
}

class _CreateAnnouncementDialog extends StatefulWidget {
  const _CreateAnnouncementDialog();

  @override
  State<_CreateAnnouncementDialog> createState() => _CreateAnnouncementDialogState();
}

class _CreateAnnouncementDialogState extends State<_CreateAnnouncementDialog> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _recipientsCtrl = TextEditingController(text: '245');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _recipientsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter title and message')),
      );
      return;
    }
    final recipients = int.tryParse(_recipientsCtrl.text.trim()) ?? 0;
    Navigator.pop(
      context,
      _AnnouncementResult(title: title, body: body, recipients: recipients),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Announcement'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Test Schedule Updated',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bodyCtrl,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Write your announcement...',
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _recipientsCtrl,
              decoration: const InputDecoration(
                labelText: 'Recipients',
                hintText: 'Number of students',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.send, size: 18),
          label: const Text('Send'),
        ),
      ],
    );
  }
}
