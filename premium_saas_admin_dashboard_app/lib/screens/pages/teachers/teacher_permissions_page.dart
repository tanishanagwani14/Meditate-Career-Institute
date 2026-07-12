import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';

class TeacherPermissionsPage extends StatelessWidget {
  const TeacherPermissionsPage({super.key});

  static const _permissions = [
    (
      'Dr. Rajesh Singh',
      'Senior Faculty',
      true,
      true,
      true,
      true,
      true,
      true,
      false,
      false,
      true,
      true
    ),
    ('Prof. Meera Iyer', 'Faculty', true, false, true, true, true, true, false, false, true, false),
    ('Dr. Amit Kumar', 'Faculty', true, false, true, true, true, true, false, false, false, false),
    ('Mrs. Priya Sharma', 'Head of Department', true, true, true, true, true, true, true, false, true, true),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Teacher Permissions',
          subtitle: 'Manage role-based access control for faculty members',
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color(0xFFEFF6FF),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.shield_outlined, color: Color(0xFF2563EB)),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Permission Legend', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E3A8A))),
                      SizedBox(height: 4),
                      Text(
                        'Each category shows two icons: View (left) and Edit (right) permissions. Green checkmarks indicate granted permissions.',
                        style: TextStyle(color: Color(0xFF1D4ED8)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Teacher', 'Students', 'Attendance', 'Grades', 'Finance', 'Content', 'Reports', 'Actions'],
          rows: [
            for (final p in _permissions)
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(p.$2, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
                _PermPair(view: p.$3, edit: p.$4),
                _PermPair(view: p.$5, edit: p.$6),
                _PermPair(view: p.$7, edit: p.$8),
                _PermPair(view: p.$9, edit: p.$10),
                _PermSingle(granted: p.$11),
                _PermSingle(granted: p.$12),
                OutlinedButton(
                  onPressed: () => context.push('/teachers/permissions/edit'),
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

class _PermPair extends StatelessWidget {
  const _PermPair({required this.view, required this.edit});
  final bool view;
  final bool edit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PermIcon(granted: view),
        const SizedBox(width: 8),
        _PermIcon(granted: edit),
      ],
    );
  }
}

class _PermSingle extends StatelessWidget {
  const _PermSingle({required this.granted});
  final bool granted;

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: _PermIcon(granted: granted));
  }
}

class _PermIcon extends StatelessWidget {
  const _PermIcon({required this.granted});
  final bool granted;

  @override
  Widget build(BuildContext context) {
    if (granted) {
      return const Icon(Icons.check, size: 18, color: Color(0xFF16A34A));
    }
    return const Icon(Icons.close, size: 18, color: Color(0xFFD1D5DB));
  }
}

