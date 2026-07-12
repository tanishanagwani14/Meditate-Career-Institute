import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text('Good Morning, Teacher!', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text("Here's what's happening today", style: TextStyle(color: muted)),
        const SizedBox(height: 16),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          // Slightly taller tiles to avoid bottom RenderFlex overflow on some devices.
          childAspectRatio: 1.35,
          children: const [
            _Stat(label: 'Total Students', value: '1,248', chip: '+12%', icon: Icons.people_outline, iconColor: AppColors.primary),
            _Stat(label: 'Active Courses', value: '24', chip: '+3', icon: Icons.menu_book_outlined, iconColor: AppColors.success),
            _Stat(label: 'This Month Revenue', value: '₹1.2L', chip: '+18%', icon: Icons.currency_rupee, iconColor: AppColors.warning),
            _Stat(label: 'Completion Rate', value: '87%', chip: '+5%', icon: Icons.trending_up, iconColor: AppColors.info),
          ],
        ),

        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Revenue Overview', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _MiniChart(primary: primary),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Upcoming Classes', style: TextStyle(fontWeight: FontWeight.w600)),
            TextButton(onPressed: () => context.push('/live-class'), child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 8),
        ...[
          ('Physics - Class 12', '10:00 AM', 45, 'Live'),
          ('Mathematics - JEE', '2:00 PM', 38, 'Live'),
          ('Chemistry Doubt Session', '4:30 PM', 22, 'Doubt'),
        ].map((c) {
          final type = c.$4;
          final badgeColor = type == 'Live' ? primary : AppColors.warning;
          final badgeBg = badgeColor.withValues(alpha: 0.12);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.all(12),
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.videocam_outlined, color: primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 14, color: muted),
                            const SizedBox(width: 4),
                            Text('${c.$2} · ${c.$3} students', style: TextStyle(fontSize: 12, color: muted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(999)),
                    child: Text(type, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: badgeColor)),
                  ),
                ],
              ),
            ),
          );
        }),

        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => context.push('/live-class'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Start Live Class'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/courses/create-test'),
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text('Create Test'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Recent Activity', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...[
                ('New student enrolled in "Complete JEE Course"', '5 mins ago'),
                ('Assignment submitted by 12 students', '1 hour ago'),
                ('New doubt posted in Physics batch', '2 hours ago'),
                ('Course "NEET Biology" reached 100 students', '5 hours ago'),
              ].map((a) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.$1, style: const TextStyle(fontSize: 13)),
                            Text(a.$2, style: TextStyle(fontSize: 11, color: muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    required this.chip,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final String chip;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Icon(icon, size: 64, color: iconColor.withValues(alpha: 0.12)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: muted)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(chip, style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart({required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).dividerColor;
    final bars = const [0.35, 0.28, 0.42, 0.65, 0.72, 0.9];

    return SizedBox(
      height: 180,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final b in bars)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: 140 * b,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primary.withValues(alpha: 0.22),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

