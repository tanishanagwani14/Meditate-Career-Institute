import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    _NavItem(Icons.home_outlined, Icons.home, 'Home', '/home'),
    _NavItem(Icons.menu_book_outlined, Icons.menu_book, 'Courses', '/courses'),
    _NavItem(Icons.videocam_outlined, Icons.videocam, 'Live', '/live-classes'),
    _NavItem(Icons.chat_bubble_outline, Icons.chat_bubble, 'Doubts', '/doubts'),
    _NavItem(Icons.person_outline, Icons.person, 'Profile', '/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Material(
        elevation: 8,
        color: Theme.of(context).cardColor,
        child: SafeArea(
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              height: 64,
              labelTextStyle: WidgetStateProperty.resolveWith((s) {
                final selected = s.contains(WidgetState.selected);
                return TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? primary : muted,
                );
              }),
            ),
            child: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: navigationShell.goBranch,
              indicatorColor: primary.withValues(alpha: 0.12),
              destinations: [
                for (final item in _items)
                  NavigationDestination(
                    icon: Icon(item.outlined),
                    selectedIcon: Icon(item.filled, color: primary),
                    label: item.label,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.outlined, this.filled, this.label, this.path);
  final IconData outlined;
  final IconData filled;
  final String label;
  final String path;
}
