import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/enterprise_theme.dart';

class EnterpriseSidebar extends StatelessWidget {
  const EnterpriseSidebar({
    super.key,
    required this.currentPath,
    this.onNavigate,
  });

  final String currentPath;
  final void Function(String path)? onNavigate;

  static const _items = <({String path, String label, IconData icon})>[
    (path: '/overview', label: 'Platform Overview', icon: Icons.dashboard_outlined),
    (path: '/institutes', label: 'Institute Management', icon: Icons.apartment_outlined),
    (path: '/users', label: 'User Management', icon: Icons.people_outline),
    (path: '/analytics', label: 'Analytics', icon: Icons.trending_up),
    (path: '/moderation', label: 'Moderation', icon: Icons.shield_outlined),
    (path: '/support', label: 'Support Center', icon: Icons.headphones_outlined),
    (path: '/security', label: 'Security', icon: Icons.lock_outline),
    (path: '/settings', label: 'System Settings', icon: Icons.settings_outlined),
    (path: '/regions', label: 'Multi-Region', icon: Icons.public_outlined),
    (path: '/monitoring', label: 'Security Monitor', icon: Icons.monitor_heart_outlined),
    (path: '/billing', label: 'SaaS Billing', icon: Icons.warning_amber_outlined),
  ];

  void _go(BuildContext context, String path) {
    if (onNavigate != null) {
      onNavigate!(path);
    } else {
      context.go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: EnterpriseTheme.gray200)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [EnterpriseTheme.indigo600, Color(0xFF9333EA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EduTech',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: EnterpriseTheme.gray900,
                      ),
                    ),
                    Text(
                      'Super Admin',
                      style: TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final item in _items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _go(context, item.path),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: currentPath == item.path
                                ? const Color(0xFFEEF2FF)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                size: 20,
                                color: currentPath == item.path
                                    ? EnterpriseTheme.indigo600
                                    : EnterpriseTheme.gray700,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: currentPath == item.path
                                        ? EnterpriseTheme.indigo600
                                        : EnterpriseTheme.gray700,
                                  ),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: EnterpriseTheme.gray200)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => context.push('/profile'),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [EnterpriseTheme.indigo600, Color(0xFF9333EA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Text(
                          'AD',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Admin User',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: EnterpriseTheme.gray900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'admin@edutech.com',
                              style: TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: EnterpriseTheme.gray500),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
