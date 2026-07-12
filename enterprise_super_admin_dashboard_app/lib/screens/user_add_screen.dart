import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/enterprise_theme.dart';

class AddUserResult {
  const AddUserResult({
    required this.name,
    required this.email,
    required this.institute,
    required this.role,
  });

  final String name;
  final String email;
  final String institute;
  final String role;
}

class UserAddScreen extends StatefulWidget {
  const UserAddScreen({super.key});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _instituteCtrl = TextEditingController();

  String _role = 'Teacher';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _instituteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Add User', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: EnterpriseTheme.gray200),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('User details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EnterpriseTheme.gray900)),
                  const SizedBox(height: 16),
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
                    controller: _instituteCtrl,
                    decoration: const InputDecoration(labelText: 'Institute'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Institute is required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _role,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: const [
                      DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                      DropdownMenuItem(value: 'Teacher', child: Text('Teacher')),
                      DropdownMenuItem(value: 'Student', child: Text('Student')),
                      DropdownMenuItem(value: 'Super Admin', child: Text('Super Admin')),
                    ],
                    onChanged: (v) => setState(() => _role = v ?? _role),
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
                      ElevatedButton(
                        onPressed: () {
                          if (!(_formKey.currentState?.validate() ?? false)) return;
                          context.pop(
                            AddUserResult(
                              name: _nameCtrl.text.trim(),
                              email: _emailCtrl.text.trim(),
                              institute: _instituteCtrl.text.trim(),
                              role: _role,
                            ),
                          );
                        },
                        child: const Text('Add'),
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
}

