import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/stat_card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static final _tickets = [
    (
      'TKT-1847',
      'Payment integration not working',
      'Bright Future Academy',
      'High',
      'Open',
      'Support Team',
      '2024-05-02',
    ),
    (
      'TKT-1846',
      'User cannot access courses',
      'Tech Learning Hub',
      'Medium',
      'In Progress',
      'Sarah Chen',
      '2024-05-02',
    ),
    (
      'TKT-1845',
      'White-label setup assistance',
      'Global Institute',
      'Low',
      'Resolved',
      'Michael Brown',
      '2024-05-01',
    ),
    (
      'TKT-1844',
      'Data export request',
      'Smart Academy',
      'Medium',
      'Open',
      'Support Team',
      '2024-05-01',
    ),
    (
      'TKT-1843',
      'API integration question',
      'Elite Education Center',
      'Low',
      'Resolved',
      'Tech Support',
      '2024-04-30',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Support Center',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Escalated ticket management and support operations',
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
                    label: 'Open Tickets',
                    value: '24',
                    change: '8 escalated',
                    changeType: StatChangeType.negative,
                    icon: Icons.error_outline,
                    iconBackground: Color(0xFFFEE2E2),
                    iconColor: Color(0xFFDC2626),
                  ),
                  EnterpriseStatCard(
                    label: 'In Progress',
                    value: '15',
                    change: 'Being handled',
                    changeType: StatChangeType.neutral,
                    icon: Icons.schedule,
                    iconBackground: Color(0xFFFEF9C3),
                    iconColor: Color(0xFFD97706),
                  ),
                  EnterpriseStatCard(
                    label: 'Resolved Today',
                    value: '38',
                    change: '+12 from yesterday',
                    changeType: StatChangeType.positive,
                    icon: Icons.check_circle_outline,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'Avg Response Time',
                    value: '2.4h',
                    change: '-18 min improvement',
                    changeType: StatChangeType.positive,
                    icon: Icons.schedule,
                    iconBackground: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF2563EB),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          AppDataTable(
            columns: const [
              'Ticket ID',
              'Subject',
              'Institute',
              'Priority',
              'Status',
              'Assignee',
              'Created',
            ],
            rows: [
              for (final t in _tickets)
                [
                  t.$1,
                  t.$2,
                  t.$3,
                  DashboardBadges.ticketPriority(t.$4),
                  DashboardBadges.ticketStatus(t.$5),
                  t.$6,
                  t.$7,
                ],
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;
              final cat = _card(
                'Ticket Categories',
                Column(
                  children: [
                    for (final x in _cats)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(x.$1, style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray700)),
                                Text(
                                  '${x.$2} tickets',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: EnterpriseTheme.gray900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: x.$3 / 100,
                                minHeight: 8,
                                backgroundColor: EnterpriseTheme.gray100,
                                color: EnterpriseTheme.indigo600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
              final perf = _card(
                'Support Team Performance',
                Column(
                  children: [
                    for (final m in _team)
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
                                      m.$1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: EnterpriseTheme.gray900,
                                      ),
                                    ),
                                    Text(
                                      '${m.$2} resolved • Avg: ${m.$3}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: EnterpriseTheme.gray600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${m.$4}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: EnterpriseTheme.gray900,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.star, size: 18, color: Color(0xFFEAB308)),
                                ],
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
                    Expanded(child: cat),
                    const SizedBox(width: 24),
                    Expanded(child: perf),
                  ],
                );
              }
              return Column(children: [cat, const SizedBox(height: 24), perf]);
            },
          ),
          const SizedBox(height: 24),
          _card(
            'Recent Activity',
            Column(
              children: [
                for (final a in _activity)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: a.$3,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            a.$1,
                            style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray900),
                          ),
                        ),
                        Text(
                          a.$2,
                          style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
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

const _cats = <(String, int, int)>[
  ('Technical Issues', 42, 35),
  ('Account Management', 28, 23),
  ('Billing Inquiries', 24, 20),
  ('Feature Requests', 18, 15),
  ('Other', 8, 7),
];

const _team = <(String, int, String, double)>[
  ('Sarah Chen', 142, '1.8h', 4.9),
  ('Michael Brown', 128, '2.1h', 4.8),
  ('Support Team', 98, '3.2h', 4.6),
  ('Tech Support', 85, '2.9h', 4.7),
];

const _activity = <(String, String, Color)>[
  ('TKT-1847 escalated to engineering', '5 min ago', Color(0xFFEF4444)),
  ('TKT-1845 resolved and closed', '18 min ago', Color(0xFF22C55E)),
  ('TKT-1846 assigned to Sarah Chen', '32 min ago', Color(0xFF3B82F6)),
  ('New ticket TKT-1847 created', '45 min ago', Color(0xFF9CA3AF)),
  ('TKT-1842 updated with customer response', '1 hour ago', Color(0xFF9CA3AF)),
];
