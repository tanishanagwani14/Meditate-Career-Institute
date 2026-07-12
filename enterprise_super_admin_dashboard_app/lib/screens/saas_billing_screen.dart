import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/simple_charts.dart';
import '../widgets/stat_card.dart';

class SaaSBillingScreen extends StatelessWidget {
  const SaaSBillingScreen({super.key});

  static final _mrrArea = [
    (label: 'Jan', value: 72000.0),
    (label: 'Feb', value: 76000.0),
    (label: 'Mar', value: 78000.0),
    (label: 'Apr', value: 82000.0),
    (label: 'May', value: 85000.0),
    (label: 'Jun', value: 88000.0),
  ];

  static final _churnBars = [
    (label: 'Jan', value: 2400.0),
    (label: 'Feb', value: 2200.0),
    (label: 'Mar', value: 2600.0),
    (label: 'Apr', value: 1800.0),
    (label: 'May', value: 2000.0),
    (label: 'Jun', value: 1900.0),
  ];

  static final _subs = [
    ('Bright Future Academy', 'Enterprise', '1,250', '\$2,450/mo', '2024-05-15', 'Active'),
    ('Tech Learning Hub', 'Professional', '890', '\$1,680/mo', '2024-05-20', 'Active'),
    ('Global Institute', 'Enterprise', '2,100', '\$3,850/mo', '2024-05-10', 'Active'),
    ('Smart Academy', 'Basic', '320', '\$480/mo', '2024-05-25', 'Trial'),
    ('Elite Education Center', 'Professional', '1,450', '\$2,180/mo', '2024-05-12', 'Active'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SaaS Billing Controls',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Subscription management, pricing, and billing operations',
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
                    label: 'Monthly MRR',
                    value: '\$88K',
                    change: '+\$3K from last month',
                    changeType: StatChangeType.positive,
                    icon: Icons.attach_money,
                    iconBackground: Color(0xFFD1FAE5),
                    iconColor: Color(0xFF16A34A),
                  ),
                  EnterpriseStatCard(
                    label: 'Annual ARR',
                    value: '\$1.06M',
                    change: '+18.2% YoY growth',
                    changeType: StatChangeType.positive,
                    icon: Icons.trending_up,
                    iconBackground: Color(0xFFDBEAFE),
                    iconColor: Color(0xFF2563EB),
                  ),
                  EnterpriseStatCard(
                    label: 'Active Subscriptions',
                    value: '225',
                    change: '12 new this month',
                    changeType: StatChangeType.positive,
                    icon: Icons.credit_card,
                    iconBackground: Color(0xFFE9D5FF),
                    iconColor: Color(0xFF9333EA),
                  ),
                  EnterpriseStatCard(
                    label: 'Revenue Churn',
                    value: '\$1.9K',
                    change: '2.2% churn rate',
                    changeType: StatChangeType.negative,
                    icon: Icons.error_outline,
                    iconBackground: Color(0xFFFEE2E2),
                    iconColor: Color(0xFFDC2626),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;
              final mrr = _card(
                'MRR Growth',
                SimpleAreaChart(points: _mrrArea, lineColor: EnterpriseTheme.indigo600),
              );
              final churn = _card(
                'Monthly Churn (\$)',
                SimpleBarChart(bars: _churnBars, barColor: const Color(0xFFEF4444)),
              );
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: mrr),
                    const SizedBox(width: 24),
                    Expanded(child: churn),
                  ],
                );
              }
              return Column(children: [mrr, const SizedBox(height: 24), churn]);
            },
          ),
          const SizedBox(height: 24),
          _card(
            'Revenue by Plan',
            SimpleBarChart(
              bars: const [
                (label: 'Enterprise', value: 42000.0),
                (label: 'Professional', value: 35000.0),
                (label: 'Basic', value: 11000.0),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppDataTable(
            columns: const [
              'Institute',
              'Plan',
              'Seats',
              'Price',
              'Next Billing',
              'Status',
            ],
            rows: [
              for (final s in _subs)
                [
                  s.$1,
                  DashboardBadges.plan(s.$2),
                  s.$3,
                  s.$4,
                  s.$5,
                  DashboardBadges.subscriptionStatus(s.$6),
                ],
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final w = c.maxWidth;
              final cols = w >= 1100 ? 3 : 1;
              final pricing = _card(
                'Pricing Plans',
                Column(
                  children: [
                    for (final p in _pricing)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: EnterpriseTheme.gray50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    p.$1,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: EnterpriseTheme.gray900,
                                    ),
                                  ),
                                  const Spacer(),
                                  DashboardBadges.plan(p.$1),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p.$2} • ${p.$3}',
                                style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p.$4} institutes subscribed',
                                style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
              final billing = _card(
                'Billing Metrics',
                Column(
                  children: [
                    for (final b in _billingMetrics)
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
                              Text(b.$1, style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600)),
                              Text(
                                b.$2,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: EnterpriseTheme.gray900,
                                ),
                              ),
                              Text(b.$3, style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
              final renew = _card(
                'Upcoming Renewals',
                Column(
                  children: [
                    for (final r in _renewals)
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
                                      '${r.$3} • ${r.$2}',
                                      style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                                    ),
                                  ],
                                ),
                              ),
                              PillRisk(label: '${r.$4} Risk', medium: r.$4 == 'Medium'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
              if (cols == 3) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: pricing),
                    const SizedBox(width: 24),
                    Expanded(child: billing),
                    const SizedBox(width: 24),
                    Expanded(child: renew),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  pricing,
                  const SizedBox(height: 24),
                  billing,
                  const SizedBox(height: 24),
                  renew,
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

const _pricing = <(String, String, String, int)>[
  ('Enterprise', '\$2.50/seat', '5 included', 85),
  ('Professional', '\$2.00/seat', '3 included', 105),
  ('Basic', '\$1.50/seat', '1 included', 35),
];

const _billingMetrics = <(String, String, String)>[
  ('ARPU', '\$391', 'Avg revenue per user'),
  ('LTV', '\$14.2K', 'Customer lifetime value'),
  ('CAC Payback', '8.5mo', 'Time to recover costs'),
];

const _renewals = <(String, String, String, String)>[
  ('Global Institute', '\$3,850', 'May 10', 'Low'),
  ('Elite Education', '\$2,180', 'May 12', 'Low'),
  ('Bright Future', '\$2,450', 'May 15', 'Medium'),
];

class PillRisk extends StatelessWidget {
  const PillRisk({super.key, required this.label, required this.medium});

  final String label;
  final bool medium;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: medium ? const Color(0xFFFEF9C3) : const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: medium ? const Color(0xFFA16207) : const Color(0xFF047857),
        ),
      ),
    );
  }
}
