import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/theme_controller.dart';
import '../../widgets/shared/page_header.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Settings',
          subtitle: 'Manage your admin preferences',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListenableBuilder(
                listenable: appThemeController,
                builder: (_, __) => SwitchListTile(
                  title: const Text('Dark mode'),
                  subtitle: const Text('Toggle light / dark theme'),
                  value: appThemeController.isDark,
                  onChanged: (_) => appThemeController.toggle(),
                ),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Email notifications'),
                subtitle: const Text('Receive alerts for fee and enrollment updates'),
                value: true,
                onChanged: (v) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email notifications ${v ? 'enabled' : 'disabled'}')),
                  );
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('SMS notifications'),
                subtitle: const Text('Send SMS for urgent institute alerts'),
                value: false,
                onChanged: (v) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('SMS notifications ${v ? 'enabled' : 'disabled'}')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Change password'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password change coming soon')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
