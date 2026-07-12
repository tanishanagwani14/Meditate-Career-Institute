import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _tab = 'all';
  String _q = '';

  final _courses = [
    _Course(
      id: 1,
      title: 'Complete JEE Main & Advanced Course',
      students: 245,
      lectures: 180,
      tests: 25,
      revenue: 245000,
      status: 'Published',
      progress: 75,
      thumb: const [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    ),
    _Course(
      id: 2,
      title: 'NEET Biology - Complete Course',
      students: 189,
      lectures: 120,
      tests: 18,
      revenue: 189000,
      status: 'Published',
      progress: 90,
      thumb: const [Color(0xFF10B981), Color(0xFF3B82F6)],
    ),
    _Course(
      id: 3,
      title: 'Physics Class 12 - CBSE Board',
      students: 156,
      lectures: 95,
      tests: 12,
      revenue: 78000,
      status: 'Published',
      progress: 100,
      thumb: const [Color(0xFFEC4899), Color(0xFF6366F1)],
    ),
    _Course(
      id: 4,
      title: 'Mathematics Crash Course - JEE',
      students: 92,
      lectures: 45,
      tests: 8,
      revenue: 46000,
      status: 'Draft',
      progress: 35,
      thumb: const [Color(0xFFF59E0B), Color(0xFFEF4444)],
    ),
  ];

  List<_Course> get _filtered {
    return _courses.where((c) {
      final okTab = _tab == 'all' || c.status.toLowerCase() == _tab;
      final okSearch = _q.isEmpty || c.title.toLowerCase().contains(_q.toLowerCase());
      return okTab && okSearch;
    }).toList();
  }

  int _indexOf(_Course course) => _courses.indexWhere((c) => c.id == course.id);

  void _updateCourse(int index, _Course updated) {
    setState(() => _courses[index] = updated);
  }

  Future<void> _openCreateCourse() async {
    final result = await context.push<Map<String, dynamic>>('/courses/create');
    if (!mounted || result == null) return;

    setState(() {
      _courses.add(
        _Course(
          id: _courses.length + 1,
          title: result['title'] as String? ?? 'New Course',
          students: 0,
          lectures: 0,
          tests: 0,
          revenue: 0,
          status: 'Published',
          progress: 0,
          thumb: const [Color(0xFF06B6D4), Color(0xFF3B82F6)],
        ),
      );
    });
  }

  void _viewCourse(_Course course) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(course.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                const SizedBox(height: 12),
                _detailRow(ctx, 'Status', course.status),
                _detailRow(ctx, 'Progress', '${course.progress}%'),
                _detailRow(ctx, 'Students', '${course.students}'),
                _detailRow(ctx, 'Lectures', '${course.lectures}'),
                _detailRow(ctx, 'Tests', '${course.tests}'),
                _detailRow(ctx, 'Revenue', '₹${(course.revenue / 1000).toStringAsFixed(0)}k'),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _editCourse(course);
                  },
                  child: const Text('Edit Course'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Close', style: TextStyle(color: muted)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: muted, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Future<void> _editCourse(_Course course) async {
    final index = _indexOf(course);
    if (index < 0) return;

    final result = await showDialog<_EditCourseResult>(
      context: context,
      builder: (ctx) => _EditCourseDialog(
        initialTitle: course.title,
        initialProgress: course.progress,
        initialStatus: course.status,
      ),
    );

    if (result == null || !mounted) return;

    _updateCourse(
      index,
      course.copyWith(
        title: result.title.isEmpty ? course.title : result.title,
        progress: result.progress,
        status: result.status,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Course updated')),
    );
  }

  Future<void> _showCourseMenu(_Course course) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.publish_outlined),
                title: Text(course.status == 'Published' ? 'Move to Draft' : 'Publish Course'),
                onTap: () => Navigator.pop(ctx, 'toggle'),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.destructive),
                title: const Text('Delete Course', style: TextStyle(color: AppColors.destructive)),
                onTap: () => Navigator.pop(ctx, 'delete'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || action == null) return;

    final index = _indexOf(course);
    if (index < 0) return;

    if (action == 'toggle') {
      final next = course.status == 'Published' ? 'Draft' : 'Published';
      _updateCourse(index, course.copyWith(status: next));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course marked as $next')),
      );
    } else if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete Course?'),
          content: Text('Remove "${course.title}" from your courses?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.destructive),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirm == true && mounted) {
        setState(() => _courses.removeAt(index));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    final publishedCount = _courses.where((c) => c.status == 'Published').length;
    final draftCount = _courses.where((c) => c.status == 'Draft').length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Courses', style: Theme.of(context).textTheme.titleLarge),
            FilledButton.icon(
              onPressed: _openCreateCourse,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Course'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search courses...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _q = v),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _chip(context, 'all', 'All (${_courses.length})'),
              const SizedBox(width: 8),
              _chip(context, 'published', 'Published ($publishedCount)'),
              const SizedBox(width: 8),
              _chip(context, 'draft', 'Draft ($draftCount)'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final c in _filtered) ...[
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 128,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: c.thumb),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (c.status == 'Published' ? AppColors.success : AppColors.warning).withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          c.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: c.status == 'Published' ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _meta(Icons.people_outline, '${c.students}', muted),
                          const SizedBox(width: 14),
                          _meta(Icons.play_circle_outline, '${c.lectures}', muted),
                          const SizedBox(width: 14),
                          _meta(Icons.description_outlined, '${c.tests}', muted),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Course Progress', style: TextStyle(color: muted, fontSize: 12)),
                          Text('${c.progress}%', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: c.progress / 100,
                          minHeight: 8,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'View course',
                            onPressed: () => _viewCourse(c),
                            icon: Icon(Icons.visibility_outlined, color: muted),
                          ),
                          IconButton(
                            tooltip: 'Edit course',
                            onPressed: () => _editCourse(c),
                            icon: Icon(Icons.edit_outlined, color: muted),
                          ),
                          IconButton(
                            tooltip: 'More options',
                            onPressed: () => _showCourseMenu(c),
                            icon: Icon(Icons.more_vert, color: muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }

  Widget _chip(BuildContext context, String id, String label) {
    final selected = _tab == id;
    return selected
        ? FilledButton(
            onPressed: () => setState(() => _tab = id),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
            child: Text(label),
          )
        : OutlinedButton(
            onPressed: () => setState(() => _tab = id),
            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
            child: Text(label),
          );
  }

  Widget _meta(IconData icon, String text, Color? muted) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: muted),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: muted, fontSize: 12)),
      ],
    );
  }
}

