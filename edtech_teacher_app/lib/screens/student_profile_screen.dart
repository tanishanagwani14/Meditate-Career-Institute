import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class StudentProfile {
  const StudentProfile({
    required this.name,
    required this.batch,
    required this.progress,
    required this.lastActive,
    required this.doubts,
    required this.assignments,
    required this.performance,
    this.email,
  });

  final String name;
  final String batch;
  final int progress;
  final String lastActive;
  final int doubts;
  final int assignments;
  final String performance;
  final String? email;
}

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key, required this.student});

  final StudentProfile student;

  Color _perfColor(BuildContext context) {
    switch (student.performance) {
      case 'Excellent':
        return AppColors.success;
      case 'Good':
        return Theme.of(context).colorScheme.primary;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final perfColor = _perfColor(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile', style: TextStyle(fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: primary.withValues(alpha: 0.15),
                  child: Text(
                    student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                    style: TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                      const SizedBox(height: 2),
                      Text(student.batch, style: TextStyle(color: muted, fontSize: 13)),
                      if (student.email != null && student.email!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(student.email!, style: TextStyle(color: muted, fontSize: 12)),
                      ],
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: perfColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          student.performance,
                          style: TextStyle(fontSize: 11, color: perfColor, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Course Progress', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Overall', style: TextStyle(color: muted, fontSize: 12)),
                    Text('${student.progress}%', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: student.progress / 100,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  icon: Icons.chat_bubble_outline,
                  label: 'Doubts',
                  value: '${student.doubts}',
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  icon: Icons.check_circle_outline,
                  label: 'Assignments',
                  value: '${student.assignments}',
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.schedule, color: muted),
                  title: const Text('Last active'),
                  subtitle: Text(student.lastActive),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.menu_book_outlined, color: muted),
                  title: const Text('Batch'),
                  subtitle: Text(student.batch),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Message ${student.name}')),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Message'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling ${student.name}…')),
                    );
                  },
                  icon: const Icon(Icons.call_outlined, size: 18),
                  label: const Text('Call'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: muted)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
