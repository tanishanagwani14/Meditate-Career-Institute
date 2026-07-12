import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/enterprise_theme.dart';
import 'enterprise_sidebar.dart';

class EnterpriseShell extends StatelessWidget {
  const EnterpriseShell({super.key, required this.child});

  final Widget child;

  static const double _sidebarWidth = 256;
  static const double _breakpoint = 1024;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _breakpoint;
        if (wide) {
          // Material is required for InkWell / ink effects (sidebar + page InkWells).
          // Scaffold provides this on narrow layouts; wide layout used only ColoredBox before.
          return Material(
            color: EnterpriseTheme.gray50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _sidebarWidth,
                  child: Material(
                    color: Colors.white,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: EnterpriseTheme.gray200),
                        ),
                      ),
                      child: EnterpriseSidebar(currentPath: path),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    color: EnterpriseTheme.gray50,
                    child: _MainContent(child: child),
                  ),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          backgroundColor: EnterpriseTheme.gray50,
          drawer: Drawer(
            width: _sidebarWidth,
            child: EnterpriseSidebar(
              currentPath: path,
              onNavigate: (p) {
                Navigator.of(context).pop();
                context.go(p);
              },
            ),
          ),
          appBar: AppBar(
            title: const Text('EduTech Super Admin'),
            leading: Builder(
              builder: (ctx) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                );
              },
            ),
          ),
          body: _MainContent(child: child),
        );
      },
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }
}
