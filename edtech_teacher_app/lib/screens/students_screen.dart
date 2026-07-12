import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import 'student_profile_screen.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _q = '';
  String _batch = 'all';
  String _performanceFilter = 'all';
  String _newStudentBatch = 'JEE 2024 Batch';
  int _totalStudents = 1248;
  final _searchCtrl = TextEditingController();

  static const _performanceOptions = ['all', 'Excellent', 'Good', 'Needs Attention'];

  static const _batches = [
    ('JEE 2024 Batch', 245, 198),
    ('NEET 2024 Batch', 189, 167),
    ('Class 12 CBSE', 156, 142),
  ];

  final _students = [
    const _Student('Rahul Sharma', 'JEE 2024 Batch', 78, '2 hours ago', 3, 12, 'Excellent'),
    const _Student('Priya Patel', 'NEET 2024 Batch', 92, '30 mins ago', 1, 15, 'Excellent'),
    const _Student('Amit Kumar', 'JEE 2024 Batch', 65, '1 day ago', 5, 10, 'Good'),
    const _Student('Sneha Reddy', 'Class 12 CBSE', 88, '5 hours ago', 2, 14, 'Excellent'),
    const _Student('Karan Singh', 'JEE 2024 Batch', 45, '3 days ago', 8, 7, 'Needs Attention'),
  ];

  Future<void> _showAddStudentDialog() async {
    final result = await showDialog<_AddStudentResult>(
      context: context,
      builder: (ctx) => _AddStudentDialog(
        batches: _batches.map((b) => b.$1).toList(),
        initialBatch: _newStudentBatch,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _newStudentBatch = result.batch;
        _students.insert(
          0,
          _Student(result.name, result.batch, 0, 'Just now', 0, 0, 'Good'),
        );
        _totalStudents++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${result.name} added to ${result.batch}')),
      );
    }
  }

  String get _totalStudentsLabel {
    final s = _totalStudents.toString();
    if (s.length <= 3) return s;
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<_Student> get _filtered {
    return _students.where((s) {
      final okSearch = _q.isEmpty || s.name.toLowerCase().contains(_q.toLowerCase());
      final okBatch = _batch == 'all' || s.batch == _batch;
      final okPerf = _performanceFilter == 'all' || s.performance == _performanceFilter;
      return okSearch && okBatch && okPerf;
    }).toList();
  }

  Future<void> _showFilterSheet() async {
    var batch = _batch;
    var performance = _performanceFilter;

    final muted = Theme.of(context).textTheme.bodySmall?.color;

    final applied = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Filter Students', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 14),
                    Text('Batch', style: TextStyle(color: muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _FilterChipButton(
                          label: 'All',
                          selected: batch == 'all',
                          onTap: () => setSheetState(() => batch = 'all'),
                        ),
                        for (final b in _batches)
                          _FilterChipButton(
                            label: b.$1,
                            selected: batch == b.$1,
                            onTap: () => setSheetState(() => batch = b.$1),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Performance', style: TextStyle(color: muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final p in _performanceOptions)
                          _FilterChipButton(
                            label: p == 'all' ? 'All' : p,
                            selected: performance == p,
                            onTap: () => setSheetState(() => performance = p),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setSheetState(() {
                                batch = 'all';
                                performance = 'all';
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (applied == true && mounted) {
      setState(() {
        _batch = batch;
        _performanceFilter = performance;
      });
    }
  }

  void _openStudentProfile(_Student s) {
    context.push(
      '/student-profile',
      extra: StudentProfile(
        name: s.name,
        batch: s.batch,
        progress: s.progress,
        lastActive: s.lastActive,
        doubts: s.doubts,
        assignments: s.assignments,
        performance: s.performance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Students', style: Theme.of(context).textTheme.titleLarge),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: _showFilterSheet,
                  icon: const Icon(Icons.tune, size: 18),
                  label: Text(
                    (_batch != 'all' || _performanceFilter != 'all') ? 'Filter •' : 'Filter',
                  ),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _showAddStudentDialog,
                  icon: const Icon(Icons.person_add_outlined, size: 18),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.95,
          children: [
            _MiniStat(value: _totalStudentsLabel, label: 'Total Students'),
            const _MiniStat(value: '987', label: 'Active', valueColor: AppColors.success),
            const _MiniStat(value: '24', label: 'Pending Doubts', valueColor: AppColors.warning),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: 'Search students by name...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _q.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _q = '');
                    },
                  ),
          ),
          onChanged: (v) => setState(() => _q = v),
        ),
        const SizedBox(height: 16),
        const Text('Batches', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
          children: [
            for (final b in _batches)
              _BatchCard(
                title: b.$1,
                total: b.$2,
                active: b.$3,
                selected: _batch == b.$1,
                primary: primary,
                muted: muted,
                onTap: () => setState(() => _batch = b.$1),
              ),
          ],
        ),
        if (_batch != 'all') ...[
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => setState(() => _batch = 'all'), child: const Text('Clear Filter')),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Students List', style: TextStyle(fontWeight: FontWeight.w600)),
            Text('${_filtered.length} of ${_students.length}', style: TextStyle(color: muted, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        if (_filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, color: muted, size: 32),
                  const SizedBox(height: 8),
                  Text('No students match your filters', style: TextStyle(color: muted)),
                ],
              ),
            ),
          ),
        for (final s in _filtered) ...[
          AppCard(
            padding: const EdgeInsets.all(12),
            onTap: () => _openStudentProfile(s),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(radius: 20, backgroundColor: primary.withValues(alpha: 0.15), child: Text(s.name[0], style: TextStyle(color: primary, fontWeight: FontWeight.w700))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert, color: muted),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      Text(s.batch, style: TextStyle(color: muted, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: muted),
                          const SizedBox(width: 4),
                          Text(s.lastActive, style: TextStyle(fontSize: 12, color: muted)),
                          const SizedBox(width: 10),
                          _perfChip(s.performance),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress', style: TextStyle(color: muted, fontSize: 11)),
                          Text('${s.progress}%', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: s.progress / 100,
                          minHeight: 6,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _mini(Icons.chat_bubble_outline, 'Doubts', '${s.doubts}', AppColors.warning)),
                          const SizedBox(width: 12),
                          Expanded(child: _mini(Icons.check_circle_outline, 'Assignments', '${s.assignments}', AppColors.success)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _mini(IconData icon, String label, String value, Color c) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      children: [
        Icon(icon, size: 18, color: c),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: muted)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _perfChip(String perf) {
    Color c;
    if (perf == 'Excellent') {
      c = AppColors.success;
    } else if (perf == 'Good') {
      c = Theme.of(context).colorScheme.primary;
    } else {
      c = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
      child: Text(perf, style: TextStyle(fontSize: 11, color: c, fontWeight: FontWeight.w700)),
    );
  }
}

class _BatchCard extends StatelessWidget {
  const _BatchCard({
    required this.title,
    required this.total,
    required this.active,
    required this.selected,
    required this.primary,
    required this.muted,
    required this.onTap,
  });

  final String title;
  final int total;
  final int active;
  final bool selected;
  final Color primary;
  final Color? muted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: selected ? BorderSide(color: primary, width: 2) : null,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.people_outline, size: 18, color: primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, height: 1.15),
                ),
                Text(
                  '$total students · $active active',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted, fontSize: 10, height: 1.15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label, this.valueColor});
  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, height: 1.1, color: valueColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, height: 1.2, color: muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Student {
  const _Student(this.name, this.batch, this.progress, this.lastActive, this.doubts, this.assignments, this.performance);
  final String name;
  final String batch;
  final int progress;
  final String lastActive;
  final int doubts;
  final int assignments;
  final String performance;
}

class _AddStudentResult {
  const _AddStudentResult({required this.name, required this.email, required this.batch});
  final String name;
  final String email;
  final String batch;
}

class _AddStudentDialog extends StatefulWidget {
  const _AddStudentDialog({required this.batches, required this.initialBatch});

  final List<String> batches;
  final String initialBatch;

  @override
  State<_AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<_AddStudentDialog> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  late String _batch = widget.initialBatch;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter student name')),
      );
      return;
    }
    Navigator.pop(
      context,
      _AddStudentResult(name: name, email: _emailCtrl.text.trim(), batch: _batch),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Student'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'e.g., Rahul Sharma',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email (Optional)',
                hintText: 'student@email.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: ValueKey(_batch),
              initialValue: _batch,
              decoration: const InputDecoration(labelText: 'Batch'),
              items: [
                for (final b in widget.batches) DropdownMenuItem(value: b, child: Text(b)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _batch = v);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.person_add_outlined, size: 18),
          label: const Text('Add Student'),
        ),
      ],
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.12) : null,
          border: Border.all(color: selected ? primary : Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? primary : null,
            fontWeight: selected ? FontWeight.w600 : null,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

