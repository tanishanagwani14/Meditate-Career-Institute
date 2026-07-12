import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/simple_charts.dart';
import '../widgets/stat_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static final _churnSeries = [
    (label: 'Jan', a: 3.2, b: 96.8),
    (label: 'Feb', a: 2.8, b: 97.2),
    (label: 'Mar', a: 3.5, b: 96.5),
    (label: 'Apr', a: 2.1, b: 97.9),
    (label: 'May', a: 2.3, b: 97.7),
    (label: 'Jun', a: 1.9, b: 98.1),
  ];

  static final _userGrowth = [
    (label: 'Jan', value: 38200.0),
    (label: 'Feb', value: 39800.0),
    (label: 'Mar', value: 41100.0),
    (label: 'Apr', value: 42600.0),
    (label: 'May', value: 44100.0),
    (label: 'Jun', value: 45200.0),
  ];

  static final _tenantBars = [
    (label: 'Jan', value: 185.0),
    (label: 'Feb', value: 195.0),
    (label: 'Mar', value: 201.0),
    (label: 'Apr', value: 210.0),
    (label: 'May', value: 218.0),
    (label: 'Jun', value: 225.0),
  ];

  static const _engagement = <({String name, double value, Color color})>[
    (name: 'Daily Active', value: 68, color: Color(0xFF6366F1)),
    (name: 'Weekly Active', value: 23, color: Color(0xFF8B5CF6)),
    (name: 'Monthly Active', value: 9, color: Color(0xFFEC4899)),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Platform Analytics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Churn, user growth, tenant metrics, and product analytics',
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
                    label: 'Churn Rate',
                    value: '1.9%',
                    change: '-0.4% from last month',
                    changeType: StatChangeType.positive,
                    icon: Icons.trending_down,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'User Growth',
                    value: '+1,100',
                    change: '+2.5% this month',
                    changeType: StatChangeType.positive,
                    icon: Icons.people_outline,
                    iconBackground: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF2563EB),
                  ),
                  EnterpriseStatCard(
                    label: 'Tenant Growth',
                    value: '+7',
                    change: '+3.2% this month',
                    changeType: StatChangeType.positive,
                    icon: Icons.apartment_outlined,
                    iconBackground: Color(0xFFE9D5FF),
                    iconColor: Color(0xFF9333EA),
                  ),
                  EnterpriseStatCard(
                    label: 'Avg Engagement',
                    value: '68%',
                    change: 'Daily active users',
                    changeType: StatChangeType.positive,
                    icon: Icons.track_changes_outlined,
                    iconBackground: Color(0xFFE0E7FF),
                    iconColor: EnterpriseTheme.indigo600,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;
              final churn = _white(
                title: 'Churn & Retention Analysis',
                child: Column(
                  children: [
                    SimpleLineChart(
                  series: _churnSeries,
                  colorA: const Color(0xFFEF4444),
                  colorB: const Color(0xFF22C55E),
                ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendDot(color: Color(0xFFEF4444), label: 'Churn Rate'),
                        SizedBox(width: 24),
                        _LegendDot(color: Color(0xFF22C55E), label: 'Retention Rate'),
                      ],
                    ),
                  ],
                ),
              );
              final growth = _white(
                title: 'User Growth Trajectory',
                child: SimpleAreaChart(
                  points: _userGrowth,
                  lineColor: const Color(0xFF3B82F6),
                ),
              );
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: churn),
                    const SizedBox(width: 24),
                    Expanded(child: growth),
                  ],
                );
              }
              return Column(children: [churn, const SizedBox(height: 24), growth]);
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final cols = w >= 1100 ? 3 : 1;
              if (cols == 3) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _white(
                        title: 'Tenant Growth',
                        child: SimpleBarChart(bars: _tenantBars, height: 250),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _white(
                        title: 'User Engagement',
                        child: SimpleDonutLegend(items: _engagement, size: 180),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(child: _productMetrics()),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _white(
                    title: 'Tenant Growth',
                    child: SimpleBarChart(bars: _tenantBars, height: 250),
                  ),
                  const SizedBox(height: 24),
                  _white(
                    title: 'User Engagement',
                    child: SimpleDonutLegend(items: _engagement),
                  ),
                  const SizedBox(height: 24),
                  _productMetrics(),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _white(
            title: 'Cohort Analysis',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(EnterpriseTheme.gray50),
                columns: const [
                  DataColumn(label: Text('COHORT')),
                  DataColumn(label: Text('MONTH 0'), numeric: true),
                  DataColumn(label: Text('MONTH 1'), numeric: true),
                  DataColumn(label: Text('MONTH 2'), numeric: true),
                  DataColumn(label: Text('MONTH 3'), numeric: true),
                  DataColumn(label: Text('MONTH 4'), numeric: true),
                  DataColumn(label: Text('MONTH 5'), numeric: true),
                ],
                rows: [
                  for (final r in _cohorts)
                    DataRow(
                      cells: [
                        DataCell(Text(r.$1)),
                        for (var i = 0; i < 6; i++)
                          DataCell(_cohortCell(r.$2[i])),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _cohortCell(int? v) {
    if (v == null) {
      return const Center(child: Text('-', style: TextStyle(color: EnterpriseTheme.gray500)));
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '$v%',
          style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static Widget _productMetrics() {
    const metrics = [
      ('Avg Session Duration', '24m 38s', '+5.2%'),
      ('Feature Adoption', '76.4%', '+12.1%'),
      ('Course Completion', '82.3%', '+3.8%'),
      ('Support Ticket Rate', '1.2%', '-0.4%'),
    ];
    return _white(
      title: 'Key Product Metrics',
      child: Column(
        children: [
          for (final m in metrics)
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
                            style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
                          ),
                          Text(
                            m.$2,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: EnterpriseTheme.gray900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      m.$3,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF16A34A)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  static Widget _white({required String title, required Widget child}) {
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

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

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
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600)),
      ],
    );
  }
}

/// Cohort rows: label + 6 month values (nullable).
const _cohorts = <(String, List<int?>)>[
  ('Jan 2024', [100, 98, 96, 94, 92, 91]),
  ('Feb 2024', [100, 97, 95, 93, 92, null]),
  ('Mar 2024', [100, 99, 97, 96, null, null]),
  ('Apr 2024', [100, 98, 97, null, null, null]),
  ('May 2024', [100, 99, null, null, null, null]),
];
