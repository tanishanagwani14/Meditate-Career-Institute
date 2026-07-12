import 'package:flutter/material.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/kpi_card.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class AcademicAssignmentsPage extends StatefulWidget {
  const AcademicAssignmentsPage({super.key});

  @override
  State<AcademicAssignmentsPage> createState() => _AcademicAssignmentsPageState();
}

class _AcademicAssignmentsPageState extends State<AcademicAssignmentsPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _assignments = [
    (
      1,
      'Organic Chemistry Problems Set 1',
      'NEET',
      'Prof. Meera Iyer',
      '2026-04-25',
      '2026-05-05',
      38,
      40,
      'active'
    ),
    (2, 'Physics Numerical - Mechanics', 'JEE Advanced', 'Dr. Rajesh Singh', '2026-04-28', '2026-05-08', 45, 50, 'active'),
    (3, 'Mathematics Trigonometry Test', 'Foundation', 'Mrs. Priya Sharma', '2026-04-30', '2026-05-10', 30, 35, 'active'),
    (4, 'Biology - Cell Structure Quiz', 'NEET', 'Dr. Amit Kumar', '2026-04-20', '2026-04-30', 40, 40, 'completed'),
    (5, 'Chemistry - Periodic Table', 'JEE Mains', 'Prof. Meera Iyer', '2026-04-22', '2026-05-02', 42, 45, 'overdue'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<(int, String, String, String, String, String, int, int, String)> _filtered() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_assignments);
    return _assignments.where((a) {
      return a.$2.toLowerCase().contains(q) ||
          a.$3.toLowerCase().contains(q) ||
          a.$4.toLowerCase().contains(q) ||
          a.$9.toLowerCase().contains(q);
    }).toList();
  }

  void _openFilters() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filters coming soon on this page')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filtered();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Assignment Management',
          subtitle: 'Track and manage assignments across all courses',
          action: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Assignment'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 1100 ? 4 : c.maxWidth >= 700 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: cols == 1 ? 2.2 : 1.7,
              children: const [
                KpiCard(
                  title: 'Total Assignments',
                  value: '156',
                  change: 'This month',
                  changeType: ChangeType.neutral,
                  icon: Icons.description_outlined,
                  iconBg: Color(0xFFDBEAFE),
                  iconColor: Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Active',
                  value: '42',
                  change: 'Currently ongoing',
                  changeType: ChangeType.neutral,
                  icon: Icons.schedule,
                  iconBg: Color(0xFFFFFBEB),
                  iconColor: Color(0xFFCA8A04),
                ),
                KpiCard(
                  title: 'Completed',
                  value: '108',
                  change: '100% submission',
                  changeType: ChangeType.positive,
                  icon: Icons.check_circle_outline,
                  iconBg: Color(0xFFDCFCE7),
                  iconColor: Color(0xFF16A34A),
                ),
                KpiCard(
                  title: 'Overdue',
                  value: '6',
                  change: 'Needs attention',
                  changeType: ChangeType.negative,
                  icon: Icons.error_outline,
                  iconBg: Color(0xFFFEE2E2),
                  iconColor: Color(0xFFDC2626),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        FilterBar(
          searchPlaceholder: 'Search assignments by title or course...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
          onFiltersPressed: _openFilters,
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Assignment Title', 'Assigned By', 'Assigned Date', 'Due Date', 'Submissions', 'Status', 'Actions'],
          rows: [
            for (final a in rows)
              [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.description_outlined, color: Color(0xFF4F46E5)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(a.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(a.$4),
                Text(a.$5),
                Text(a.$6),
                _SubmissionsCell(submitted: a.$7, total: a.$8),
                StatusBadge(status: a.$9),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                  child: const Text('View'),
                ),
              ],
          ],
        ),
      ],
    );
  }
}

class _SubmissionsCell extends StatelessWidget {
  const _SubmissionsCell({required this.submitted, required this.total});
  final int submitted;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : (submitted / total).clamp(0.0, 1.0);
    final color = submitted == total ? const Color(0xFF22C55E) : const Color(0xFF4F46E5);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$submitted/$total', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        SizedBox(
          width: 84,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

