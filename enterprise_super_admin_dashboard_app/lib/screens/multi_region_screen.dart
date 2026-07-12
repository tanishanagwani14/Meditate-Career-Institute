import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/stat_card.dart';

class MultiRegionScreen extends StatelessWidget {
  const MultiRegionScreen({super.key});

  static final _regions = [
    ('US-East', 'N. Virginia', '92', '18,500', '12ms', 'Healthy', '99.99%'),
    ('US-West', 'Oregon', '48', '9,800', '15ms', 'Healthy', '99.98%'),
    ('EU-West', 'Ireland', '58', '11,200', '18ms', 'Healthy', '99.97%'),
    ('EU-Central', 'Frankfurt', '15', '3,100', '14ms', 'Healthy', '99.99%'),
    ('APAC', 'Singapore', '12', '2,600', '22ms', 'Degraded', '99.85%'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Multi-Region Management',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Global infrastructure and regional settings',
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
                    label: 'Active Regions',
                    value: '5',
                    change: 'Across 3 continents',
                    changeType: StatChangeType.positive,
                    icon: Icons.public_outlined,
                    iconBackground: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF2563EB),
                  ),
                  EnterpriseStatCard(
                    label: 'Total Capacity',
                    value: '98.2%',
                    change: 'Optimal distribution',
                    changeType: StatChangeType.positive,
                    icon: Icons.dns_outlined,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'Avg Global Latency',
                    value: '16ms',
                    change: '-2ms improvement',
                    changeType: StatChangeType.positive,
                    icon: Icons.monitor_heart_outlined,
                    iconBackground: Color(0xFFE9D5FF),
                    iconColor: Color(0xFF9333EA),
                  ),
                  EnterpriseStatCard(
                    label: 'Global Uptime',
                    value: '99.96%',
                    change: 'Last 30 days',
                    changeType: StatChangeType.positive,
                    icon: Icons.public_outlined,
                    iconBackground: Color(0xFFE0E7FF),
                    iconColor: EnterpriseTheme.indigo600,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          AppDataTable(
            columns: const [
              'Region',
              'Institutes',
              'Users',
              'Avg Latency',
              'Status',
              'Uptime',
            ],
            rows: [
              for (final r in _regions)
                [
                  Column(
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
                        style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                      ),
                    ],
                  ),
                  r.$3,
                  r.$4,
                  r.$5,
                  DashboardBadges.regionStatus(r.$6),
                  r.$7,
                ],
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;
              final dist = _card(
                'Regional Distribution',
                Column(
                  children: [
                    for (final r in _regions)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.place_outlined, size: 18, color: EnterpriseTheme.gray500),
                                const SizedBox(width: 8),
                                Text(r.$1, style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray700)),
                                const Spacer(),
                                Text(
                                  '${r.$3} institutes',
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
                                value: int.parse(r.$3) / 225,
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
              final rules = _card(
                'Data Residency Rules',
                Column(
                  children: [
                    for (final x in _rules)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
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
                                      x.$1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: EnterpriseTheme.gray900,
                                      ),
                                    ),
                                    Text(
                                      x.$2,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: EnterpriseTheme.gray600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DashboardBadges.regionStatus('Healthy'),
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
                    Expanded(child: dist),
                    const SizedBox(width: 24),
                    Expanded(child: rules),
                  ],
                );
              }
              return Column(children: [dist, const SizedBox(height: 24), rules]);
            },
          ),
          const SizedBox(height: 24),
          _card(
            'Cross-Region Replication',
            LayoutBuilder(
              builder: (context, c) {
                final n = c.maxWidth < 560 ? 1 : 3;
                return GridView.count(
                  crossAxisCount: n,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: const [
                    _RepTile(title: 'Replication Status', value: 'Healthy', sub: 'All regions synced'),
                    _RepTile(title: 'Replication Lag', value: '< 1s', sub: 'Average delay'),
                    _RepTile(title: 'Data Transfer', value: '2.4TB', sub: 'Last 24 hours'),
                  ],
                );
              },
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

const _rules = <(String, String)>[
  ('EU Regions', 'GDPR Compliance'),
  ('APAC', 'Local Data Storage'),
  ('US Regions', 'SOC 2 Compliance'),
];

class _RepTile extends StatelessWidget {
  const _RepTile({required this.title, required this.value, required this.sub});

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
