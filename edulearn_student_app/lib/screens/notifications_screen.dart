import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class NotificationItem {
  NotificationItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    required this.unread,
    required this.iconColor,
    required this.iconBg,
    required this.route,
  });
  final int id;
  final IconData icon;
  final String title;
  final String message;
  final String time;
  bool unread;
  final Color iconColor;
  final Color iconBg;
  // Where the "View" button should take the user.
  final String route;
}

// Shared in-memory store so the GoRouter `/notifications/:id` detail route
// can look up a notification by id without depending on `state.extra`
// (which is lost on deep links / hot restarts).
class NotificationsStore {
  NotificationsStore._();
  static final NotificationsStore instance = NotificationsStore._();

  final List<NotificationItem> items = [
    NotificationItem(
      id: 1,
      icon: Icons.calendar_today_outlined,
      title: 'Live Class Starting Soon',
      message: 'Mathematics - Integration starts in 30 minutes. Join Mr. Sharma '
          'for an interactive session on definite integrals, common patterns and JEE-style problem solving.',
      time: '30 min ago',
      unread: true,
      iconColor: const Color(0xFF3B82F6),
      iconBg: const Color(0x1A3B82F6),
      route: '/live-classes',
    ),
    NotificationItem(
      id: 2,
      icon: Icons.emoji_events_outlined,
      title: 'New Achievement Unlocked!',
      message: 'You earned the "7-Day Streak" badge. Keep showing up daily to '
          'level up to the 30-Day Streak badge and earn bonus reward points.',
      time: '2 hours ago',
      unread: true,
      iconColor: const Color(0xFFEAB308),
      iconBg: const Color(0x1AEAB308),
      route: '/achievements',
    ),
    NotificationItem(
      id: 3,
      icon: Icons.chat_bubble_outline,
      title: 'Your Doubt Was Answered',
      message: 'Dr. Sharma answered your Physics question about magnetic flux through a solenoid. '
          'Tap to view the full explanation in your doubts thread.',
      time: '5 hours ago',
      unread: false,
      iconColor: const Color(0xFF22C55E),
      iconBg: const Color(0x1A22C55E),
      route: '/doubts?tab=solved',
    ),
    NotificationItem(
      id: 4,
      icon: Icons.menu_book_outlined,
      title: 'New Course Content Added',
      message: '5 new lessons added to JEE Main Physics. The latest module covers '
          'electromagnetic induction with worked examples and practice problems.',
      time: '1 day ago',
      unread: false,
      iconColor: const Color(0xFFA855F7),
      iconBg: const Color(0x1AA855F7),
      route: '/courses/1',
    ),
  ];

  NotificationItem? byId(int id) {
    for (final n in items) {
      if (n.id == id) return n;
    }
    return null;
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationItem> get _items => NotificationsStore.instance.items;

  void _markAllAsRead() {
    final unread = _items.where((e) => e.unread).length;
    if (unread == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No unread notifications')),
      );
      return;
    }
    setState(() {
      for (final n in _items) {
        n.unread = false;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked $unread notifications as read')),
    );
  }

  void _openNotification(NotificationItem n) {
    if (n.unread) {
      setState(() => n.unread = false);
    }
    // Push the detail as a real GoRouter route so the subsequent navigation
    // from the detail's "View" button stays inside GoRouter and does not
    // collide with an imperative MaterialPageRoute (which previously caused
    // Navigator's `_debugCheckDuplicatedPageKeys` to fire when navigating to
    // shell-branch routes such as /doubts or /courses/1).
    context.push('/notifications/${n.id}');
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final unreadCount = _items.where((e) => e.unread).length;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
            ),
            padding: const EdgeInsets.fromLTRB(8, 40, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                    const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$unreadCount unread', style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                      TextButton(
                        onPressed: _markAllAsRead,
                        child: Text(
                          'Mark all as read',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                for (final n in _items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      color: n.unread ? primary.withValues(alpha: 0.04) : null,
                      border: n.unread ? BorderSide(color: primary.withValues(alpha: 0.25), width: 2) : null,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _openNotification(n),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: n.iconBg,
                                child: Icon(n.icon, color: n.iconColor, size: 26),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600))),
                                        if (n.unread)
                                          Container(
                                            width: 8,
                                            height: 8,
                                            margin: const EdgeInsets.only(top: 6, left: 6),
                                            decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      n.message,
                                      style: TextStyle(fontSize: 13, color: muted, height: 1.35),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(n.time, style: TextStyle(fontSize: 11, color: muted)),
                                  ],
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
        ],
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    final notif = NotificationsStore.instance.byId(id);
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    if (notif == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Notification not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: notif.iconBg,
                child: Icon(notif.icon, color: notif.iconColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.3)),
                    const SizedBox(height: 6),
                    Text(notif.time, style: TextStyle(color: muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Text(notif.message, style: const TextStyle(fontSize: 15, height: 1.5)),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Dismiss'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final messenger = ScaffoldMessenger.of(context);
                    final route = notif.route;
                    final title = notif.title;
                    final separator = route.contains('?') ? '&' : '?';
                    final target = '$route${separator}from=notifications';
                    // `go` (not push) avoids the "duplicate page keys"
                    // assertion that fires when pushing into shell-branch
                    // routes (/doubts, /live-classes, /courses/:id) — pushing
                    // re-mounts the StatefulShellRoute page. Each destination
                    // reads `from=notifications` and wires its back arrow to
                    // return here.
                    context.go(target);
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text('Opening: $title'),
                        backgroundColor: primary,
                      ),
                    );
                  },
                  child: const Text('View'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
