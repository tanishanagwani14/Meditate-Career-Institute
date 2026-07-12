import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/shared/page_header.dart';

class TeacherPermissionsEditPage extends StatefulWidget {
  const TeacherPermissionsEditPage({super.key});

  @override
  State<TeacherPermissionsEditPage> createState() => _TeacherPermissionsEditPageState();
}

class _TeacherPermissionsEditPageState extends State<TeacherPermissionsEditPage> {
  bool studentsView = true;
  bool studentsEdit = true;
  bool attendanceView = true;
  bool attendanceEdit = false;
  bool gradesView = true;
  bool gradesEdit = true;
  bool financeView = true;
  bool financeEdit = false;
  bool content = true;
  bool reports = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Edit Permissions',
            subtitle: 'Update access for this teacher (demo)',
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
                children: [
                  _pair('Students', studentsView, studentsEdit, (v) => setState(() => studentsView = v), (v) => setState(() => studentsEdit = v)),
                  const Divider(height: 24),
                  _pair('Attendance', attendanceView, attendanceEdit, (v) => setState(() => attendanceView = v), (v) => setState(() => attendanceEdit = v)),
                  const Divider(height: 24),
                  _pair('Grades', gradesView, gradesEdit, (v) => setState(() => gradesView = v), (v) => setState(() => gradesEdit = v)),
                  const Divider(height: 24),
                  _pair('Finance', financeView, financeEdit, (v) => setState(() => financeView = v), (v) => setState(() => financeEdit = v)),
                  const Divider(height: 24),
                  SwitchListTile(
                    title: const Text('Content'),
                    value: content,
                    onChanged: (v) => setState(() => content = v),
                  ),
                  SwitchListTile(
                    title: const Text('Reports'),
                    value: reports,
                    onChanged: (v) => setState(() => reports = v),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => context.pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Permissions saved (demo)')),
                          );
                          context.pop();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pair(
    String label,
    bool view,
    bool edit,
    ValueChanged<bool> onView,
    ValueChanged<bool> onEdit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('View'),
                value: view,
                onChanged: (v) => onView(v ?? false),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('Edit'),
                value: edit,
                onChanged: (v) => onEdit(v ?? false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

