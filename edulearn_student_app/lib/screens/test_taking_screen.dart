import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class TestTakingScreen extends StatefulWidget {
  const TestTakingScreen({super.key, required this.id});
  final String id;

  @override
  State<TestTakingScreen> createState() => _TestTakingScreenState();
}

class _TestTakingScreenState extends State<TestTakingScreen> {
  int _current = 1;
  bool _showGrid = false;
  static const _total = 30;

  final Map<int, String> _answers = {};
  final Set<int> _marked = {};

  static const _options = [
    ('A', 'The magnetic field is uniform throughout the solenoid'),
    ('B', 'The magnetic field is zero outside the solenoid'),
    ('C', 'The magnetic field depends on the current flowing through it'),
    ('D', 'All of the above'),
  ];

  int get _answeredCount => _answers.length;
  int get _markedCount => _marked.length;
  int get _unansweredCount => _total - _answeredCount;

  void _toggleMark() {
    setState(() {
      if (_marked.contains(_current)) {
        _marked.remove(_current);
      } else {
        _marked.add(_current);
      }
    });
  }

  Future<void> _onSubmitPressed() async {
    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final muted = Theme.of(ctx).textTheme.bodySmall?.color;
        return AlertDialog(
          title: const Text('Submit Test?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Once submitted, your answers cannot be changed.'),
              const SizedBox(height: 12),
              _summaryRow('Answered', '$_answeredCount', const Color(0xFF10B981), muted),
              _summaryRow('Marked', '$_markedCount', const Color(0xFFF59E0B), muted),
              _summaryRow('Unanswered', '$_unansweredCount', Theme.of(ctx).colorScheme.error, muted),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Continue Test')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );

    if (shouldSubmit != true || !mounted) return;
    await _showResultDialog();
    if (!mounted) return;
    context.pop();
  }

  Widget _summaryRow(String label, String value, Color color, Color? muted) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: muted)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
            child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _showResultDialog() async {
    final correct = _answers.values.where((v) => v == 'D').length;
    final attempted = _answeredCount;
    final marks = correct * 4 - (attempted - correct);
    final maxMarks = _total * 4;
    final percent = maxMarks == 0 ? 0.0 : (marks.clamp(0, maxMarks) / maxMarks) * 100;
    final rank = 1 + math.Random(widget.id.hashCode + marks).nextInt(500);
    final passed = percent >= 40;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final primary = Theme.of(ctx).colorScheme.primary;
        final muted = Theme.of(ctx).textTheme.bodySmall?.color;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: passed
                          ? const [Color(0xFF10B981), Color(0xFF059669)]
                          : const [Color(0xFFF59E0B), Color(0xFFEF4444)],
                    ),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    children: [
                      Icon(passed ? Icons.emoji_events : Icons.replay_outlined,
                          color: Colors.white, size: 56),
                      const SizedBox(height: 8),
                      Text(
                        passed ? 'Test Submitted!' : 'Keep Practicing',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${percent.toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w800, height: 1),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$marks / $maxMarks marks',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _resultRow(Icons.check_circle_outline, 'Correct', '$correct', const Color(0xFF10B981), muted),
                      const SizedBox(height: 8),
                      _resultRow(Icons.cancel_outlined, 'Incorrect', '${attempted - correct}', Theme.of(ctx).colorScheme.error, muted),
                      const SizedBox(height: 8),
                      _resultRow(Icons.remove_circle_outline, 'Skipped', '${_total - attempted}', muted ?? Colors.grey, muted),
                      const SizedBox(height: 8),
                      _resultRow(Icons.emoji_events_outlined, 'Rank', '#$rank', primary, muted),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Close'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Detailed analysis coming soon')),
                                );
                              },
                              child: const Text('View Solutions'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _resultRow(IconData icon, String label, String value, Color color, Color? muted) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500))),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final selected = _answers[_current];
    final isLast = _current == _total;

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Physics Chapter Test', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        Text('Magnetism', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      children: [
                        Icon(Icons.schedule, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('59:00', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFeatures: [FontFeature.tabularFigures()])),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _showGrid = !_showGrid),
                    icon: const Icon(Icons.grid_view, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          if (_showGrid)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              child: Column(
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 10,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                    children: List.generate(_total, (i) {
                      final n = i + 1;
                      final answered = _answers.containsKey(n);
                      final marked = _marked.contains(n);
                      Color bg;
                      Color fg = Colors.white;
                      if (n == _current) {
                        bg = primary;
                      } else if (marked) {
                        bg = const Color(0xFFF59E0B);
                      } else if (answered) {
                        bg = const Color(0xFF10B981);
                      } else {
                        bg = Theme.of(context).dividerColor;
                        fg = muted ?? Colors.grey;
                      }
                      return Material(
                        color: bg,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () => setState(() {
                            _current = n;
                            _showGrid = false;
                          }),
                          borderRadius: BorderRadius.circular(8),
                          child: Center(child: Text('$n', style: TextStyle(fontWeight: FontWeight.w600, color: fg))),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legend(const Color(0xFF10B981), 'Answered', muted),
                      const SizedBox(width: 20),
                      _legend(const Color(0xFFF59E0B), 'Marked', muted),
                      const SizedBox(width: 20),
                      _legend(Theme.of(context).dividerColor, 'Unanswered', muted),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Question $_current of $_total', style: TextStyle(color: muted, fontSize: 13)),
                    const Text('2 marks', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 16),
                AppCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Which of the following statements is/are correct about a solenoid carrying current?',
                        style: TextStyle(fontSize: 17, height: 1.35),
                      ),
                      const SizedBox(height: 20),
                      for (final o in _options)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: selected == o.$1 ? primary.withValues(alpha: 0.06) : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              onTap: () => setState(() => _answers[_current] = o.$1),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: selected == o.$1 ? primary : Theme.of(context).dividerColor, width: selected == o.$1 ? 2 : 1),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: selected == o.$1 ? primary : Theme.of(context).dividerColor, width: 2),
                                        color: selected == o.$1 ? primary : null,
                                      ),
                                      child: selected == o.$1
                                          ? const Center(child: Icon(Icons.circle, size: 8, color: Colors.white))
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: '${o.$1}. ', style: const TextStyle(fontWeight: FontWeight.w600)),
                                            TextSpan(text: o.$2),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _current == 1 ? null : () => setState(() => _current--),
                        icon: const Icon(Icons.chevron_left, size: 18),
                        label: const Text(
                          'Previous',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _toggleMark,
                        icon: Icon(
                          _marked.contains(_current) ? Icons.flag : Icons.flag_outlined,
                          size: 16,
                          color: _marked.contains(_current) ? const Color(0xFFF59E0B) : null,
                        ),
                        label: Text(
                          _marked.contains(_current) ? 'Marked' : 'Mark',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (isLast) {
                            _onSubmitPressed();
                          } else {
                            setState(() => _current++);
                          }
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                isLast ? 'Submit Test' : 'Save & Next',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (!isLast) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, size: 18),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            elevation: 6,
            color: Theme.of(context).cardColor,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 16,
                        children: [
                          Text.rich(TextSpan(
                            text: 'Answered: ',
                            style: TextStyle(color: muted, fontSize: 13),
                            children: [
                              TextSpan(text: '$_answeredCount', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                            ],
                          )),
                          Text.rich(TextSpan(
                            text: 'Marked: ',
                            style: TextStyle(color: muted, fontSize: 13),
                            children: [
                              TextSpan(text: '$_markedCount', style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.w600)),
                            ],
                          )),
                          Text.rich(TextSpan(
                            text: 'Unanswered: ',
                            style: TextStyle(color: muted, fontSize: 13),
                            children: [
                              TextSpan(text: '$_unansweredCount', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          )),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                      onPressed: _onSubmitPressed,
                      child: const Text('Submit Test'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color c, String label, Color? muted) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: muted)),
      ],
    );
  }
}
