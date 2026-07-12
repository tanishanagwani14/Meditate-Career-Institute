import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 56, color: muted),
              const SizedBox(height: 12),
              const Text('Page not found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('The page you requested does not exist.', style: TextStyle(color: muted)),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => context.go('/'), child: const Text('Go to Dashboard')),
            ],
          ),
        ),
      ),
    );
  }
}

