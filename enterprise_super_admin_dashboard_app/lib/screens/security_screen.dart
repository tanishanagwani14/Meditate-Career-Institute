import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/stat_card.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  int _tab = 0;

  static final _audit = [
    ('User login', 'john.a@brightfuture.edu', '192.168.1.45', '2024-05-02 14:32:18', 'Success'),
    ('Institute settings changed', 'admin@edutech.com', '10.0.0.15', '2024-05-02 14:28:45', 'Success'),
    ('Failed login attempt', 'unknown@test.com', '185.220.101.12', '2024-05-02 14:15:22', 'Failed'),
    ('API key generated', 'sarah.c@techlearning.com', '172.16.0.28', '2024-05-02 13:58:10', 'Success'),
    ('User permissions modified', 'admin@edutech.com', '10.0.0.15', '2024-05-02 13:42:35', 'Success'),
  ];

  static final _fraud = [
    ('Multiple failed logins', 'Unknown', 'High', '2024-05-02 14:15', 'Active'),
    ('Unusual API usage', 'Tech Learning Hub', 'Medium', '2024-05-02 12:30', 'Investigating'),
    ('Suspicious payment pattern', 'Global Institute', 'Low', '2024-05-01 18:45', 'Resolved'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Security Center',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Audit logs, fraud monitoring, and access controls',
            style: TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth >= 1200 ? 4 : (c.maxWidth >= 720 ? 2 : 1);
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: cols == 1 ? 1.55 : 1.3,
                children: const [
                  EnterpriseStatCard(
                    label: 'Security Score',
                    value: '94/100',
                    change: 'Platform-wide',
                    changeType: StatChangeType.positive,
                    icon: Icons.shield_outlined,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'Active Alerts',
                    value: '3',
                    change: 'Requires attention',
                    changeType: StatChangeType.negative,
                    icon: Icons.warning_amber_outlined,
                    iconBackground: Color(0xFFFEE2E2),
                    iconColor: Color(0xFFDC2626),
                  ),
                  EnterpriseStatCard(
                    label: 'Failed Logins',
                    value: '24',
                    change: 'Last 24 hours',
                    changeType: StatChangeType.neutral,
                    icon: Icons.lock_outline,
                    iconBackground: Color(0xFFFEF9C3),
                    iconColor: Color(0xFFD97706),
                  ),
                  EnterpriseStatCard(
                    label: 'Compliance Status',
                    value: '100%',
                    change: 'All checks passed',
                    changeType: StatChangeType.positive,
                    icon: Icons.check_circle_outline,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          _tabs(),
          const SizedBox(height: 24),
          if (_tab == 0) ...[
            AppDataTable(
              columns: const ['Action', 'User', 'IP Address', 'Timestamp', 'Status'],
              rows: [
                for (final r in _audit)
                  [
                    r.$1,
                    r.$2,
                    r.$3,
                    r.$4,
                    DashboardBadges.auditStatus(r.$5),
                  ],
              ],
            ),
            const SizedBox(height: 24),
            _summaryCard(),
          ],
          if (_tab == 1) ...[
            AppDataTable(
              columns: const ['Alert Type', 'Institute', 'Severity', 'Detected', 'Status'],
              rows: [
                for (final r in _fraud)
                  [
                    r.$1,
                    r.$2,
                    DashboardBadges.severity(r.$3),
                    r.$4,
                    DashboardBadges.auditStatus(r.$5),
                  ],
              ],
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 900;
                final rules = _card(
                  'Fraud Detection Rules',
                  Column(
                    children: [
                      for (final r in _rules)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: EnterpriseTheme.gray50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.$1,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: EnterpriseTheme.gray900,
                                        ),
                                      ),
                                      Text(
                                        r.$2,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: EnterpriseTheme.gray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PillBadgeStatic(label: 'Active', bg: Color(0xFFD1FAE5), fg: Color(0xFF047857)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
                final blocked = _card(
                  'Blocked IP Addresses',
                  Column(
                    children: [
                      for (final b in _blocked)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: EnterpriseTheme.gray50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b.$1,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'monospace',
                                          color: EnterpriseTheme.gray900,
                                        ),
                                      ),
                                      Text(
                                        b.$2,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: EnterpriseTheme.gray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Unblock',
                                    style: TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: rules),
                      const SizedBox(width: 24),
                      Expanded(child: blocked),
                    ],
                  );
                }
                return Column(children: [rules, const SizedBox(height: 24), blocked]);
              },
            ),
          ],
          if (_tab == 2)
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
                    'Access Control Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: EnterpriseTheme.gray900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (final a in _access)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: EnterpriseTheme.gray50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.$1,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: EnterpriseTheme.gray900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    a.$2,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: EnterpriseTheme.gray600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: a.$3,
                              onChanged: (_) {},
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
    );
  }

  Widget _tabs() {
    Widget t(String label, int i) {
      final sel = _tab == i;
      return InkWell(
        onTap: () => setState(() => _tab = i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: sel ? EnterpriseTheme.indigo600 : EnterpriseTheme.gray600,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                width: 100,
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
            t('Audit Logs', 0),
            t('Fraud Monitoring', 1),
            t('Access Controls', 2),
          ],
        ),
      ),
    );
  }

  static Widget _summaryCard() {
    return Container(
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
            'Activity Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final n = c.maxWidth < 600 ? 2 : 4;
              return GridView.count(
                crossAxisCount: n,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: const [
                  _SumTile(title: 'Total Events', value: '1,248', sub: 'Last 24 hours'),
                  _SumTile(title: 'Login Events', value: '342', sub: 'Last 24 hours'),
                  _SumTile(title: 'Config Changes', value: '18', sub: 'Last 24 hours'),
                  _SumTile(title: 'Failed Attempts', value: '24', sub: 'Last 24 hours'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _card(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EnterpriseTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _SumTile extends StatelessWidget {
  const _SumTile({required this.title, required this.value, required this.sub});

  final String title;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EnterpriseTheme.gray50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          Text(sub, style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500)),
        ],
      ),
    );
  }
}

class PillBadgeStatic extends StatelessWidget {
  const PillBadgeStatic({
    super.key,
    required this.label,
    required this.bg,
    required this.fg,
  });

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg)),
    );
  }
}

const _rules = <(String, String)>[
  ('Multiple failed login attempts', '5 attempts / 15 min'),
  ('Unusual geographic access', '2+ countries / day'),
  ('High API request volume', '1000 req / hour'),
  ('Payment pattern anomaly', 'ML-based detection'),
];

const _blocked = <(String, String, String)>[
  ('185.220.101.12', 'Brute force attack', '2024-05-02'),
  ('45.142.215.98', 'Suspicious activity', '2024-05-01'),
  ('91.219.237.44', 'Multiple violations', '2024-04-30'),
];

const _access = <(String, String, bool)>[
  ('Two-Factor Authentication', 'Require 2FA for all admin users', true),
  ('IP Whitelisting', 'Restrict admin access to specific IP ranges', false),
  ('Session Timeout', 'Auto-logout after 30 minutes of inactivity', true),
  ('Login Notifications', 'Email alerts for new device logins', true),
];
