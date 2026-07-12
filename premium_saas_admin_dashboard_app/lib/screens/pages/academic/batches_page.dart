import 'package:flutter/material.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class AcademicBatchesPage extends StatefulWidget {
  const AcademicBatchesPage({super.key});

  @override
  State<AcademicBatchesPage> createState() => _AcademicBatchesPageState();
}

class _AcademicBatchesPageState extends State<AcademicBatchesPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _batches = [
    (
      1,
      'JEE Advanced - Batch A1',
      'JEE Advanced',
      'Dr. Rajesh Singh',
      50,
      50,
      'Mon, Wed, Fri - 9:00 AM',
      '2026-01-15',
      'active'
    ),
    (2, 'NEET - Batch B2', 'NEET Complete', 'Prof. Meera Iyer', 40, 45, 'Tue, Thu, Sat - 10:00 AM', '2026-01-20', 'active'),
    (3, 'Foundation - Batch C1', 'Foundation Math', 'Mrs. Priya Sharma', 35, 40, 'Mon-Fri - 3:00 PM', '2026-02-01', 'active'),
    (4, 'JEE Mains - Batch A2', 'JEE Mains', 'Dr. Rajesh Singh', 45, 50, 'Mon, Wed, Fri - 2:00 PM', '2026-02-10', 'active'),
    (5, 'NEET - Batch B1', 'NEET Complete', 'Dr. Amit Kumar', 30, 40, 'Tue, Thu, Sat - 11:00 AM', '2026-01-18', 'active'),
    (6, 'Physics Advanced - Batch P1', 'Advanced Physics', 'Dr. Rajesh Singh', 0, 35, 'Mon, Wed - 4:00 PM', '2026-06-01', 'pending'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<(int, String, String, String, int, int, String, String, String)> _filtered() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_batches);
    return _batches.where((b) {
      return b.$2.toLowerCase().contains(q) ||
          b.$3.toLowerCase().contains(q) ||
          b.$4.toLowerCase().contains(q) ||
          b.$9.toLowerCase().contains(q);
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
          title: 'Batch Management',
          subtitle: 'Organize and manage student batches for all courses',
          action: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Batch'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
        ),
        const SizedBox(height: 16),
        FilterBar(
          searchPlaceholder: 'Search batches by name, teacher, or course...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
          onFiltersPressed: _openFilters,
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Batch Name', 'Assigned Teacher', 'Students', 'Schedule', 'Start Date', 'Status'],
          rows: [
            for (final b in rows)
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(b.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
                _TeacherPill(name: b.$4),
                _StudentsCell(students: b.$5, capacity: b.$6),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Expanded(child: Text(b.$7)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Text(b.$8),
                  ],
                ),
                StatusBadge(status: b.$9),
              ],
          ],
        ),
      ],
    );
  }
}

class _TeacherPill extends StatelessWidget {
  const _TeacherPill({required this.name});
  final String name;

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
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(999)),
          child: Text(initials, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF6B21A8))),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(name)),
      ],
    );
  }
}

class _StudentsCell extends StatelessWidget {
  const _StudentsCell({required this.students, required this.capacity});
  final int students;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    final pct = capacity == 0 ? 0.0 : (students / capacity).clamp(0.0, 1.0);
    return Row(
      children: [
        const Icon(Icons.people_outline, size: 16, color: Color(0xFF9CA3AF)),
        const SizedBox(width: 6),
        Text('$students/$capacity'),
        const SizedBox(width: 10),
        SizedBox(
          width: 64,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              color: const Color(0xFF4F46E5),
            ),
          ),
        ),
      ],
    );
  }
}

