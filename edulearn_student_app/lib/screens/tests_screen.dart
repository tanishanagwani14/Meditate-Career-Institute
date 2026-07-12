import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class _TestEntry {
  const _TestEntry({
    required this.id,
    required this.title,
    required this.subject,
    required this.questions,
    required this.duration,
    required this.marks,
    required this.attempts,
    this.bestScore,
    required this.difficulty,
    required this.grad,
  });

  final int id;
  final String title;
  final String subject;
  final int questions;
  final String duration;
  final int marks;
  final int attempts;
  final int? bestScore;
  final String difficulty;
  final List<Color> grad;
}

class _ResultEntry {
  const _ResultEntry(this.title, this.date, this.score, this.max, this.rank, this.total);
  final String title;
  final String date;
  final int score;
  final int max;
  final int rank;
  final int total;
}

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  final ScrollController _scroll = ScrollController();
  final GlobalKey _availableKey = GlobalKey();
  bool _showAll = false;

  static const _allTests = <_TestEntry>[
    _TestEntry(
      id: 1,
      title: 'JEE Main Mock Test 2027 - 1',
      subject: 'All Subjects',
      questions: 90,
      duration: '180 min',
      marks: 300,
      attempts: 0,
      difficulty: 'Hard',
      grad: [Color(0xFFF97316), Color(0xFFDC2626)],
    ),
    _TestEntry(
      id: 2,
      title: 'Physics Chapter Test - Magnetism',
      subject: 'Physics',
      questions: 30,
      duration: '60 min',
      marks: 100,
      attempts: 1,
      bestScore: 85,
      difficulty: 'Medium',
      grad: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    ),
    _TestEntry(
      id: 3,
      title: 'Chemistry Organic - Practice Quiz',
      subject: 'Chemistry',
      questions: 20,
      duration: '30 min',
      marks: 80,
      attempts: 2,
      bestScore: 72,
      difficulty: 'Easy',
      grad: [Color(0xFF10B981), Color(0xFF059669)],
    ),
    _TestEntry(
      id: 4,
      title: 'Math Calculus - Full Test',
      subject: 'Mathematics',
      questions: 25,
      duration: '50 min',
      marks: 100,
      attempts: 0,
      difficulty: 'Medium',
      grad: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
    ),
    _TestEntry(
      id: 5,
      title: 'Biology NEET Mock - Cell Biology',
      subject: 'Biology',
      questions: 45,
      duration: '60 min',
      marks: 180,
      attempts: 0,
      difficulty: 'Hard',
      grad: [Color(0xFFEC4899), Color(0xFFEF4444)],
    ),
  ];

  static const _recentResults = <_ResultEntry>[
    _ResultEntry('Chemistry Organic - Quiz 1', '2 days ago', 92, 100, 45, 1250),
    _ResultEntry('Math Calculus Test', '5 days ago', 78, 100, 125, 980),
    _ResultEntry('Physics - Optics Quiz', '1 week ago', 88, 100, 60, 1100),
    _ResultEntry('Biology - Genetics', '2 weeks ago', 95, 100, 18, 1340),
  ];

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _browseAllTests() {
    setState(() => _showAll = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _availableKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          alignment: 0,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing all ${_allTests.length} available tests'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAllResults() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (sheetCtx, controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('All Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      itemCount: _recentResults.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _resultCard(context, _recentResults[i]),
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

  void _showResultDetail(_ResultEntry r) {
    final primary = Theme.of(context).colorScheme.primary;
    showDialog<void>(
      context: context,
      builder: (ctx) {
        final muted = Theme.of(ctx).textTheme.bodySmall?.color;
        final percent = r.max == 0 ? 0 : (r.score / r.max * 100).round();
        return AlertDialog(
          title: Text(r.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.date, style: TextStyle(color: muted, fontSize: 13)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('$percent%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: primary, height: 1)),
                  const SizedBox(width: 8),
                  Text('${r.score}/${r.max}', style: TextStyle(color: muted)),
                ],
              ),
              const SizedBox(height: 16),
              _detailRow('Rank', '#${r.rank} of ${r.total}', muted),
              const SizedBox(height: 6),
              _detailRow('Percentile', '${(100 - (r.rank / r.total * 100)).toStringAsFixed(1)}', muted),
              const SizedBox(height: 6),
              _detailRow('Status', percent >= 40 ? 'Passed' : 'Needs Improvement', muted),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value, Color? muted) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: muted)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleTests = _showAll ? _allTests : _allTests.take(2).toList();
    final visibleResults = _recentResults.take(2).toList();

    return Scaffold(
      body: CustomScrollView(
        controller: _scroll,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                      const SizedBox(width: 4),
                      const Text('Tests & Quizzes', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _statCard(Icons.emoji_events_outlined, '24', 'Completed', const Color(0xFFFACC15))),
                      const SizedBox(width: 10),
                      Expanded(child: _statCard(Icons.track_changes, '85%', 'Avg Score', const Color(0xFF4ADE80))),
                      const SizedBox(width: 10),
                      Expanded(child: _statCard(Icons.trending_up, '#156', 'Best Rank', const Color(0xFF60A5FA))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  key: _availableKey,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Available Tests', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    TextButton(
                      onPressed: _showAll
                          ? () => setState(() => _showAll = false)
                          : _browseAllTests,
                      child: Text(_showAll ? 'Show Less' : 'View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                for (final t in visibleTests) ...[
                  _testCard(context, t),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Results', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    TextButton(
                      onPressed: _showAllResults,
                      child: const Row(children: [Text('View All'), Icon(Icons.chevron_right, size: 18)]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final r in visibleResults) ...[
                  _resultCard(context, r),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFFDB2777)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.track_changes, color: Colors.white, size: 48),
                      const SizedBox(height: 12),
                      const Text('Practice Makes Perfect!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        'Take more tests to improve your ranking and performance',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: _browseAllTests,
                        child: const Text('Browse All Tests'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _testCard(BuildContext context, _TestEntry t) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    Color diffColor;
    Color diffBg;
    switch (t.difficulty) {
      case 'Hard':
        diffColor = const Color(0xFFEF4444);
        diffBg = const Color(0xFFEF4444).withValues(alpha: 0.1);
        break;
      case 'Medium':
        diffColor = const Color(0xFFEAB308);
        diffBg = const Color(0xFFEAB308).withValues(alpha: 0.12);
        break;
      default:
        diffColor = const Color(0xFF22C55E);
        diffBg = const Color(0xFF22C55E).withValues(alpha: 0.12);
    }

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: t.grad),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(t.subject, style: TextStyle(color: muted, fontSize: 13)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: diffBg, borderRadius: BorderRadius.circular(999)),
                      child: Text(t.difficulty, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: diffColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _miniStat('Questions', '${t.questions}', muted),
                    const SizedBox(width: 24),
                    _miniStat('Duration', t.duration, muted),
                    const SizedBox(width: 24),
                    _miniStat('Marks', '${t.marks}', muted),
                  ],
                ),
                if (t.attempts > 0) ...[
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      text: 'Best Score: ',
                      style: TextStyle(color: muted, fontSize: 13),
                      children: [
                        TextSpan(text: '${t.bestScore}%', style: TextStyle(fontWeight: FontWeight.w600, color: primary)),
                        TextSpan(text: '  •  ${t.attempts} attempt(s)', style: TextStyle(color: muted)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => context.push('/test/${t.id}'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow, size: 20),
                      Text(t.attempts > 0 ? 'Attempt Again' : 'Start Test'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String k, String v, Color? muted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: TextStyle(fontSize: 11, color: muted)),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  Widget _resultCard(BuildContext context, _ResultEntry r) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final fg = Theme.of(context).colorScheme.onSurface;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(r.date, style: TextStyle(fontSize: 12, color: muted)),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: '${r.score}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary),
                  children: [TextSpan(text: '/${r.max}', style: TextStyle(fontSize: 13, color: muted, fontWeight: FontWeight.normal))],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events_outlined, size: 18, color: Color(0xFFEAB308)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'Rank ',
                          style: TextStyle(color: muted, fontSize: 13),
                          children: [
                            TextSpan(text: '#${r.rank}', style: TextStyle(fontWeight: FontWeight.bold, color: fg)),
                            TextSpan(
                              text: ' of ${r.total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                              style: TextStyle(color: muted),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(onPressed: () => _showResultDetail(r), child: const Text('View Details')),
            ],
          ),
        ],
      ),
    );
  }
}
