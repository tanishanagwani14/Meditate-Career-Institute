import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme_controller.dart';
import 'shell_navigation.dart';
import 'sidebar_nav.dart';

class RootShell extends StatelessWidget {
  const RootShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wide = c.maxWidth >= 980;
        return Scaffold(
          drawer: wide ? null : Drawer(child: SafeArea(child: SidebarNav(onNavigate: (p) => context.go(p)))),
          body: Row(
            children: [
              if (wide)
                SizedBox(
                  width: 260,
                  child: Material(
                    color: Theme.of(context).cardColor,
                    child: SafeArea(child: SidebarNav(onNavigate: (p) => context.go(p))),
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    _TopBar(wide: wide),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Material(
      color: Theme.of(context).cardColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
          child: Row(
            children: [
              if (!wide)
                Builder(
                  builder: (ctx) {
                    final scaffold = Scaffold.maybeOf(ctx);
                    if (scaffold == null || !scaffold.hasDrawer) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      onPressed: scaffold.openDrawer,
                      icon: const Icon(Icons.menu),
                    );
                  },
                ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search students, teachers, courses...',
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    hintStyle: TextStyle(color: muted),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const ShellHeaderActions(),
              ListenableBuilder(
                listenable: appThemeController,
                builder: (_, __) => IconButton(
                  onPressed: appThemeController.toggle,
                  icon: Icon(appThemeController.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                  tooltip: 'Toggle theme',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

