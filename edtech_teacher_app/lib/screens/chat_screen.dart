import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatArg {
  const ChatArg({
    required this.name,
    required this.isGroup,
    this.online = false,
  });

  final String name;
  final bool isGroup;
  final bool online;
}

class _ChatMessage {
  _ChatMessage({required this.text, required this.fromMe, required this.time});

  final String text;
  final bool fromMe;
  final String time;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.arg});

  final ChatArg arg;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _composeCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  late final List<_ChatMessage> _messages = [
    _ChatMessage(text: 'Hello! How can I help you?', fromMe: true, time: '10:30 AM'),
    _ChatMessage(text: 'I have a doubt about the last lecture', fromMe: false, time: '10:32 AM'),
  ];

  @override
  void dispose() {
    _composeCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  String _now() {
    final n = TimeOfDay.now();
    final h = n.hourOfPeriod == 0 ? 12 : n.hourOfPeriod;
    final m = n.minute.toString().padLeft(2, '0');
    final ap = n.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ap';
  }

  void _send() {
    final text = _composeCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, fromMe: true, time: _now()));
      _composeCtrl.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: primary.withValues(alpha: 0.15),
              child: Text(
                widget.arg.name.isNotEmpty ? widget.arg.name[0].toUpperCase() : '?',
                style: TextStyle(color: primary, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.arg.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(
                    widget.arg.isGroup ? 'Group chat' : (widget.arg.online ? 'Online' : 'Offline'),
                    style: TextStyle(
                      color: widget.arg.online ? const Color(0xFF10B981) : muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling ${widget.arg.name}…')),
              );
            },
            icon: const Icon(Icons.call_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final m = _messages[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Align(
                    alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: m.fromMe ? primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.text,
                              style: TextStyle(
                                color: m.fromMe ? Colors.white : null,
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              m.time,
                              style: TextStyle(
                                fontSize: 10,
                                color: m.fromMe ? Colors.white.withValues(alpha: 0.75) : muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _composeCtrl,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(hintText: 'Type a message...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _send,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14)),
                    child: const Icon(Icons.send, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
