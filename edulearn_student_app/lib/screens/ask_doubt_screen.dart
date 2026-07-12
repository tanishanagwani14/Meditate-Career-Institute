import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/doubts_store.dart';

class AskDoubtScreen extends StatefulWidget {
  const AskDoubtScreen({super.key});

  @override
  State<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends State<AskDoubtScreen> {
  static const _subjects = ['Physics', 'Chemistry', 'Mathematics', 'Biology'];
  String? _subject;
  final _title = TextEditingController();
  final _desc = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
            ),
            padding: const EdgeInsets.fromLTRB(8, 40, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                    const Text('Ask a Doubt', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('Get help from teachers and fellow students', style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('Subject', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.2,
                  children: [
                    for (final s in _subjects)
                      OutlinedButton(
                        onPressed: () => setState(() => _subject = s),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _subject == s ? primary.withValues(alpha: 0.06) : null,
                          side: BorderSide(color: _subject == s ? primary : Theme.of(context).dividerColor, width: _subject == s ? 2 : 1),
                        ),
                        child: Text(s, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Question Title', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: _title,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(hintText: 'What is your question?'),
                ),
                const SizedBox(height: 24),
                Text('Description (Optional)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextField(
                  controller: _desc,
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: 'Add more details to help others understand your doubt better...', alignLabelWithHint: true),
                ),
                const SizedBox(height: 24),
                Text('Attachments (Optional)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.image_outlined, size: 48, color: Theme.of(context).textTheme.bodySmall?.color),
                      const SizedBox(height: 8),
                      Text('Upload images or PDFs', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13)),
                      Text('Max file size: 5MB', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancel'))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: (_subject != null && _title.text.trim().isNotEmpty)
                            ? () {
                                final question = _desc.text.trim().isEmpty
                                    ? _title.text.trim()
                                    : '${_title.text.trim()}\n${_desc.text.trim()}';
                                DoubtsStore.instance.addDoubt(
                                  subject: _subject!,
                                  question: question,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Doubt posted')),
                                );
                                context.go('/doubts');
                              }
                            : null,
                        child: const Text('Submit Doubt'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
