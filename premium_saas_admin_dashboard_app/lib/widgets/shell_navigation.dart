import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared navigation for top-bar actions available on every admin screen.
class AppShellNavigation {
  AppShellNavigation._();

  static void openNotifications(BuildContext context) {
    final router = GoRouter.of(context);
    final path = router.state.uri.path;

    // Nested push keeps the current section (e.g. Student Directory) underneath
    // so Back returns to where the user came from.
    if (path.startsWith('/students')) {
      router.push('/students/notifications');
      return;
    }

    router.push('/communication/notifications');
  }

  static void openSettings(BuildContext context) {
    final router = GoRouter.of(context);
    final path = router.state.uri.path;

    if (path.startsWith('/students')) {
      router.push('/students/settings');
      return;
    }

    router.push('/settings');
  }
}

/// Notification + settings icon buttons for the shell top bar and page headers.
class ShellHeaderActions extends StatelessWidget {
  const ShellHeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () => AppShellNavigation.openNotifications(context),
              icon: const Icon(Icons.notifications_none),
              tooltip: 'Notifications',
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () => AppShellNavigation.openSettings(context),
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings',
        ),
      ],
    );
  }
}
