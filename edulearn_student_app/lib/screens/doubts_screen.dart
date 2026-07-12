import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/doubts_store.dart';
import '../widgets/app_card.dart';

class DoubtsScreen extends StatefulWidget {
  const DoubtsScreen({super.key, this.initialTab, this.from});

  // Optional tab to open on: 'mine', 'community', or 'solved'.
  final String? initialTab;
  // Optional origin hint (e.g. 'notifications') controlling the back arrow.
  final String? from;

  @override
  State<DoubtsScreen> createState() => _DoubtsScreenState();
}

class _DoubtsScreenState extends State<DoubtsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(
    length: 3,
    vsync: this,
    initialIndex: _resolveInitialTab(widget.initialTab),
  );
  final _store = DoubtsStore.instance;
  final _searchCtrl = TextEditingController();
  String _query = '';

  static int _resolveInitialTab(String? key) {
    switch (key) {
      case 'community':
        return 1;
      case 'solved':
        return 2;
      case 'mine':
      default:
        return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _searchCtrl.dispose();
    _tab.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  bool _matchesQuery(Doubt d) {
    if (_query.trim().isEmpty) return true;
    final q = _query.trim().toLowerCase();
    return d.question.toLowerCase().contains(q) ||
        d.subject.toLowerCase().contains(q) ||
        d.askedBy.toLowerCase().contains(q);
  }

  void _showHelpSheet() {
    final pending = _store.items
        .where((d) => d.askedBy != 'You' && d.status != 'solved')
        .toList();

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (ctx, controller) {
            final muted = Theme.of(ctx).textTheme.bodySmall?.color;
            final primary = Theme.of(ctx).colorScheme.primary;

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Doubts awaiting help',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    'Answer a peer\'s question and earn reputation points.',
                    style: TextStyle(color: muted, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: pending.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.celebration_outlined, size: 56, color: muted),
                                const SizedBox(height: 12),
                                const Text('All caught up!',
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('No community doubts are waiting for an answer right now.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: muted, fontSize: 13)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: controller,
                            itemCount: pending.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, i) {
                              final d = pending[i];
                              return Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(ctx).dividerColor),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(999),
                                          ),
                                          child: Text(d.subject,
                                              style: TextStyle(
                                                  fontSize: 11, fontWeight: FontWeight.w600, color: primary)),
                                        ),
                                        const SizedBox(width: 8),
                                        Text('Asked by ${d.askedBy} • ${d.time}',
                                            style: TextStyle(fontSize: 11, color: muted)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(d.question, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${d.replies} replies so far',
                                            style: TextStyle(fontSize: 12, color: muted)),
                                        FilledButton.icon(
                                          onPressed: () {
                                            Navigator.pop(sheetCtx);
                                            _openAnswerDialog(d);
                                          },
                                          icon: const Icon(Icons.reply, size: 18),
                                          label: const Text('Answer'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openAnswerDialog(Doubt d) async {
    final replyCtrl = TextEditingController();

    final posted = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Post an answer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.question,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text('Asked by ${d.askedBy}',
                    style: TextStyle(fontSize: 12, color: Theme.of(ctx).textTheme.bodySmall?.color)),
                const SizedBox(height: 16),
                TextField(
                  controller: replyCtrl,
                  maxLines: 4,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Your answer',
                    hintText: 'Share your explanation, hint or worked steps...',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (replyCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Please write an answer first')),
                  );
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Post Reply'),
            ),
          ],
        );
      },
    );

    if (posted == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reply posted on "${d.subject}" doubt')),
      );
    }

    replyCtrl.dispose();
  }

  List<Doubt> _filtered() {
    final all = _store.items.where(_matchesQuery).toList();
    final i = _tab.index;
    if (i == 0) return all.where((d) => d.askedBy == 'You').toList();
    if (i == 1) return all.where((d) => d.askedBy != 'You').toList();
    if (i == 2) return all.where((d) => d.status == 'solved').toList();
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.from == 'notifications' || Navigator.of(context).canPop())
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () {
                            if (widget.from == 'notifications') {
                              context.go('/notifications');
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          tooltip: 'Back',
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Doubts', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('Ask and learn together', style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => context.push('/ask-doubt'),
                        child: SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.add, color: primary, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search doubts...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.6)),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(Icons.clear, color: Colors.white.withValues(alpha: 0.8)),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                          ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white, width: 1.5)),
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Theme.of(context).cardColor,
            child: TabBar(
              controller: _tab,
              onTap: (_) => setState(() {}),
              labelColor: primary,
              unselectedLabelColor: muted,
              indicatorColor: primary,
              tabs: const [Tab(text: 'My Doubts'), Tab(text: 'Community'), Tab(text: 'Solved')],
            ),
          ),
          Expanded(
            child: Builder(builder: (context) {
              final results = _filtered();
              final hasQuery = _query.trim().isNotEmpty;

              return ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (results.isEmpty && hasQuery)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 64, color: muted),
                          const SizedBox(height: 12),
                          const Text('No such doubt available', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            'No doubts match "${_query.trim()}". Try a different keyword.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: muted, fontSize: 13),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text('Clear search'),
                          ),
                        ],
                      ),
                    )
                  else if (results.isEmpty && _tab.index == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Column(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: muted),
                          const SizedBox(height: 12),
                          const Text('No doubts yet', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text('Ask your first doubt and get help from teachers and peers', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 13)),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: () => context.push('/ask-doubt'),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Ask Your First Doubt'),
                          ),
                        ],
                      ),
                    )
                  else
                    for (final d in results)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: primary,
                                  child: Text(d.askedBy[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                                            child: Text(d.subject, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primary)),
                                          ),
                                          if (d.status == 'solved')
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.check_circle, size: 14, color: Color(0xFF10B981)),
                                                  SizedBox(width: 4),
                                                  Text('Solved', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
                                                ],
                                              ),
                                            ),
                                          if (d.status == 'answered')
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(999),
                                              ),
                                              child: const Text('Answered', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF3B82F6))),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(d.question, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text(d.askedBy, style: TextStyle(fontSize: 12, color: muted)),
                                          Text('  •  ', style: TextStyle(color: muted)),
                                          Icon(Icons.schedule, size: 14, color: muted),
                                          const SizedBox(width: 4),
                                          Text(d.time, style: TextStyle(fontSize: 12, color: muted)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.chat_bubble_outline, size: 18, color: muted),
                                const SizedBox(width: 6),
                                Text('${d.replies} replies', style: TextStyle(fontSize: 13, color: muted)),
                                const SizedBox(width: 20),
                                Icon(Icons.trending_up, size: 18, color: muted),
                                const SizedBox(width: 6),
                                Text('${d.views} views', style: TextStyle(fontSize: 13, color: muted)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                if (_tab.index == 1)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFFDB2777)]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 40),
                        const SizedBox(height: 12),
                        const Text('Join the Discussion!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(
                          'Help your peers by answering their doubts and earn reputation points',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.tonal(
                          onPressed: _showHelpSheet,
                          child: const Text('Start Helping'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
