import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class CreateTestScreen extends StatefulWidget {
  const CreateTestScreen({super.key});

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Test', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Test Details', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const TextField(decoration: InputDecoration(labelText: 'Test Title', hintText: 'e.g., Physics Chapter Test')),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Select Batch'),
                  items: const [
                    DropdownMenuItem(value: 'jee2024', child: Text('JEE 2024 Batch')),
                    DropdownMenuItem(value: 'neet2024', child: Text('NEET 2024 Batch')),
                    DropdownMenuItem(value: 'class12', child: Text('Class 12 CBSE')),
                  ],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Total Questions', hintText: '30'), keyboardType: TextInputType.number)),
                    SizedBox(width: 12),
                    Expanded(child: TextField(decoration: InputDecoration(labelText: 'Duration (mins)', hintText: '60'), keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 12),
                const TextField(maxLines: 4, decoration: InputDecoration(labelText: 'Instructions', hintText: 'Add test instructions...')),
                const SizedBox(height: 12),
                AppCard(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: muted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You can add questions later. Publishing will make the test visible to students.',
                          style: TextStyle(color: muted, fontSize: 12, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () => context.pop(), icon: const Icon(Icons.save_outlined, size: 18), label: const Text('Save Test')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        ],
      ),
    );
  }
}

