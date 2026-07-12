import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/students_store.dart';
import '../../../widgets/shared/page_header.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  String _course = 'JEE Advanced';
  String _batch = 'Batch A1';
  String _status = 'active';
  String _feeStatus = 'Pending';

  static const _courses = ['JEE Advanced', 'NEET', 'Foundation', 'JEE Mains'];
  static const _batches = ['Batch A1', 'Batch A2', 'Batch B1', 'Batch B2', 'Batch C1'];

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final today = DateTime.now();
    final enrolled =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    StudentsStore.instance.addStudent((
      _name.text.trim(),
      _email.text.trim(),
      _phone.text.trim(),
      _course,
      _batch,
      _status,
      _feeStatus,
      enrolled,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_name.text.trim()} added successfully')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Add Student',
          subtitle: 'Enroll a new student in the institute',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Full name *'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email *'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Email is required';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone *'),
                    validator: (v) => v == null || v.trim().length < 10 ? 'Enter a valid phone' : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _course,
                    decoration: const InputDecoration(labelText: 'Course'),
                    items: [for (final c in _courses) DropdownMenuItem(value: c, child: Text(c))],
                    onChanged: (v) => setState(() => _course = v ?? _course),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _batch,
                    decoration: const InputDecoration(labelText: 'Batch'),
                    items: [for (final b in _batches) DropdownMenuItem(value: b, child: Text(b))],
                    onChanged: (v) => setState(() => _batch = v ?? _batch),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _status,
                          decoration: const InputDecoration(labelText: 'Status'),
                          items: const [
                            DropdownMenuItem(value: 'active', child: Text('Active')),
                            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                          ],
                          onChanged: (v) => setState(() => _status = v ?? _status),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _feeStatus,
                          decoration: const InputDecoration(labelText: 'Fee status'),
                          items: const [
                            DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                            DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                            DropdownMenuItem(value: 'Overdue', child: Text('Overdue')),
                          ],
                          onChanged: (v) => setState(() => _feeStatus = v ?? _feeStatus),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.person_add_outlined, size: 20),
                    label: const Text('Add Student'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
