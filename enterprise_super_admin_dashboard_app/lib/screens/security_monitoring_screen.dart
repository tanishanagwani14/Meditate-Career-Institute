import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/simple_charts.dart';
import '../widgets/stat_card.dart';

class SecurityMonitoringScreen extends StatelessWidget {
  const SecurityMonitoringScreen({super.key});

  static final _threatSeries = [
    (label: '00:00', a: 12.0, b: 12.0),
    (label: '04:00', a: 8.0, b: 8.0),
    (label: '08:00', a: 24.0, b: 23.0),
    (label: '12:00', a: 45.0, b: 44.0),
    (label: '16:00', a: 38.0, b: 38.0),
    (label: '20:00', a: 28.0, b: 27.0),
  ];

  static final _events = [
    ('Brute Force Attack', '185.220.101.12', 'Login API', 'High', 'Blocked', '5 min ago'),
    ('SQL Injection Attempt', '45.142.215.98', 'Search Endpoint', 'Critical', 'Blocked', '12 min ago'),
    ('DDoS Attempt', '91.219.237.44', 'Main Gateway', 'High', 'Mitigated', '25 min ago'),
    ('Suspicious API Usage', '172.16.0.142', 'Data Export', 'Medium', 'Investigating', '1 hour ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Security Monitoring',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Real-time threat detection and security analytics',
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
                    label: 'Threats Detected',
                    value: '155',
                    change: 'Last 24 hours',
                    changeType: StatChangeType.neutral,
                    icon: Icons.warning_amber_outlined,
                    iconBackground: Color(0xFFFEE2E2),
                    iconColor: Color(0xFFDC2626),
                  ),
                  EnterpriseStatCard(
                    label: 'Threats Blocked',
                    value: '152',
                    change: '98% success rate',
                    changeType: StatChangeType.positive,
                    icon: Icons.shield_outlined,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'Active Monitoring',
                    value: '100%',
                    change: 'All endpoints',
                    changeType: StatChangeType.positive,
                    icon: Icons.monitor_heart_outlined,
                    iconBackground: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF2563EB),
                  ),
                  EnterpriseStatCard(
                    label: 'Security Score',
                    value: '97/100',
                    change: '+2 from last week',
                    changeType: StatChangeType.positive,
                    icon: Icons.trending_up,
                    iconBackground: Color(0xFFE0E7FF),
                    iconColor: EnterpriseTheme.indigo600,
                  ),
                ],
              );
            },
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
                  'Threat Detection Timeline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: EnterpriseTheme.gray900,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _Leg(color: Color(0xFFEF4444), label: 'Threats'),
                    SizedBox(width: 16),
                    _Leg(color: Color(0xFF10B981), label: 'Blocked'),
                  ],
                ),
                SimpleLineChart(
                  series: _threatSeries,
                  colorA: const Color(0xFFEF4444),
                  colorB: const Color(0xFF10B981),
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
                  'Recent Security Events',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: EnterpriseTheme.gray900,
                  ),
                ),
                const SizedBox(height: 16),
                AppDataTable(
                  columns: const [
                    'Event Type',
                    'Source IP',
                    'Target',
                    'Severity',
                    'Status',
                    'Time',
                  ],
                  rows: [
                    for (final e in _events)
                      [
                        e.$1,
                        e.$2,
                        e.$3,
                        DashboardBadges.severity(e.$4),
                        DashboardBadges.securityEventStatus(e.$5),
                        e.$6,
                      ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 1000;
              final a = _card(
                'Attack Vectors',
                Column(
                  children: [
                    for (final v in _vectors)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(v.$1, style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray700)),
                                Text(
                                  '${v.$2}',
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
                                value: v.$3 / 100,
                                minHeight: 8,
                                backgroundColor: EnterpriseTheme.gray100,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
              final b = _card(
                'WAF Rules',
                Column(
                  children: [
                    for (final w in _waf)
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
                                      w.$1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: EnterpriseTheme.gray900,
                                      ),
                                    ),
                                    Text(
                                      '${w.$2} hits today',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: EnterpriseTheme.gray600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const PillMini(label: 'Active'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
              final m = _card(
                'Security Metrics',
                Column(
                  children: [
                    for (final x in _metrics)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: EnterpriseTheme.gray50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(x.$1, style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600)),
                              Text(
                                x.$2,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: EnterpriseTheme.gray900,
                                ),
                              ),
                              Text(x.$3, style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500)),
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
                    Expanded(child: a),
                    const SizedBox(width: 24),
                    Expanded(child: b),
                    const SizedBox(width: 24),
                    Expanded(child: m),
                  ],
                );
              }
              return Column(children: [a, const SizedBox(height: 24), b, const SizedBox(height: 24), m]);
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

class _Leg extends StatelessWidget {
  const _Leg({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray600)),
      ],
    );
  }
}

class PillMini extends StatelessWidget {
  const PillMini({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF047857)),
      ),
    );
  }
}

const _vectors = <(String, int, int)>[
  ('Brute Force', 58, 37),
  ('SQL Injection', 42, 27),
  ('XSS Attempts', 28, 18),
  ('DDoS', 18, 12),
  ('Other', 9, 6),
];

const _waf = <(String, int)>[
  ('SQL Injection Protection', 42),
  ('XSS Prevention', 28),
  ('Rate Limiting', 156),
  ('Geographic Blocking', 12),
];

const _metrics = <(String, String, String)>[
  ('Mean Time to Detect', '0.8s', 'Average response time'),
  ('False Positive Rate', '0.2%', 'High accuracy'),
  ('Blocked IPs', '1,248', 'Permanent blocks'),
];
