import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/shared/page_header.dart';

class InsightDetailPage extends StatelessWidget {
  const InsightDetailPage({super.key, required this.id});

  final int id;

  static const insights = [
    (
      'Strong Biology Performance',
      'Students showing 12% improvement in biology with 88% average score',
      'What this means',
      'Biology is trending upward across batches. Maintain momentum with regular revision tests and reinforce high-scoring topics.',
    ),
    (
      'Chemistry Needs Attention',
      'Consider additional workshops for chemistry topics',
      'What this means',
      'Chemistry has lower average and wider spread. Focus on core concepts, error patterns, and provide targeted doubt sessions.',
    ),
    (
      'Overall Progress Trend',
      'Consistent 3-4% month-over-month improvement across all batches',
      'What this means',
      'Overall institute performance is improving steadily. Identify what’s working (schedule, tests, mentorship) and replicate across batches.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final i = (id >= 0 && id < insights.length) ? insights[id] : null;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    if (i == null) {
      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: 'Insight',
              action: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back'),
              ),
            ),
            const SizedBox(height: 24),
            const Center(child: Text('Insight not found')),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: i.$1,
            subtitle: i.$2,
            action: OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(i.$3, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(i.$4, style: const TextStyle(height: 1.35)),
                  const SizedBox(height: 16),
                  Text('Recommended next steps', style: TextStyle(color: muted, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  const _Bullet(text: 'Review batch-wise score distribution for this area.'),
                  const _Bullet(text: 'Plan a focused worksheet/test for weak topics.'),
                  const _Bullet(text: 'Track impact in the next weekly report.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

