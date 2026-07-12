import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _terms = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text('Create Account', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Sign up to start your learning journey', style: TextStyle(color: muted)),
                const SizedBox(height: 24),
                _labeledField(context, 'Full Name', TextField(
                  controller: _name,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                )),
                _labeledField(context, 'Email', TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                )),
                _labeledField(context, 'Phone Number', TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                )),
                _labeledField(
                  context,
                  'Password',
                  TextField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Create a password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(value: _terms, onChanged: (v) => setState(() => _terms = v ?? false)),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: muted, fontSize: 13, height: 1.4),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(text: 'Terms & Conditions', style: TextStyle(color: primary, fontWeight: FontWeight.w500)),
                            const TextSpan(text: ' and '),
                            TextSpan(text: 'Privacy Policy', style: TextStyle(color: primary, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: _terms
                      ? () {
                          final phone = _phone.text.trim();
                          if (phone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter your phone number')),
                            );
                            return;
                          }
                          context.push(
                            Uri(
                              path: '/otp-verification',
                              queryParameters: {'phone': phone},
                            ).toString(),
                          );
                        }
                      : null,
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(color: muted, fontSize: 14),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text('Sign In', style: TextStyle(color: primary, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _labeledField(BuildContext context, String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 13)),
          const SizedBox(height: 8),
          field,
        ],
      ),
    );
  }
}