class _EditCourseResult {
  const _EditCourseResult({required this.title, required this.progress, required this.status});
  final String title;
  final int progress;
  final String status;
}

class _EditCourseDialog extends StatefulWidget {
  const _EditCourseDialog({
    required this.initialTitle,
    required this.initialProgress,
    required this.initialStatus,
  });

  final String initialTitle;
  final int initialProgress;
  final String initialStatus;

  @override
  State<_EditCourseDialog> createState() => _EditCourseDialogState();
}

class _EditCourseDialogState extends State<_EditCourseDialog> {
  late final _titleCtrl = TextEditingController(text: widget.initialTitle);
  late double _progress = widget.initialProgress.toDouble();
  late String _status = widget.initialStatus;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Course'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress'),
                Text('${_progress.round()}%'),
              ],
            ),
            Slider(
              value: _progress,
              min: 0,
              max: 100,
              divisions: 20,
              label: '${_progress.round()}%',
              onChanged: (v) => setState(() => _progress = v),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: ValueKey(_status),
              initialValue: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(value: 'Published', child: Text('Published')),
                DropdownMenuItem(value: 'Draft', child: Text('Draft')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _status = v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(
            context,
            _EditCourseResult(
              title: _titleCtrl.text.trim(),
              progress: _progress.round(),
              status: _status,
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _Course {
  _Course({
    required this.id,
    required this.title,
    required this.students,
    required this.lectures,
    required this.tests,
    required this.revenue,
    required this.status,
    required this.progress,
    required this.thumb,
  });

  final int id;
  final String title;
  final int students;
  final int lectures;
  final int tests;
  final int revenue;
  final String status;
  final int progress;
  final List<Color> thumb;

  _Course copyWith({
    String? title,
    int? students,
    int? lectures,
    int? tests,
    int? revenue,
    String? status,
    int? progress,
    List<Color>? thumb,
  }) {
    return _Course(
      id: id,
      title: title ?? this.title,
      students: students ?? this.students,
      lectures: lectures ?? this.lectures,
      tests: tests ?? this.tests,
      revenue: revenue ?? this.revenue,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      thumb: thumb ?? this.thumb,
    );
  }
}
