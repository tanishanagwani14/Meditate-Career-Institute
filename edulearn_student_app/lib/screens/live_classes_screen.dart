import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class LiveClassesScreen extends StatefulWidget {
  const LiveClassesScreen({super.key, this.from});

  // Optional origin hint (e.g. 'notifications') controlling the back arrow.
  final String? from;

  @override
  State<LiveClassesScreen> createState() => _LiveClassesScreenState();
}

class _LiveClassesScreenState extends State<LiveClassesScreen> {
  static const _filters = ['All', 'Today', 'Tomorrow', 'This Week'];
  String _filter = 'All';

  static const _upcoming = [
    _Live(
      id: 1,
      subject: 'Mathematics',
      topic: 'Integration - Definite Integrals',
      teacher: 'Mr. Sharma',
      time: 'Today, 4:00 PM',
      duration: '90 min',
      attendees: 245,
      upcoming: true,
      grad: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    ),
    _Live(
      id: 2,
      subject: 'Chemistry',
      topic: 'Organic Chemistry Basics',
      teacher: 'Dr. Verma',
      time: 'Tomorrow, 10:00 AM',
      duration: '60 min',
      attendees: 189,
      upcoming: false,
      grad: [Color(0xFF22C55E), Color(0xFF059669)],
    ),
    _Live(
      id: 3,
      subject: 'Physics',
      topic: 'Electromagnetic Induction',
      teacher: 'Prof. Kumar',
      time: 'Tomorrow, 3:00 PM',
      duration: '75 min',
      attendees: 312,
      upcoming: false,
      grad: [Color(0xFFA855F7), Color(0xFFDB2777)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (widget.from == 'notifications' || Navigator.of(context).canPop())
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Live Classes', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              Text('Join interactive sessions', style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                            ],
                          ),
                        ],
                      ),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.12)),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calendar view coming soon')),
                          );
                        },
                        icon: const Icon(Icons.calendar_today_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final f in _filters)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _FilterPill(
                              label: f,
                              selected: _filter == f,
                              selectedTextColor: primary,
                              onTap: () => setState(() => _filter = f),
                            ),
                          ),
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
                const Text('Upcoming Classes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 12),
                for (final c in _upcoming) ...[
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: c.grad),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
                                    child: Text(c.subject, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primary)),
                                  ),
                                  if (c.upcoming)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Text('Starting Soon', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFEF4444))),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(c.topic, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                              Text(c.teacher, style: TextStyle(color: muted, fontSize: 13)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.schedule, size: 16, color: muted),
                                  const SizedBox(width: 4),
                                  Text(c.time, style: TextStyle(fontSize: 12, color: muted)),
                                  const SizedBox(width: 16),
                                  Icon(Icons.videocam_outlined, size: 16, color: muted),
                                  const SizedBox(width: 4),
                                  Text(c.duration, style: TextStyle(fontSize: 12, color: muted)),
                                  const SizedBox(width: 16),
                                  Icon(Icons.people_outline, size: 16, color: muted),
                                  const SizedBox(width: 4),
                                  Text('${c.attendees}', style: TextStyle(fontSize: 12, color: muted)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () {
                                        GoRouter.of(context).push('/live-class/${c.id}');
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.videocam, size: 18),
                                          SizedBox(width: 8),
                                          Text('Join Now'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!c.upcoming) ...[
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Reminder set for ${c.topic}')),
                                        );
                                      },
                                      icon: const Icon(Icons.notifications_active_outlined, size: 18),
                                      label: const Text('Remind'),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Past Recordings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All recordings coming soon')),
                        );
                      },
                      child: const Row(children: [Text('View All'), Icon(Icons.chevron_right, size: 18)]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFF97316), Color(0xFFDC2626)]),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: const Icon(Icons.videocam, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Cell Structure and Functions', style: TextStyle(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text('Dr. Priya', style: TextStyle(fontSize: 12, color: muted)),
                            Text('Yesterday • 60 min', style: TextStyle(fontSize: 11, color: muted)),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => GoRouter.of(context).push('/video-player/recording-1'),
                        child: const Text('Watch'),
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
}

class _Live {
  const _Live({
    required this.id,
    required this.subject,
    required this.topic,
    required this.teacher,
    required this.time,
    required this.duration,
    required this.attendees,
    required this.upcoming,
    required this.grad,
  });
  final int id;
  final String subject;
  final String topic;
  final String teacher;
  final String time;
  final String duration;
  final int attendees;
  final bool upcoming;
  final List<Color> grad;
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedTextColor,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedTextColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : Colors.white.withValues(alpha: 0.18);
    final fg = selected ? selectedTextColor : Colors.white;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: icon == null ? 16 : 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
