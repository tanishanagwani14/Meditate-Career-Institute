import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/enterprise_theme.dart';

class OnboardInstituteResult {
  const OnboardInstituteResult({
    required this.name,
    required this.plan,
    required this.contact,
    required this.region,
  });

  final String name;
  final String plan;
  final String contact;
  final String region;
}

class OnboardInstituteScreen extends StatefulWidget {
  const OnboardInstituteScreen({super.key});

  @override
  State<OnboardInstituteScreen> createState() => _OnboardInstituteScreenState();
}

class _OnboardInstituteScreenState extends State<OnboardInstituteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();

  String _plan = 'Enterprise';
  String _region = 'US-East';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Onboard Institute', style: TextStyle(fontWeight: FontWeight.w600)),
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
                  const Text('Institute details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: EnterpriseTheme.gray900)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Institute name'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Institute name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _contactCtrl,
                    decoration: const InputDecoration(labelText: 'Contact email'),
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Contact email is required';
                      if (!s.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _plan,
                    decoration: const InputDecoration(labelText: 'Plan'),
                    items: const [
                      DropdownMenuItem(value: 'Enterprise', child: Text('Enterprise')),
                      DropdownMenuItem(value: 'Professional', child: Text('Professional')),
                      DropdownMenuItem(value: 'Basic', child: Text('Basic')),
                    ],
                    onChanged: (v) => setState(() => _plan = v ?? _plan),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _region,
                    decoration: const InputDecoration(labelText: 'Region'),
                    items: const [
                      DropdownMenuItem(value: 'US-East', child: Text('US-East')),
                      DropdownMenuItem(value: 'US-West', child: Text('US-West')),
                      DropdownMenuItem(value: 'EU-West', child: Text('EU-West')),
                      DropdownMenuItem(value: 'EU-Central', child: Text('EU-Central')),
                      DropdownMenuItem(value: 'APAC', child: Text('APAC')),
                      DropdownMenuItem(value: 'US-Central', child: Text('US-Central')),
                    ],
                    onChanged: (v) => setState(() => _region = v ?? _region),
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
                            OnboardInstituteResult(
                              name: _nameCtrl.text.trim(),
                              plan: _plan,
                              contact: _contactCtrl.text.trim(),
                              region: _region,
                            ),
                          );
                        },
                        child: const Text('Submit'),
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

