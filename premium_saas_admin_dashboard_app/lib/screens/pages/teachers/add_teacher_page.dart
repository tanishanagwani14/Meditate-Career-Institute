import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/shared/page_header.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectsCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController(text: '1');

  String _status = 'active';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectsCtrl.dispose();
    _experienceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          PageHeader(
            title: 'Add Teacher',
            subtitle: 'Enter teacher details',
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
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) {
                        final s = (v ?? '').trim();
                        if (s.isEmpty) return 'Email is required';
                        if (!s.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtrl,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _subjectsCtrl,
                      decoration: const InputDecoration(labelText: 'Subjects (comma separated)'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Subjects are required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _experienceCtrl,
                      decoration: const InputDecoration(labelText: 'Experience (years)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final n = int.tryParse((v ?? '').trim());
                        if (n == null || n < 0) return 'Enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: const [
                        DropdownMenuItem(value: 'active', child: Text('Active')),
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
                              SnackBar(content: Text('Teacher ${_nameCtrl.text.trim()} added (demo)')),
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

