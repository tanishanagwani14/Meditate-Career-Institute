import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/dashboard_data.dart';
import '../../widgets/dashboard/dashboard_charts.dart';
import '../../widgets/shared/kpi_card.dart';
import '../../widgets/shared/page_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        const PageHeader(
          title: 'Dashboard Overview',
          subtitle: "Monitor your institute's performance and key metrics",
        ),
        const SizedBox(height: 16),

        // KPI cards — always 2×2 on phones, 4 across on wide screens
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 1100;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: wide ? 4 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              // Taller cells on 2-col layout so title + value + chip never overflow.
              childAspectRatio: wide ? 1.8 : 1.05,
              children: [
                KpiCard(
                  title: 'Total Students',
                  value: '1,284',
                  change: '+12.5% from last month',
                  changeType: ChangeType.positive,
                  icon: Icons.people_outline,
                  iconBg: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF2563EB),
                  onTap: () => context.push('/dashboard/kpi/students'),
                ),
                KpiCard(
                  title: 'Monthly Revenue',
                  value: '₹6.7L',
                  change: '+8.2% from last month',
                  changeType: ChangeType.positive,
                  icon: Icons.currency_rupee,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                  onTap: () => context.push('/dashboard/kpi/revenue'),
                ),
                KpiCard(
                  title: 'Active Courses',
                  value: '48',
                  change: '+3 new courses',
                  changeType: ChangeType.positive,
                  icon: Icons.menu_book_outlined,
                  iconBg: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF7C3AED),
                  onTap: () => context.push('/dashboard/kpi/courses'),
                ),
                KpiCard(
                  title: 'Avg Attendance',
                  value: '92%',
                  change: '-2.1% from last month',
                  changeType: ChangeType.negative,
                  icon: Icons.trending_up,
                  iconBg: const Color(0xFFFFEDD5),
                  iconColor: const Color(0xFFEA580C),
                  onTap: () => context.push('/dashboard/kpi/attendance'),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // Charts + recent activity — 2 up, 2 down (intrinsic height, no aspect-ratio squeeze)
        LayoutBuilder(
          builder: (context, c) {
            final twoCol = c.maxWidth >= 700;
            const chartCards = [
              _ChartCard(
                title: 'Revenue & Student Growth',
                chart: RevenueStudentGrowthChart(),
              ),
              _ChartCard(
                title: 'Course Enrollment Distribution',
                chart: CourseEnrollmentChart(),
              ),
              _ChartCard(
                title: 'Performance Metrics',
                chart: PerformanceMetricsChart(),
              ),
              _RecentActivityCard(),
            ];

            if (!twoCol) {
              return Column(
                children: [
                  for (var i = 0; i < chartCards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    chartCards[i],
                  ],
                ],
              );
            }

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: chartCards[0]),
                    const SizedBox(width: 16),
                    Expanded(child: chartCards[1]),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: chartCards[2]),
                    const SizedBox(width: 16),
                    Expanded(child: chartCards[3]),
                  ],
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // Bottom stats — 2×2 on narrow, 3 across on wide; each opens a list page
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 1100;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: wide ? 3 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: wide ? 1.7 : 1.05,
              children: [
                _GradientStat(
                  title: 'New Enrollments',
                  value: '156',
                  subtitle: 'This month',
                  colors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  onTap: () => context.push('/dashboard/enrollments'),
                ),
                _GradientStat(
                  title: 'Fee Collection',
                  value: '₹8.4L',
                  subtitle: 'Collected this week',
                  colors: const [Color(0xFF22C55E), Color(0xFF16A34A)],
                  onTap: () => context.push('/dashboard/fee-collection'),
                ),
                _GradientStat(
                  title: 'Active Teachers',
                  value: '42',
                  subtitle: 'Teaching staff',
                  colors: const [Color(0xFFA855F7), Color(0xFF7C3AED)],
                  onTap: () => context.push('/dashboard/active-teachers'),
                ),
              ],
            );
          },
        ),
      ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.chart});
  final String title;
  final Widget chart;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            // Slightly taller to avoid bottom overflows in dense chart widgets.
            SizedBox(height: 220, child: chart),
          ],
        ),
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Activities', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            for (final a in DashboardData.activities) _ActivityTile(activity: a),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});
  final DashboardActivity activity;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push('/dashboard/activity/${activity.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: activity.bg, borderRadius: BorderRadius.circular(10)),
                  child: Icon(activity.icon, color: activity.fg, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(activity.text, style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(activity.time, style: TextStyle(fontSize: 11, color: muted)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientStat extends StatelessWidget {
  const _GradientStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  final String title;
  final String value;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.88), fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.open_in_new, size: 18, color: Colors.white.withValues(alpha: 0.9)),
                ],
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.05),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
