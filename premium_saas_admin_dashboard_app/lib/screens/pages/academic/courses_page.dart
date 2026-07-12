import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/kpi_card.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class AcademicCoursesPage extends StatefulWidget {
  const AcademicCoursesPage({super.key});

  @override
  State<AcademicCoursesPage> createState() => _AcademicCoursesPageState();
}

class _AcademicCoursesPageState extends State<AcademicCoursesPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _courses = [
    (
      1,
      'JEE Advanced Crash Course',
      'Competitive Exam',
      '12 months',
      245,
      5,
      '₹45,000',
      'active',
      '2026-01-15'
    ),
    (2, 'NEET Complete Preparation', 'Competitive Exam', '24 months', 320, 8, '₹40,000', 'active', '2025-08-01'),
    (3, 'Foundation Mathematics', 'Foundation', '6 months', 150, 3, '₹25,000', 'active', '2026-02-01'),
    (4, 'English Communication Skills', 'Skill Development', '3 months', 95, 2, '₹15,000', 'active', '2026-03-10'),
    (5, 'Advanced Physics Masterclass', 'Subject Specific', '4 months', 120, 3, '₹30,000', 'pending', '2026-06-01'),
    (6, 'Chemistry Olympiad Prep', 'Competitive Exam', '8 months', 0, 0, '₹35,000', 'inactive', '2026-07-15'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<(int, String, String, String, int, int, String, String, String)> _filtered() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_courses);
    return _courses.where((c) {
      return c.$2.toLowerCase().contains(q) ||
          c.$3.toLowerCase().contains(q) ||
          c.$8.toLowerCase().contains(q);
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
          title: 'Course Management',
          subtitle: 'Create and manage all courses offered by your institute',
          action: FilledButton.icon(
            onPressed: () => context.push('/academic/courses/create'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Course'),
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
                  title: 'Total Courses',
                  value: '48',
                  change: '+5 new this quarter',
                  changeType: ChangeType.positive,
                  icon: Icons.menu_book_outlined,
                  iconBg: Color(0xFFDBEAFE),
                  iconColor: Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Active Courses',
                  value: '42',
                  change: '87.5% active rate',
                  changeType: ChangeType.positive,
                  icon: Icons.trending_up,
                  iconBg: Color(0xFFDCFCE7),
                  iconColor: Color(0xFF16A34A),
                ),
                KpiCard(
                  title: 'Total Enrollment',
                  value: '930',
                  change: 'Across all courses',
                  changeType: ChangeType.neutral,
                  icon: Icons.people_outline,
                  iconBg: Color(0xFFF3E8FF),
                  iconColor: Color(0xFF9333EA),
                ),
                KpiCard(
                  title: 'Avg Course Fee',
                  value: '₹32K',
                  change: '+8% from last year',
                  changeType: ChangeType.positive,
                  icon: Icons.trending_up,
                  iconBg: Color(0xFFFFEDD5),
                  iconColor: Color(0xFFEA580C),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        FilterBar(
          searchPlaceholder: 'Search courses by name or category...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
          onFiltersPressed: _openFilters,
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Course Name', 'Duration', 'Enrolled', 'Batches', 'Course Fee', 'Status', 'Start Date', 'Actions'],
          rows: [
            for (final c in rows)
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(c.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Text(c.$4),
                  ],
                ),
                Text('${c.$5}'),
                Text('${c.$6}'),
                Text(c.$7, style: const TextStyle(fontWeight: FontWeight.w700)),
                StatusBadge(status: c.$8),
                Text(c.$9),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                  child: const Text('Edit'),
                ),
              ],
          ],
        ),
      ],
    );
  }
}

