import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LiveClassRoomScreen extends StatefulWidget {
  const LiveClassRoomScreen({super.key, required this.id});
  final String id;

  @override
  State<LiveClassRoomScreen> createState() => _LiveClassRoomScreenState();
}

class _LiveClassRoomScreenState extends State<LiveClassRoomScreen> {
  bool _muted = true;
  bool _videoOff = true;
  bool _showChat = true;
  final _message = TextEditingController();

  static const _participants = [
    ('Mr. Sharma', true, false),
    ('You', false, false),
    ('Rahul K.', false, false),
    ('Priya S.', false, true),
  ];

  static const _msgs = [
    ('Rahul K.', 'Can you explain this again?', '2:15 PM'),
    ('Mr. Sharma', 'Sure, let me repeat that.', '2:16 PM'),
    ('Priya S.', 'Thank you!', '2:16 PM'),
  ];

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
              ),
              child: Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mathematics - Integration', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text('Mr. Sharma • 245 participants', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final chatW = (c.maxWidth * 0.38).clamp(260.0, 320.0);
                  return Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.black,
                              alignment: Alignment.center,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF581C87)]),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 96,
                                        height: 96,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                                        child: const Text('👨‍🏫', style: TextStyle(fontSize: 40)),
                                      ),
                                      const SizedBox(height: 12),
                                      const Text('Mr. Sharma', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                                      Text('Host', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: IconButton.filled(
                                style: IconButton.styleFrom(backgroundColor: Colors.black45),
                                onPressed: () => setState(() => _showChat = !_showChat),
                                icon: Icon(_showChat ? Icons.chat_bubble_outline : Icons.chat_bubble, color: Colors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 12,
                              right: 12,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _roundCtrl(Icons.mic_off, _muted ? Colors.red : Colors.white24, () => setState(() => _muted = !_muted)),
                                  _roundCtrl(Icons.videocam_off, _videoOff ? Colors.red : Colors.white24, () => setState(() => _videoOff = !_videoOff)),
                                  _roundCtrl(Icons.front_hand, Colors.white24, () {}),
                                  _roundCtrl(Icons.people_outline, Colors.white24, () {}),
                                  FilledButton(
                                    style: FilledButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                    onPressed: () => context.pop(),
                                    child: const Text('Leave'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_showChat)
                        SizedBox(
                          width: chatW,
                          child: Material(
                            color: Theme.of(context).cardColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text('Chat & Participants', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                ),
                                const Divider(height: 1),
                                Expanded(
                                  child: ListView(
                                    padding: const EdgeInsets.all(16),
                                    children: [
                                      Text('PARTICIPANTS (${_participants.length})', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: muted)),
                                      const SizedBox(height: 8),
                                      for (final p in _participants)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
                                                  shape: BoxShape.circle,
                                                  boxShadow: p.$3
                                                      ? [const BoxShadow(color: Color(0xFF22C55E), blurRadius: 0, spreadRadius: 2)]
                                                      : null,
                                                ),
                                                child: Text(p.$1[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(child: Text(p.$1, style: const TextStyle(fontSize: 13))),
                                              if (p.$2)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text('Host', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                      Text('MESSAGES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: muted)),
                                      const SizedBox(height: 8),
                                      for (final m in _msgs) ...[
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(m.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                            const SizedBox(width: 8),
                                            Text(m.$3, style: TextStyle(fontSize: 11, color: muted)),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 12, top: 4),
                                          child: Text(m.$2, style: TextStyle(fontSize: 13, color: muted)),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Divider(height: 1),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _message,
                                          decoration: const InputDecoration(hintText: 'Type a message...', isDense: true),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      FilledButton(onPressed: () {}, child: const Text('Send')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundCtrl(IconData icon, Color bg, VoidCallback onTap) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(16), child: Icon(icon, color: Colors.white, size: 26)),
      ),
    );
  }
}
