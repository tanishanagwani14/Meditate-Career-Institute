import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class _Enrolled {
  const _Enrolled({
    required this.id,
    required this.title,
    required this.progress,
    required this.gradient,
    required this.totalLessons,
    required this.completedLessons,
    required this.lastWatched,
    required this.timeSpent,
  });
  final int id;
  final String title;
  final int progress;
  final List<Color> gradient;
  final int totalLessons;
  final int completedLessons;
  final String lastWatched;
  final String timeSpent;
}

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  static const _courses = [
    _Enrolled(
      id: 1,
      title: 'Complete JEE Main 2027',
      progress: 65,
      gradient: [Color(0xFFF97316), Color(0xFFDC2626)],
      totalLessons: 240,
      completedLessons: 156,
      lastWatched: 'Chapter 5: Magnetism',
      timeSpent: '45h 30m',
    ),
    _Enrolled(
      id: 2,
      title: 'NEET Biology Mastery',
      progress: 40,
      gradient: [Color(0xFF22C55E), Color(0xFF059669)],
      totalLessons: 180,
      completedLessons: 72,
      lastWatched: 'Cell Biology - Part 3',
      timeSpent: '28h 15m',
    ),
    _Enrolled(
      id: 3,
      title: 'Class 12 Physics CBSE',
      progress: 85,
      gradient: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
      totalLessons: 150,
      completedLessons: 128,
      lastWatched: 'Wave Optics',
      timeSpent: '62h 45m',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

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
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('My Courses', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Text('${_courses.length} courses enrolled', style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                for (final c in _courses) ...[
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 128,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: c.gradient),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Center(
                                child: IconButton.filledTonal(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    foregroundColor: Colors.white,
                                  ),
                                  iconSize: 40,
                                  onPressed: () => context.push('/video-player/${c.id}'),
                                  icon: const Icon(Icons.play_arrow_rounded),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text('${c.progress}% Complete', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primary)),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: c.progress / 100,
                                  minHeight: 8,
                                  backgroundColor: Theme.of(context).dividerColor,
                                  color: primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Progress', style: TextStyle(fontSize: 11, color: muted)),
                                        Text('${c.completedLessons}/${c.totalLessons} lessons', style: const TextStyle(fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Time Spent', style: TextStyle(fontSize: 11, color: muted)),
                                        Text(c.timeSpent, style: const TextStyle(fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.schedule, size: 18, color: muted),
                                  const SizedBox(width: 6),
                                  Expanded(child: Text('Last watched: ${c.lastWatched}', style: TextStyle(fontSize: 13, color: muted))),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => context.push('/video-player/${c.id}'),
                                      icon: const Icon(Icons.play_arrow, size: 18),
                                      label: const Text('Continue'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  OutlinedButton(onPressed: () {}, child: const Icon(Icons.download_outlined, size: 20)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.white, size: 48),
                      const SizedBox(height: 12),
                      const Text('Looking for more courses?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(
                        'Explore our extensive course library to boost your learning',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(onPressed: () => context.go('/courses'), child: const Text('Browse Courses')),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
