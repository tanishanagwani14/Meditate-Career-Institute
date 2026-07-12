import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/shared/page_header.dart';

class SubjectPerformanceDetailPage extends StatelessWidget {
  const SubjectPerformanceDetailPage({super.key});

  static const subjects = [
    ('Physics', 85.0, 95.0, 62.0),
    ('Chemistry', 78.0, 92.0, 58.0),
    ('Mathematics', 82.0, 98.0, 65.0),
    ('Biology', 88.0, 96.0, 70.0),
  ];

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Subject-wise Performance',
            subtitle: 'Average vs top vs lowest scores',
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
                  const Text('Performance chart', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240,
                    child: _GroupedBars(
                      labels: [for (final s in subjects) s.$1],
                      series: const [
                        _BarSeries('Average', Color(0xFF4F46E5), [85.0, 78.0, 82.0, 88.0]),
                        _BarSeries('Top Score', Color(0xFF10B981), [95.0, 92.0, 98.0, 96.0]),
                        _BarSeries('Lowest', Color(0xFFEF4444), [62.0, 58.0, 65.0, 70.0]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap a subject row below for details.',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Subject breakdown', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          for (var i = 0; i < subjects.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text(subjects[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(
                  'Avg ${subjects[i].$2.toStringAsFixed(0)}% · Top ${subjects[i].$3.toStringAsFixed(0)}% · Low ${subjects[i].$4.toStringAsFixed(0)}%',
                  style: TextStyle(color: muted),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/students/reports/subjects/$i'),
              ),
            ),
        ],
      ),
    );
  }
}

class SubjectPerformanceSubjectDetailPage extends StatelessWidget {
  const SubjectPerformanceSubjectDetailPage({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final subjects = SubjectPerformanceDetailPage.subjects;
    final s = (index >= 0 && index < subjects.length) ? subjects[index] : null;

    if (s == null) {
      return Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PageHeader(
              title: 'Subject Detail',
              action: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back'),
              ),
            ),
            const SizedBox(height: 24),
            const Center(child: Text('Subject not found')),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: s.$1,
            subtitle: 'Detailed performance information',
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
                  const Text('Summary', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  _MetricRow(label: 'Average score', value: '${s.$2.toStringAsFixed(1)}%'),
                  const SizedBox(height: 8),
                  _MetricRow(label: 'Top score', value: '${s.$3.toStringAsFixed(1)}%'),
                  const SizedBox(height: 8),
                  _MetricRow(label: 'Lowest score', value: '${s.$4.toStringAsFixed(1)}%'),
                  const SizedBox(height: 14),
                  Text(
                    s.$2 >= 85 ? 'This subject is performing strongly overall.' : 'This subject needs targeted improvement.',
                    style: TextStyle(color: muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Suggested actions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  _Bullet(text: 'Run a topic-wise diagnostic test for ${s.$1}.'),
                  _Bullet(text: 'Assign weekly practice sets with increasing difficulty.'),
                  _Bullet(text: 'Review the bottom quartile student list and schedule doubt sessions.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: TextStyle(color: muted, fontWeight: FontWeight.w700))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
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

class _BarSeries {
  const _BarSeries(this.name, this.color, this.values);
  final String name;
  final Color color;
  final List<double> values;
}

class _GroupedBars extends StatelessWidget {
  const _GroupedBars({required this.labels, required this.series});
  final List<String> labels;
  final List<_BarSeries> series;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (final s in series)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2),
                                      child: Container(
                                        height: 2.4 * s.values[i],
                                        decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(labels[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            for (final s in series)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 6),
                  Text(s.name, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              )
          ],
        ),
      ],
    );
  }
}

