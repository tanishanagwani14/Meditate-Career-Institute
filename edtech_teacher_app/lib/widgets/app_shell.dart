import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme_controller.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  Widget build(BuildContext context) {
    final route = GoRouterState.of(context).uri.toString();
    final hideBars = route.startsWith('/live-class') ||
        route.startsWith('/courses/create') ||
        route.startsWith('/courses/create-test');

    return Scaffold(
      drawer: _AppDrawer(onNavigate: (path) {
        Navigator.of(context).pop();
        context.push(path);
      }),
      body: Column(
        children: [
          if (!hideBars)
            _TopBar(
              title: _titleForIndex(widget.navigationShell.currentIndex),
              onMenu: () => Scaffold.of(context).openDrawer(),
              onSearch: () => showAppSearch(context),
              onNotifications: () => showNotificationsSheet(context),
              onProfile: () => context.push('/profile'),
              notifications: 3,
            ),
          Expanded(child: widget.navigationShell),
        ],
      ),
      bottomNavigationBar: hideBars
          ? null
          : SafeArea(
              child: NavigationBar(
                height: 64,
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: widget.navigationShell.goBranch,
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
                  NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Courses'),
                  NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Students'),
                  NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
                ],
              ),
            ),
    );
  }

  String _titleForIndex(int i) {
    return switch (i) {
      0 => 'Dashboard',
      1 => 'My Courses',
      2 => 'Students',
      3 => 'Messages',
      _ => 'Teacher App',
    };
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onMenu,
    required this.onSearch,
    required this.onNotifications,
    required this.onProfile,
    required this.notifications,
  });
  final String title;
  final VoidCallback onMenu;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;
  final int notifications;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: Row(
            children: [
              IconButton(onPressed: onMenu, icon: const Icon(Icons.menu)),
              const SizedBox(width: 4),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
              IconButton(onPressed: onSearch, icon: const Icon(Icons.search)),
              ListenableBuilder(
                listenable: appThemeController,
                builder: (_, __) => IconButton(
                  onPressed: appThemeController.toggle,
                  icon: Icon(appThemeController.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(onPressed: onNotifications, icon: const Icon(Icons.notifications_none)),
                  if (notifications > 0)
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                    ),
                ],
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onProfile,
                  customBorder: const CircleBorder(),
                  child: const CircleAvatar(radius: 16, child: Text('T')),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer({required this.onNavigate});
  final void Function(String path) onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Menu', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 12),
              _item(context, 'Analytics', Icons.insights_outlined, () => onNavigate('/analytics')),
              _item(context, 'Calendar', Icons.calendar_month_outlined, () => onNavigate('/calendar')),
              _item(context, 'Live Classes', Icons.videocam_outlined, () => onNavigate('/live-class')),
              _item(context, 'Create Test', Icons.note_add_outlined, () => onNavigate('/courses/create-test')),
              _item(context, 'Create Course', Icons.add_box_outlined, () => onNavigate('/courses/create')),
              _item(context, 'Profile', Icons.person_outline, () => onNavigate('/profile')),
              const Spacer(),
              Text('EdTech Teacher UI', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Theme.of(context).cardColor,
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}

class _SearchDestination {
  const _SearchDestination({
    required this.label,
    required this.path,
    required this.icon,
    this.fullScreen = false,
  });

  final String label;
  final String path;
  final IconData icon;
  final bool fullScreen;
}

const _searchDestinations = [
  _SearchDestination(label: 'Dashboard', path: '/dashboard', icon: Icons.home_outlined),
  _SearchDestination(label: 'My Courses', path: '/courses', icon: Icons.menu_book_outlined),
  _SearchDestination(label: 'Students', path: '/students', icon: Icons.people_outline),
  _SearchDestination(label: 'Messages', path: '/messages', icon: Icons.chat_bubble_outline),
  _SearchDestination(label: 'Analytics', path: '/analytics', icon: Icons.insights_outlined, fullScreen: true),
  _SearchDestination(label: 'Calendar', path: '/calendar', icon: Icons.calendar_month_outlined, fullScreen: true),
  _SearchDestination(label: 'Live Classes', path: '/live-class', icon: Icons.videocam_outlined, fullScreen: true),
  _SearchDestination(label: 'Profile', path: '/profile', icon: Icons.person_outline, fullScreen: true),
];

void showAppSearch(BuildContext context) {
  showSearch<void>(
    context: context,
    delegate: _AppSearchDelegate(),
  );
}

class _AppSearchDelegate extends SearchDelegate<void> {
  List<_SearchDestination> get _matches {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _searchDestinations;
    return _searchDestinations.where((d) => d.label.toLowerCase().contains(q)).toList();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final matches = _matches;
    if (matches.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final d = matches[index];
        return ListTile(
          leading: Icon(d.icon),
          title: Text(d.label),
          onTap: () {
            close(context, null);
            if (d.fullScreen) {
              context.push(d.path);
            } else {
              context.go(d.path);
            }
          },
        );
      },
    );
  }
}

class _AppNotification {
  const _AppNotification({
    required this.title,
    required this.time,
    required this.icon,
    required this.route,
    this.fullScreen = false,
  });

  final String title;
  final String time;
  final IconData icon;
  final String route;
  final bool fullScreen;
}

const _appNotifications = [
  _AppNotification(
    title: 'New student enrolled in "Complete JEE Course"',
    time: '5 mins ago',
    icon: Icons.person_add_outlined,
    route: '/students',
  ),
  _AppNotification(
    title: 'Assignment submitted by 12 students',
    time: '1 hour ago',
    icon: Icons.assignment_outlined,
    route: '/courses',
  ),
  _AppNotification(
    title: 'New doubt posted in Physics batch',
    time: '2 hours ago',
    icon: Icons.help_outline,
    route: '/live-class',
    fullScreen: true,
  ),
];

void _navigateFromNotification(BuildContext context, _AppNotification n) {
  if (n.fullScreen) {
    context.push(n.route);
  } else {
    context.go(n.route);
  }
}

void showNotificationsSheet(BuildContext context) {
  final muted = Theme.of(context).textTheme.bodySmall?.color;

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
              const SizedBox(height: 12),
              for (final n in _appNotifications) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(n.icon, color: Theme.of(ctx).colorScheme.primary),
                  title: Text(n.title, style: const TextStyle(fontSize: 13)),
                  subtitle: Text(n.time, style: TextStyle(fontSize: 11, color: muted)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateFromNotification(context, n);
                  },
                ),
                if (n != _appNotifications.last) const Divider(height: 1),
              ],
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

