import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme_controller.dart';
import '../widgets/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
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
                            Text('Good morning,', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14)),
                            const SizedBox(height: 4),
                            const Text('Rahul Kumar', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      ListenableBuilder(
                        listenable: appThemeController,
                        builder: (_, __) {
                          return IconButton.filledTonal(
                            style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.15)),
                            onPressed: () => appThemeController.toggle(),
                            icon: Icon(
                              appThemeController.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.15)),
                            onPressed: () => context.push('/notifications'),
                            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 104,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _StatChip(icon: Icons.local_fire_department, value: '15', label: 'Day Streak', iconColor: Color(0xFFFB923C)),
                        SizedBox(width: 12),
                        _StatChip(icon: Icons.trending_up, value: '85%', label: 'Avg Score', iconColor: Color(0xFF4ADE80)),
                        SizedBox(width: 12),
                        _StatChip(icon: Icons.schedule, value: '24h', label: 'This Week', iconColor: Color(0xFF60A5FA)),
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
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Continue Learning', style: Theme.of(context).textTheme.titleLarge),
                    TextButton(onPressed: () => context.go('/courses/my-courses'), child: const Text('See All')),
                  ],
                ),
                const SizedBox(height: 12),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 160,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.play_arrow_rounded, size: 48, color: Colors.white),
                          ),
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
                                      const Text('Physics - Class 12', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                      const SizedBox(height: 4),
                                      Text('Chapter 5: Magnetism', style: TextStyle(color: muted, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '65% Complete',
                                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: 0.65,
                                minHeight: 8,
                                backgroundColor: Theme.of(context).dividerColor,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () => context.push('/video-player/1'),
                              child: const Text('Continue Watching'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Upcoming Live Classes', style: Theme.of(context).textTheme.titleLarge),
                    TextButton(onPressed: () => context.go('/live-classes'), child: const Text('View All')),
                  ],
                ),
                const SizedBox(height: 12),
                _liveRow(context, 'Mathematics', 'Integration - Definite Integrals', 'Today, 4:00 PM', 'Mr. Sharma'),
                const SizedBox(height: 12),
                _liveRow(context, 'Chemistry', 'Organic Chemistry Basics', 'Tomorrow, 10:00 AM', 'Dr. Verma'),
                const SizedBox(height: 28),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFFDB2777)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Test Your Knowledge!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Take a quick quiz to assess your learning progress',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => context.push('/tests'),
                        child: const Text('Start Quiz'),
                      ),
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

  Widget _liveRow(BuildContext context, String subject, String topic, String time, String teacher) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_today_outlined, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(topic, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: muted)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: muted),
                    const SizedBox(width: 4),
                    Flexible(child: Text(time, style: TextStyle(fontSize: 12, color: muted), overflow: TextOverflow.ellipsis)),
                    Text('  •  ', style: TextStyle(color: muted, fontSize: 12)),
                    Flexible(child: Text(teacher, style: TextStyle(fontSize: 12, color: muted), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => context.push('/live-class/${subject.toLowerCase()}'),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value, required this.label, required this.iconColor});

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
