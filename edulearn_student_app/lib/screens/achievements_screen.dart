import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class _Ach {
  const _Ach({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    required this.progress,
    required this.grad,
    this.current,
    this.total,
  });
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final int progress;
  final List<Color> grad;
  final int? current;
  final int? total;
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key, this.from});

  // Optional origin hint (e.g. 'notifications') controlling the back arrow.
  final String? from;

  static const _list = [
    _Ach(
      id: 1,
      title: '7-Day Streak',
      description: 'Learn for 7 consecutive days',
      icon: Icons.local_fire_department,
      unlocked: true,
      progress: 100,
      grad: [Color(0xFFF97316), Color(0xFFDC2626)],
    ),
    _Ach(
      id: 2,
      title: 'Perfect Score',
      description: 'Score 100% in any test',
      icon: Icons.star_rate_rounded,
      unlocked: true,
      progress: 100,
      grad: [Color(0xFFEAB308), Color(0xFFEA580C)],
    ),
    _Ach(
      id: 3,
      title: 'Quick Learner',
      description: 'Complete 10 courses',
      icon: Icons.track_changes,
      unlocked: false,
      progress: 80,
      current: 8,
      total: 10,
      grad: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    ),
    _Ach(
      id: 4,
      title: 'Community Helper',
      description: 'Answer 50 doubts',
      icon: Icons.workspace_premium_outlined,
      unlocked: false,
      progress: 40,
      current: 20,
      total: 50,
      grad: [Color(0xFF22C55E), Color(0xFF059669)],
    ),
    _Ach(
      id: 5,
      title: 'Test Master',
      description: 'Complete 100 tests',
      icon: Icons.emoji_events_outlined,
      unlocked: false,
      progress: 24,
      current: 24,
      total: 100,
      grad: [Color(0xFFA855F7), Color(0xFFDB2777)],
    ),
    _Ach(
      id: 6,
      title: 'Top Ranker',
      description: 'Get top 10 rank in any test',
      icon: Icons.emoji_events_outlined,
      unlocked: false,
      progress: 0,
      grad: [Color(0xFFEC4899), Color(0xFFDC2626)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final unlocked = _list.where((a) => a.unlocked).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(8, 40, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (from == 'notifications') {
                            context.go('/notifications');
                          } else {
                            context.pop();
                          }
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Text('Achievements', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppCard(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                          child: const Icon(Icons.emoji_events, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 12),
                        Text('$unlocked/${_list.length}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        Text('Achievements Unlocked', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final a = _list[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Opacity(
                      opacity: a.unlocked ? 1 : 0.85,
                      child: AppCard(
                        padding: const EdgeInsets.all(16),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (_) => _AchievementDetailScreen(ach: a)),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: LinearGradient(colors: a.grad),
                                  ),
                                  child: Icon(a.icon, color: Colors.white, size: 32),
                                ),
                                if (!a.unlocked)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.45),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: const Icon(Icons.lock, color: Colors.white, size: 28),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(a.description, style: TextStyle(fontSize: 13, color: muted)),
                                  const SizedBox(height: 12),
                                  if (a.unlocked)
                                    const Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Color(0xFF10B981), size: 22),
                                        SizedBox(width: 8),
                                        Text('Unlocked', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
                                      ],
                                    )
                                  else ...[
                                    if (a.current != null && a.total != null)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Progress', style: TextStyle(fontSize: 12, color: muted)),
                                          Text('${a.current}/${a.total}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                        ],
                                      ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(999),
                                      child: LinearProgressIndicator(
                                        value: a.progress / 100,
                                        minHeight: 8,
                                        backgroundColor: Theme.of(context).dividerColor,
                                        color: a.grad.first,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${a.progress}% complete', style: TextStyle(fontSize: 11, color: muted)),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: _list.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementDetailScreen extends StatelessWidget {
  const _AchievementDetailScreen({required this.ach});
  final _Ach ach;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievement'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: ach.grad),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(ach.icon, color: ach.grad.first, size: 54),
                    ),
                    if (!ach.unlocked)
                      Container(
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lock, color: Colors.white, size: 40),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(ach.title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(ach.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontSize: 14)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    ach.unlocked ? 'Unlocked' : 'Locked',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Progress', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ach.current != null && ach.total != null
                            ? '${ach.current} / ${ach.total}'
                            : (ach.unlocked ? 'Completed' : 'Not started'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('${ach.progress}%', style: TextStyle(fontWeight: FontWeight.w700, color: primary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: ach.progress / 100,
                      minHeight: 10,
                      backgroundColor: Theme.of(context).dividerColor,
                      color: ach.grad.first,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('How to earn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(_howToEarn(ach), style: TextStyle(color: muted, height: 1.5)),
                  const SizedBox(height: 20),
                  if (ach.unlocked)
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF10B981)),
                        const SizedBox(width: 8),
                        Text(
                          'Earned on ${_earnedDate(ach.id)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  else
                    FilledButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.flag_outlined),
                      label: const Text('Keep going'),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _howToEarn(_Ach ach) {
    switch (ach.id) {
      case 1:
        return 'Open the app and engage with at least one course or doubt every day for 7 days in a row. Your current streak resets if you miss a day.';
      case 2:
        return 'Score 100% on any quiz or test. Practice quizzes count too.';
      case 3:
        return 'Mark courses as completed by finishing every chapter and passing the final test. Two more courses to go!';
      case 4:
        return 'Answer doubts posted by other students in the Doubts > Community tab. Each accepted answer counts toward this badge.';
      case 5:
        return 'Attempt 100 tests across any subject. Both practice and graded tests count.';
      case 6:
        return 'Finish in the top 10 leaderboard positions for any timed test or mock exam.';
      default:
        return ach.description;
    }
  }

  String _earnedDate(int id) {
    switch (id) {
      case 1:
        return 'May 20, 2026';
      case 2:
        return 'May 12, 2026';
      default:
        return 'recently';
    }
  }
}
