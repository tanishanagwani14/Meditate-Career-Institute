import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/simple_charts.dart';
import '../widgets/stat_card.dart';
import '../widgets/section_header.dart' as sh;

class PlatformOverviewScreen extends StatelessWidget {
  const PlatformOverviewScreen({super.key});

  static final _revenuePoints = [
    (label: 'Jan', value: 45000.0),
    (label: 'Feb', value: 52000.0),
    (label: 'Mar', value: 48000.0),
    (label: 'Apr', value: 61000.0),
    (label: 'May', value: 75000.0),
    (label: 'Jun', value: 88000.0),
  ];

  static final _instituteBars = [
    (label: 'Jan', value: 45.0),
    (label: 'Feb', value: 52.0),
    (label: 'Mar', value: 48.0),
    (label: 'Apr', value: 65.0),
    (label: 'May', value: 78.0),
    (label: 'Jun', value: 92.0),
  ];

  static const _distribution = <({String name, double value, Color color})>[
    (name: 'Enterprise', value: 35, color: Color(0xFF6366F1)),
    (name: 'Professional', value: 45, color: Color(0xFF8B5CF6)),
    (name: 'Basic', value: 20, color: Color(0xFFEC4899)),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const sh.SectionHeader(
            title: 'Platform Overview',
            subtitle: 'Global metrics and platform health',
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final cols = w >= 1200 ? 4 : (w >= 800 ? 2 : 1);
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: cols == 1 ? 1.6 : 1.35,
                children: const [
                  EnterpriseStatCard(
                    label: 'Total Revenue',
                    value: '\$369K',
                    change: '+18.2% from last month',
                    changeType: StatChangeType.positive,
                    icon: Icons.payments_outlined,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'Active Institutes',
                    value: '225',
                    change: '+12 new this month',
                    changeType: StatChangeType.positive,
                    icon: Icons.apartment_outlined,
                    iconBackground: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF2563EB),
                  ),
                  EnterpriseStatCard(
                    label: 'Total Users',
                    value: '45.2K',
                    change: '+8.4% growth',
                    changeType: StatChangeType.positive,
                    icon: Icons.people_outline,
                    iconBackground: Color(0xFFE9D5FF),
                    iconColor: Color(0xFF9333EA),
                  ),
                  EnterpriseStatCard(
                    label: 'Platform Health',
                    value: '98.9%',
                    change: 'Uptime',
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
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;
              final charts = [
                _chartCard(
                  title: 'Revenue & Subscriptions',
                  child: SimpleAreaChart(points: _revenuePoints),
                ),
                _chartCard(
                  title: 'Institute Growth',
                  child: SimpleBarChart(bars: _instituteBars),
                ),
              ];
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: charts[0]),
                    const SizedBox(width: 24),
                    Expanded(child: charts[1]),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  charts[0],
                  const SizedBox(height: 24),
                  charts[1],
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 1000;
              final planCard = _chartCard(
                title: 'Plan Distribution',
                child: SimpleDonutLegend(items: _distribution),
              );
              final metricsCard = _chartCard(
                title: 'Key Metrics',
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.4,
                  children: const [
                    _MetricTile(
                      label: 'Avg Revenue/Institute',
                      value: '\$1,640',
                      trend: '+12.5%',
                      up: true,
                    ),
                    _MetricTile(
                      label: 'Churn Rate',
                      value: '2.3%',
                      trend: '-0.8%',
                      up: true,
                    ),
                    _MetricTile(
                      label: 'Users/Institute',
                      value: '201',
                      trend: '+5.2%',
                      up: true,
                    ),
                    _MetricTile(
                      label: 'Platform MRR',
                      value: '\$88K',
                      trend: '+18.2%',
                      up: true,
                    ),
                  ],
                ),
              );
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: planCard),
                    const SizedBox(width: 24),
                    Expanded(flex: 2, child: metricsCard),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  planCard,
                  const SizedBox(height: 24),
                  metricsCard,
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          _chartCard(
            title: 'Recent Platform Activity',
            child: Column(
              children: [
                for (final a in _activities)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: a.dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.action,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: EnterpriseTheme.gray900,
                                ),
                              ),
                              Text(
                                a.institute,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: EnterpriseTheme.gray500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          a.time,
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
          ),
        ],
      ),
    );
  }

  static Widget _chartCard({required String title, required Widget child}) {
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.trend,
    required this.up,
  });

  final String label;
  final String value;
  final String trend;
  final bool up;

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
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                up ? Icons.north_east : Icons.south_east,
                size: 16,
                color: const Color(0xFF16A34A),
              ),
              Text(
                trend,
                style: const TextStyle(fontSize: 14, color: Color(0xFF16A34A)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Act {
  const _Act({
    required this.action,
    required this.institute,
    required this.time,
    required this.dotColor,
  });

  final String action;
  final String institute;
  final String time;
  final Color dotColor;
}

const _activities = <_Act>[
  _Act(
    action: 'New institute onboarded',
    institute: 'Bright Future Academy',
    time: '5 min ago',
    dotColor: Color(0xFF22C55E),
  ),
  _Act(
    action: 'Subscription upgraded',
    institute: 'Tech Learning Hub',
    time: '12 min ago',
    dotColor: Color(0xFF3B82F6),
  ),
  _Act(
    action: 'Support ticket escalated',
    institute: 'Global Institute',
    time: '23 min ago',
    dotColor: Color(0xFFEAB308),
  ),
  _Act(
    action: 'Payment received',
    institute: 'Elite Education Center',
    time: '45 min ago',
    dotColor: Color(0xFF22C55E),
  ),
  _Act(
    action: 'Content moderation required',
    institute: 'Smart Academy',
    time: '1 hour ago',
    dotColor: Color(0xFFEF4444),
  ),
];
