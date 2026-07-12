import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  int _tab = 0;

  late final List<(String, String, bool, String)> _features = [
    ('AI-Powered Recommendations', 'ai_recommendations', true, 'Machine learning course suggestions'),
    ('Advanced Analytics Dashboard', 'advanced_analytics', true, 'Enhanced reporting features'),
    ('Live Video Streaming', 'live_streaming', false, 'Real-time class streaming'),
    ('Gamification Module', 'gamification', true, 'Points, badges, leaderboards'),
    ('Mobile App Beta', 'mobile_beta', false, 'Native mobile application access'),
    ('White-label API', 'whitelabel_api', true, 'Custom branding API endpoints'),
  ];

  bool _maintenanceMode = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Feature toggles, platform configurations, and global notifications',
            style: TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
          ),
          const SizedBox(height: 16),
          _tabs(),
          const SizedBox(height: 24),
          if (_tab == 0)
            Column(
              children: [
                for (final f in _features)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: EnterpriseTheme.gray200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        f.$1,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: EnterpriseTheme.gray900,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: f.$3
                                            ? const Color(0xFFD1FAE5)
                                            : EnterpriseTheme.gray100,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        f.$3 ? 'Enabled' : 'Disabled',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: f.$3
                                              ? const Color(0xFF047857)
                                              : EnterpriseTheme.gray700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  f.$4,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: EnterpriseTheme.gray600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Key: ${f.$2}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: EnterpriseTheme.gray500,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: f.$3,
                            onChanged: (v) => setState(() {
                              final idx = _features.indexOf(f);
                              if (idx >= 0) {
                                _features[idx] = (f.$1, f.$2, v, f.$4);
                              }
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          if (_tab == 1)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: EnterpriseTheme.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Platform Configuration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: EnterpriseTheme.gray900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, c) {
                      final narrow = c.maxWidth < 560;
                      final row1 = Row(
                        children: [
                          Expanded(child: _field('Platform Name', 'EduTech Platform')),
                          if (!narrow) const SizedBox(width: 24),
                          if (!narrow) Expanded(child: _field('Support Email', 'support@edutech.com')),
                        ],
                      );
                      final row2 = Row(
                        children: [
                          Expanded(child: _dropdown('Default Language', ['English (US)', 'Spanish'])),
                          if (!narrow) const SizedBox(width: 24),
                          if (!narrow) Expanded(child: _dropdown('Default Timezone', ['UTC', 'America/New_York'])),
                        ],
                      );
                      if (narrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _field('Platform Name', 'EduTech Platform'),
                            const SizedBox(height: 16),
                            _field('Support Email', 'support@edutech.com'),
                            const SizedBox(height: 16),
                            _dropdown('Default Language', ['English (US)', 'Spanish']),
                            const SizedBox(height: 16),
                            _dropdown('Default Timezone', ['UTC', 'America/New_York']),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          row1,
                          const SizedBox(height: 16),
                          row2,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _labeled(
                    'API Rate Limit',
                    Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            initialValue: '1000',
                            decoration: const InputDecoration(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'requests per hour',
                          style: TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: EnterpriseTheme.gray50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Maintenance Mode',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: EnterpriseTheme.gray900,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Temporarily disable platform access',
                                style: TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
                              ),
                            ],
                          ),
                        ),
                        Switch(value: _maintenanceMode, onChanged: (v) => setState(() => _maintenanceMode = v)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(onPressed: () {}, child: const Text('Reset to Defaults')),
                      const SizedBox(width: 12),
                      ElevatedButton(onPressed: () {}, child: const Text('Save Changes')),
                    ],
                  ),
                ],
              ),
            ),
          if (_tab == 2)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EnterpriseTheme.gray200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create Global Notification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: EnterpriseTheme.gray900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _dropdown('Notification Type', [
                        'Information',
                        'Warning',
                        'Critical',
                        'Maintenance',
                      ]),
                      const SizedBox(height: 16),
                      _labeled(
                        'Message',
                        const TextField(
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter notification message...',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _labeled('Start Date', const TextField(decoration: InputDecoration()))),
                          const SizedBox(width: 16),
                          Expanded(child: _labeled('End Date', const TextField(decoration: InputDecoration()))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Publish Notification'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: EnterpriseTheme.gray200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Active Notifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: EnterpriseTheme.gray900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (final n in _notifs)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: EnterpriseTheme.gray50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: n.$1 == 'Maintenance'
                                                  ? const Color(0xFFFEF9C3)
                                                  : const Color(0xFFDBEAFE),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              n.$1,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: n.$1 == 'Maintenance'
                                                    ? const Color(0xFFA16207)
                                                    : const Color(0xFF1D4ED8),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            n.$4,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: EnterpriseTheme.gray500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        n.$2,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: EnterpriseTheme.gray900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Start: ${n.$3}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: EnterpriseTheme.gray500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Remove',
                                    style: TextStyle(color: Color(0xFFDC2626)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _tabs() {
    Widget t(String label, IconData icon, int i) {
      final sel = _tab == i;
      return InkWell(
        onTap: () => setState(() => _tab = i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: sel ? EnterpriseTheme.indigo600 : EnterpriseTheme.gray600),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: sel ? EnterpriseTheme.indigo600 : EnterpriseTheme.gray600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                width: 140,
                decoration: BoxDecoration(
                  color: sel ? EnterpriseTheme.indigo600 : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: EnterpriseTheme.gray200)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            t('Feature Toggles', Icons.bolt_outlined, 0),
            t('Platform Config', Icons.storage_outlined, 1),
            t('Global Notifications', Icons.notifications_outlined, 2),
          ],
        ),
      ),
    );
  }

  static Widget _field(String label, String initial) {
    return _labeled(
      label,
      TextFormField(
        initialValue: initial,
        decoration: const InputDecoration(),
      ),
    );
  }

  static Widget _dropdown(String label, List<String> items) {
    return _labeled(
      label,
      DropdownButtonFormField<String>(
        initialValue: items.first,
        items: [
          for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
        ],
        onChanged: (_) {},
        decoration: const InputDecoration(),
      ),
    );
  }

  static Widget _labeled(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: EnterpriseTheme.gray700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

const _notifs = <(String, String, String, String)>[
  (
    'Maintenance',
    'Scheduled maintenance on May 5, 2024 from 2:00 AM - 4:00 AM UTC',
    '2024-05-05',
    'Scheduled',
  ),
  (
    'Information',
    'New feature release: AI-powered course recommendations now available',
    '2024-05-01',
    'Active',
  ),
];
