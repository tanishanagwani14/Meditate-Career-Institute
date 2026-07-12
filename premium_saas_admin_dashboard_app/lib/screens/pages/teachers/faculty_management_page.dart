import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/kpi_card.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class FacultyManagementPage extends StatefulWidget {
  const FacultyManagementPage({super.key});

  @override
  State<FacultyManagementPage> createState() => _FacultyManagementPageState();
}

class _FacultyManagementPageState extends State<FacultyManagementPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _teachers = [
    (
      1,
      'Dr. Rajesh Singh',
      'rajesh.singh@edu.com',
      'Physics, Mathematics',
      5,
      245,
      4.8,
      'active',
      '2024-06-15'
    ),
    (2, 'Prof. Meera Iyer', 'meera.iyer@edu.com', 'Chemistry', 4, 180, 4.9, 'active', '2024-08-20'),
    (3, 'Dr. Amit Kumar', 'amit.kumar@edu.com', 'Biology', 3, 150, 4.7, 'active', '2025-01-10'),
    (4, 'Mrs. Priya Sharma', 'priya.sharma@edu.com', 'Mathematics', 6, 280, 4.6, 'active', '2024-03-12'),
    (5, 'Mr. Arjun Reddy', 'arjun.reddy@edu.com', 'English, Soft Skills', 2, 95, 4.5, 'active', '2025-09-05'),
    (6, 'Dr. Kavita Patel', 'kavita.patel@edu.com', 'Physics', 4, 200, 4.9, 'inactive', '2024-11-18'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<(int, String, String, String, int, int, double, String, String)> _filtered() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_teachers);
    return _teachers.where((t) {
      return t.$2.toLowerCase().contains(q) ||
          t.$3.toLowerCase().contains(q) ||
          t.$4.toLowerCase().contains(q) ||
          t.$8.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filtered();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Faculty Management',
          subtitle: 'Manage teaching staff and their assignments',
          action: FilledButton.icon(
            onPressed: () => context.push('/teachers/add'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Teacher'),
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
                  title: 'Total Teachers',
                  value: '42',
                  change: '+3 new this month',
                  changeType: ChangeType.positive,
                  icon: Icons.people_outline,
                  iconBg: Color(0xFFF3E8FF),
                  iconColor: Color(0xFF9333EA),
                ),
                KpiCard(
                  title: 'Avg Rating',
                  value: '4.7',
                  change: 'Excellent performance',
                  changeType: ChangeType.positive,
                  icon: Icons.emoji_events_outlined,
                  iconBg: Color(0xFFFEF9C3),
                  iconColor: Color(0xFFCA8A04),
                ),
                KpiCard(
                  title: 'Active Batches',
                  value: '24',
                  change: 'Across all courses',
                  changeType: ChangeType.neutral,
                  icon: Icons.menu_book_outlined,
                  iconBg: Color(0xFFDBEAFE),
                  iconColor: Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Student Coverage',
                  value: '1,150',
                  change: 'Students taught',
                  changeType: ChangeType.neutral,
                  icon: Icons.trending_up,
                  iconBg: Color(0xFFDCFCE7),
                  iconColor: Color(0xFF16A34A),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        FilterBar(
          searchPlaceholder: 'Search teachers by name, subject, or email...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const [
            'Teacher Name',
            'Subjects',
            'Batches',
            'Total Students',
            'Rating',
            'Status',
            'Joined On',
          ],
          rows: [
            for (final t in rows)
              [
                _TeacherCell(name: t.$2, email: t.$3),
                Text(t.$4),
                Text('${t.$5}'),
                Text('${t.$6}'),
                _RatingCell(value: t.$7),
                StatusBadge(status: t.$8),
                Text(t.$9),
              ],
          ],
        ),
      ],
    );
  }
}

class _TeacherCell extends StatelessWidget {
  const _TeacherCell({required this.name, required this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .where((p) => p.trim().isNotEmpty)
        .map((p) => p.trim()[0])
        .take(2)
        .join()
        .toUpperCase();
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(999)),
          child: Text(initials, style: const TextStyle(color: Color(0xFF6B21A8), fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(email, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingCell extends StatelessWidget {
  const _RatingCell({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.emoji_events_outlined, size: 16, color: Color(0xFFF59E0B)),
        const SizedBox(width: 6),
        Text(value.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        const Text('/5.0', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
      ],
    );
  }
}

