import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class CreateCourseScreen extends StatefulWidget {
  const CreateCourseScreen({super.key});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  int _step = 1;
  final _tags = <String>['JEE', 'Physics'];
  final _titleCtrl = TextEditingController();
  final _tagCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _tagCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Course', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Steps(current: _step),
          const SizedBox(height: 12),
          if (_step == 1) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Course Details', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Course Title', hintText: 'e.g., Complete JEE Physics Course')),
                  const SizedBox(height: 12),
                  const TextField(maxLines: 4, decoration: InputDecoration(labelText: 'Description', hintText: 'Describe what students will learn...')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: const [
                      DropdownMenuItem(value: 'jee', child: Text('JEE')),
                      DropdownMenuItem(value: 'neet', child: Text('NEET')),
                      DropdownMenuItem(value: 'cbse', child: Text('CBSE Board')),
                      DropdownMenuItem(value: 'foundation', child: Text('Foundation')),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Difficulty Level'),
                    items: const [
                      DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
                      DropdownMenuItem(value: 'intermediate', child: Text('Intermediate')),
                      DropdownMenuItem(value: 'advanced', child: Text('Advanced')),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 12),
                  const Text('Tags', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in _tags)
                        Chip(
                          label: Text(t),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => setState(() => _tags.remove(t)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _tagCtrl, decoration: const InputDecoration(hintText: 'Add tag...'))),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {
                          final v = _tagCtrl.text.trim();
                          if (v.isEmpty) return;
                          setState(() {
                            _tags.add(v);
                            _tagCtrl.clear();
                          });
                        },
                        style: OutlinedButton.styleFrom(minimumSize: const Size(44, 44)),
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Course Thumbnail', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Theme.of(context).dividerColor, width: 2),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.image_outlined, size: 48, color: muted),
                        const SizedBox(height: 6),
                        Text('Click to upload or drag and drop', style: TextStyle(color: muted, fontSize: 12)),
                        Text('PNG, JPG up to 5MB', style: TextStyle(color: muted, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_step == 2) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Course Content', style: TextStyle(fontWeight: FontWeight.w600)),
                      FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('Add Module')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (var module = 1; module <= 3; module++) ...[
                    AppCard(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Module $module: Introduction', style: const TextStyle(fontWeight: FontWeight.w600)),
                              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 18), label: const Text('Add Lecture')),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _contentRow(context, Icons.videocam_outlined, primary, 'Lecture 1: Basics', '12:34 mins'),
                          const SizedBox(height: 8),
                          _contentRow(context, Icons.description_outlined, AppColors.success, 'Notes PDF', '2.3 MB'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload_file, size: 18), label: const Text('Upload Multiple Files')),
          ],
          if (_step == 3) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pricing Details', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Pricing Type'),
                    items: const [
                      DropdownMenuItem(value: 'free', child: Text('Free')),
                      DropdownMenuItem(value: 'paid', child: Text('Paid')),
                      DropdownMenuItem(value: 'subscription', child: Text('Subscription')),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'Course Price', hintText: '15000'), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'Discounted Price (Optional)', hintText: '12000'), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Duration (Days)', hintText: '365'), keyboardType: TextInputType.number)),
                      SizedBox(width: 12),
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Max Students', hintText: '500'), keyboardType: TextInputType.number)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        _kv('Course Price', '₹15,000', muted),
                        _kv('Platform Fee (10%)', '₹1,500', muted),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Your Earning', style: TextStyle(fontWeight: FontWeight.w600)),
                            Text('₹13,500', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_step == 4) ...[
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Review & Publish', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  _kv('Course Title', 'Complete JEE Physics', muted),
                  _kv('Category', 'JEE', muted),
                  _kv('Modules', '3 Modules', muted),
                  _kv('Total Lectures', '45 Videos', muted),
                  _kv('Price', '₹15,000', muted),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Your Earning', style: TextStyle(color: Colors.black54)),
                      Text('₹13,500', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'Once published, the course will be visible to all students. Make sure all content is uploaded and verified.',
                      style: TextStyle(color: AppColors.warning, fontSize: 12, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (_step > 1)
                Expanded(
                  child: OutlinedButton(onPressed: () => setState(() => _step--), child: const Text('Previous')),
                ),
              if (_step > 1) const SizedBox(width: 12),
              Expanded(
                child: _step < 4
                    ? FilledButton(onPressed: () => setState(() => _step++), child: const Text('Next'))
                    : FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                        onPressed: () {
                          final title = _titleCtrl.text.trim();
                          context.pop({
                            'title': title.isEmpty ? 'Untitled Course' : title,
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Publish Course'),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contentRow(BuildContext context, IconData icon, Color c, String title, String subtitle) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: c),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(subtitle, style: TextStyle(color: muted, fontSize: 11)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.close, size: 18)),
        ],
      ),
    );
  }

  Widget _kv(String k, String v, Color? muted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: TextStyle(color: muted, fontSize: 12)),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  const _Steps({required this.current});
  final int current;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final steps = const [
      (1, 'Basic Info'),
      (2, 'Content'),
      (3, 'Pricing'),
      (4, 'Publish'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: current >= steps[i].$1 ? primary : Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${steps[i].$1}',
                    style: TextStyle(color: current >= steps[i].$1 ? Colors.white : muted, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  steps[i].$2,
                  style: TextStyle(fontWeight: current >= steps[i].$1 ? FontWeight.w600 : FontWeight.normal, color: current >= steps[i].$1 ? null : muted),
                ),
              ],
            ),
            if (i < steps.length - 1)
              Container(
                width: 26,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                color: current > steps[i].$1 ? primary : Theme.of(context).dividerColor,
              ),
          ],
        ],
      ),
    );
  }
}

