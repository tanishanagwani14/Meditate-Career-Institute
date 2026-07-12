import 'package:flutter/material.dart';

import '../../widgets/shared/page_header.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(title: title, subtitle: subtitle ?? 'UI page scaffold (Flutter port)'),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'This page is scaffolded. If you want, I can port the exact cards/tables from the React UI for this section next.',
              style: TextStyle(color: muted),
            ),
          ),
        ),
      ],
    );
  }
}

