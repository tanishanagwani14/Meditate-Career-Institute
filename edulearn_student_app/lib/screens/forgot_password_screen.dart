import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(Icons.vpn_key_outlined, size: 64, color: primary),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Forgot Password?',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "No worries, we'll send you reset instructions",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: muted),
                        ),
                        const SizedBox(height: 32),
                        Text('Email', style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 13)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => context.go('/login'),
                          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                          child: const Text('Reset Password'),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text('Back to Sign In', style: TextStyle(color: muted)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
