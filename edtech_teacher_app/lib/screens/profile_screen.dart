import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';
import '../widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w600))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(radius: 28, backgroundColor: primary.withValues(alpha: 0.12), child: Text('T', style: TextStyle(color: primary, fontWeight: FontWeight.w800))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Teacher', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('teacher@edtech.com', style: TextStyle(color: muted, fontSize: 12)),
                    ],
                  ),
                ),
                ListenableBuilder(
                  listenable: appThemeController,
                  builder: (_, __) => IconButton(
                    onPressed: appThemeController.toggle,
                    icon: Icon(appThemeController.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('Account Settings'), onTap: () {}),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.notifications_outlined), title: const Text('Notifications'), onTap: () {}),
                const Divider(height: 1),
                ListTile(leading: const Icon(Icons.help_outline), title: const Text('Help & Support'), onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

