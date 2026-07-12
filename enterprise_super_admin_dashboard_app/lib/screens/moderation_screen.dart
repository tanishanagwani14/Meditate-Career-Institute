import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/stat_card.dart';

class ModerationScreen extends StatefulWidget {
  const ModerationScreen({super.key});

  @override
  State<ModerationScreen> createState() => _ModerationScreenState();
}

class _ModerationScreenState extends State<ModerationScreen> {
  int _tab = 0;

  static final _flagged = [
    ('Course', 'Advanced Mathematics Course', 'Bright Future Academy', 'Copyright concern', 'Medium', '2024-05-02'),
    ('Comment', 'Inappropriate language in discussion', 'Tech Learning Hub', 'Community guidelines', 'High', '2024-05-02'),
    ('Assignment', 'Physics Assignment #12', 'Global Institute', 'Plagiarism detected', 'High', '2024-05-01'),
    ('Post', 'Student forum post', 'Smart Academy', 'Spam content', 'Low', '2024-05-01'),
  ];

  static const _compliance = <({String check, String status, String last, String institutes})>[
    (check: 'GDPR Compliance', status: 'Passed', last: '2024-05-01', institutes: '225'),
    (check: 'Data Retention Policy', status: 'Passed', last: '2024-04-28', institutes: '225'),
    (check: 'Content Age Restrictions', status: 'Warning', last: '2024-05-02', institutes: '223'),
    (check: 'Accessibility Standards', status: 'Passed', last: '2024-04-30', institutes: '220'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Content Moderation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Review flagged content and compliance controls',
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
                    label: 'Pending Review',
                    value: '18',
                    change: 'Requires action',
                    changeType: StatChangeType.negative,
                    icon: Icons.warning_amber_outlined,
                    iconBackground: Color(0xFFFEF9C3),
                    iconColor: Color(0xFFD97706),
                  ),
                  EnterpriseStatCard(
                    label: 'Resolved Today',
                    value: '42',
                    change: '+8 from yesterday',
                    changeType: StatChangeType.positive,
                    icon: Icons.check_circle_outline,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'Active Flags',
                    value: '127',
                    change: 'Across all institutes',
                    changeType: StatChangeType.neutral,
                    icon: Icons.shield_outlined,
                    iconBackground: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF2563EB),
                  ),
                  EnterpriseStatCard(
                    label: 'Compliance Score',
                    value: '98.2%',
                    change: 'Platform-wide',
                    changeType: StatChangeType.positive,
                    icon: Icons.shield_outlined,
                    iconBackground: Color(0xFFE0E7FF),
                    iconColor: EnterpriseTheme.indigo600,
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
              columns: const [
                'Content Type',
                'Title',
                'Institute',
                'Flag Reason',
                'Severity',
                'Flagged Date',
              ],
              rows: [
                for (final r in _flagged)
                  [
                    r.$1,
                    r.$2,
                    r.$3,
                    r.$4,
                    DashboardBadges.severity(r.$5),
                    r.$6,
                  ],
              ],
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth >= 900;
                final left = _card(
                  'Moderation Actions',
                  Column(
                    children: [
                      for (final a in _actions)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      a.$1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: EnterpriseTheme.gray900,
                                      ),
                                    ),
                                    Text(
                                      'by ${a.$2}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: EnterpriseTheme.gray500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                a.$3,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: EnterpriseTheme.gray500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
                final right = _card(
                  'Flag Categories',
                  Column(
                    children: [
                      for (final f in _categories)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    f.$1,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: EnterpriseTheme.gray700,
                                    ),
                                  ),
                                  Text(
                                    '${f.$2}',
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
                                  value: f.$2 / 127,
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
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: left),
                      const SizedBox(width: 24),
                      Expanded(child: right),
                    ],
                  );
                }
                return Column(children: [left, const SizedBox(height: 24), right]);
              },
            ),
          ],
          if (_tab == 1)
            Column(
              children: [
                for (final c in _compliance)
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
                          _statusIcon(c.status),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.check,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: EnterpriseTheme.gray900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Last checked: ${c.last} • ${c.institutes} institutes',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: EnterpriseTheme.gray600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('View Details'),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Run Check'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
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
                width: 120,
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
      child: Row(
        children: [
          t('Flagged Content', 0),
          t('Compliance Controls', 1),
        ],
      ),
    );
  }

  static Widget _statusIcon(String status) {
    final icon = switch (status) {
      'Passed' => Icons.check_circle,
      'Warning' => Icons.warning_amber,
      _ => Icons.cancel,
    };
    final color = switch (status) {
      'Passed' => const Color(0xFF16A34A),
      'Warning' => const Color(0xFFD97706),
      _ => const Color(0xFFDC2626),
    };
    return Icon(icon, size: 28, color: color);
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
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }
}

const _actions = <(String, String, String)>[
  ('Content approved', 'Admin User', '10 min ago'),
  ('User warning issued', 'Sarah Chen', '25 min ago'),
  ('Content removed', 'Michael Brown', '1 hour ago'),
  ('Institute notified', 'Admin User', '2 hours ago'),
];

const _categories = <(String, int)>[
  ('Copyright Issues', 45),
  ('Community Guidelines', 38),
  ('Spam Content', 22),
  ('Plagiarism', 18),
  ('Other', 4),
];
