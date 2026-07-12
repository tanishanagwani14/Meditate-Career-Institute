import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/shared/page_header.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key});

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _feeCtrl = TextEditingController();

  String _status = 'active';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _durationCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Create Course',
            subtitle: 'Add a new course (demo)',
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
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Course name'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Course name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _categoryCtrl,
                      decoration: const InputDecoration(labelText: 'Category'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Category is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _durationCtrl,
                      decoration: const InputDecoration(labelText: 'Duration (e.g. 6 months)'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _feeCtrl,
                      decoration: const InputDecoration(labelText: 'Course fee (₹)'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Active')),
                        DropdownMenuItem(value: 'pending', child: Text('Pending')),
                        DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                      ],
                      onChanged: (v) => setState(() => _status = v ?? _status),
                    ),
                    const SizedBox(height: 20),
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
                            if (!(_formKey.currentState?.validate() ?? false)) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Created course ${_nameCtrl.text.trim()} (demo)')),
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
          ),
        ],
      ),
    );
  }
}

