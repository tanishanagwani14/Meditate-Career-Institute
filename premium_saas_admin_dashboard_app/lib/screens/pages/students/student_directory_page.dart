import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/students_store.dart';
import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class StudentDirectoryPage extends StatefulWidget {
  const StudentDirectoryPage({super.key});

  @override
  State<StudentDirectoryPage> createState() => _StudentDirectoryPageState();
}

class _StudentDirectoryPageState extends State<StudentDirectoryPage> {
  final _store = StudentsStore.instance;
  final _searchCtrl = TextEditingController();

  String _query = '';
  String _courseFilter = 'All';
  String _statusFilter = 'All';
  String _feeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  List<StudentRow> _filtered() {
    return _store.items.where((s) {
      if (_courseFilter != 'All' && s.$4 != _courseFilter) return false;
      if (_statusFilter != 'All' && s.$6 != _statusFilter) return false;
      if (_feeFilter != 'All' && s.$7 != _feeFilter) return false;
      if (_query.trim().isEmpty) return true;
      final q = _query.trim().toLowerCase();
      return s.$1.toLowerCase().contains(q) ||
          s.$2.toLowerCase().contains(q) ||
          s.$3.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openFilters() async {
    var course = _courseFilter;
    var status = _statusFilter;
    var fee = _feeFilter;

    final applied = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.paddingOf(ctx).bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Filter students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: course,
                    decoration: const InputDecoration(labelText: 'Course'),
                    items: [
                      for (final c in StudentsStore.courses)
                        DropdownMenuItem(value: c, child: Text(c)),
                    ],
                    onChanged: (v) => setModalState(() => course = v ?? course),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: [
                      for (final s in StudentsStore.statuses)
                        DropdownMenuItem(value: s, child: Text(s)),
                    ],
                    onChanged: (v) => setModalState(() => status = v ?? status),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: fee,
                    decoration: const InputDecoration(labelText: 'Fee status'),
                    items: [
                      for (final f in StudentsStore.feeStatuses)
                        DropdownMenuItem(value: f, child: Text(f)),
                    ],
                    onChanged: (v) => setModalState(() => fee = v ?? fee),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _courseFilter = 'All';
                              _statusFilter = 'All';
                              _feeFilter = 'All';
                            });
                            Navigator.pop(ctx, true);
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
            );
          },
        );
      },
    );

    if (applied == true && mounted) {
      setState(() {
        _courseFilter = course;
        _statusFilter = status;
        _feeFilter = fee;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered();
    final hasFilters = _courseFilter != 'All' || _statusFilter != 'All' || _feeFilter != 'All';

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Student Directory',
          subtitle: 'Manage and view all enrolled students',
          action: FilledButton.icon(
            onPressed: () => context.push('/students/add'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Student'),
          ),
        ),
        const SizedBox(height: 16),
        FilterBar(
          searchPlaceholder: 'Search students by name, email, or phone...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
          onFiltersPressed: _openFilters,
        ),
        if (hasFilters || _query.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_query.isNotEmpty)
                Chip(
                  label: Text('Search: $_query'),
                  onDeleted: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                ),
              if (_courseFilter != 'All')
                Chip(
                  label: Text('Course: $_courseFilter'),
                  onDeleted: () => setState(() => _courseFilter = 'All'),
                ),
              if (_statusFilter != 'All')
                Chip(
                  label: Text('Status: $_statusFilter'),
                  onDeleted: () => setState(() => _statusFilter = 'All'),
                ),
              if (_feeFilter != 'All')
                Chip(
                  label: Text('Fee: $_feeFilter'),
                  onDeleted: () => setState(() => _feeFilter = 'All'),
                ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (results.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.person_search_outlined, size: 48, color: Theme.of(context).disabledColor),
                    const SizedBox(height: 12),
                    const Text('No students match your filters', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting search or filters',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SimpleDataTable(
            columns: const ['Student Name', 'Contact', 'Course', 'Batch', 'Status', 'Fee Status', 'Enrolled On', ''],
            rows: [
              for (final s in results)
                [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFFE0E7FF),
                        child: Text(
                          _initials(s.$1),
                          style: const TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(s.$2, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone_outlined, size: 16, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 6),
                      Text(s.$3, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                  Text(s.$4),
                  Text(s.$5),
                  StatusBadge(status: s.$6),
                  Text(
                    s.$7,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: s.$7 == 'Paid'
                          ? const Color(0xFF16A34A)
                          : (s.$7 == 'Pending' ? const Color(0xFFCA8A04) : const Color(0xFFDC2626)),
                    ),
                  ),
                  Text(s.$8),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18, color: Color(0xFF9CA3AF)),
                    onSelected: (action) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$action — ${s.$1}')),
                      );
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'View profile', child: Text('View profile')),
                      PopupMenuItem(value: 'Edit', child: Text('Edit')),
                      PopupMenuItem(value: 'Message', child: Text('Message')),
                    ],
                  ),
                ],
            ],
          ),
      ],
    );
  }

  static String _initials(String name) {
    final parts = name.split(' ');
    final a = parts.isNotEmpty ? parts[0][0] : '';
    final b = parts.length > 1 ? parts[1][0] : '';
    return (a + b).toUpperCase();
  }
}
