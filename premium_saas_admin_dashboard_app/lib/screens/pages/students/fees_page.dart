import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/fees_data.dart';
import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/kpi_card.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({super.key});

  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _status = 'All';
  String _course = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<FeeRecord> _filtered() {
    return FeesData.records.where((r) {
      if (_status != 'All' && r.status != _status) return false;
      if (_course != 'All' && r.course != _course) return false;
      if (_query.trim().isEmpty) return true;
      final q = _query.trim().toLowerCase();
      return r.studentName.toLowerCase().contains(q) ||
          r.course.toLowerCase().contains(q) ||
          r.batch.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _openFilters() async {
    var status = _status;
    var course = _course;

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
                  const Text('Filter fees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: [
                      for (final s in FeesData.statuses) DropdownMenuItem(value: s, child: Text(s)),
                    ],
                    onChanged: (v) => setModalState(() => status = v ?? status),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: course,
                    decoration: const InputDecoration(labelText: 'Course'),
                    items: [
                      for (final c in FeesData.courses) DropdownMenuItem(value: c, child: Text(c)),
                    ],
                    onChanged: (v) => setModalState(() => course = v ?? course),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _status = 'All';
                              _course = 'All';
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
        _status = status;
        _course = course;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filtered();
    final hasFilters = _status != 'All' || _course != 'All' || _query.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Fee Management',
          subtitle: 'Track and manage student fee payments',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, c) {
            // Always 2×2 (2 up, 2 down) as requested.
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              // Make cards taller on small widths to prevent overflow.
              childAspectRatio: c.maxWidth < 420 ? 0.95 : (c.maxWidth < 650 ? 1.15 : 1.8),
              children: [
                KpiCard(
                  title: 'Total Collected',
                  value: FeesData.formatInr(FeesData.totalCollectedInr),
                  change: 'This month',
                  changeType: ChangeType.positive,
                  icon: Icons.currency_rupee,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                  onTap: () => context.push('/students/fees/collected'),
                ),
                KpiCard(
                  title: 'Pending Collection',
                  value: FeesData.formatInr(FeesData.pendingInr),
                  change: '${FeesData.records.where((r) => r.status == 'pending').length} pending',
                  changeType: ChangeType.neutral,
                  icon: Icons.trending_up,
                  iconBg: const Color(0xFFFFFBEB),
                  iconColor: const Color(0xFFCA8A04),
                  onTap: () => context.push('/students/fees/pending'),
                ),
                KpiCard(
                  title: 'Overdue Payments',
                  value: FeesData.formatInr(FeesData.overdueInr),
                  change: '${FeesData.records.where((r) => r.status == 'overdue').length} overdue',
                  changeType: ChangeType.negative,
                  icon: Icons.error_outline,
                  iconBg: const Color(0xFFFEE2E2),
                  iconColor: const Color(0xFFDC2626),
                  onTap: () => context.push('/students/fees/overdue'),
                ),
                KpiCard(
                  title: 'Collection Rate',
                  value: '${FeesData.collectionRate.toStringAsFixed(0)}%',
                  change: 'This month',
                  changeType: ChangeType.positive,
                  icon: Icons.check_circle_outline,
                  iconBg: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF2563EB),
                  onTap: () => context.push('/students/fees/rate'),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        FilterBar(
          searchPlaceholder: 'Search by student, course, or batch...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
          onFiltersPressed: _openFilters,
        ),
        if (hasFilters) ...[
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
              if (_status != 'All')
                Chip(
                  label: Text('Status: $_status'),
                  onDeleted: () => setState(() => _status = 'All'),
                ),
              if (_course != 'All')
                Chip(
                  label: Text('Course: $_course'),
                  onDeleted: () => setState(() => _course = 'All'),
                ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        SimpleDataTable(
          columns: const ['Student', 'Fee Amount', 'Due Date', 'Paid On', 'Status', 'Action'],
          onRowTap: (index) {
            final record = rows[index];
            final originalIndex = FeesData.records.indexOf(record);
            context.push('/students/fees/student/$originalIndex');
          },
          rows: [
            for (final r in rows)
              [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.studentName, style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text('${r.course} · ${r.batch}', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
                Text(FeesData.formatInr(r.feeAmountInr), style: const TextStyle(fontWeight: FontWeight.w800)),
                Text(r.dueDate),
                Text(r.paidOn ?? '-', style: const TextStyle(fontSize: 13)),
                StatusBadge(status: r.status == 'paid' ? 'completed' : (r.status == 'pending' ? 'pending' : 'overdue')),
                r.status != 'paid'
                    ? FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 14)),
                        child: const Text('Collect Fee'),
                      )
                    : OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                        child: const Text('View Receipt'),
                      ),
              ],
          ],
        ),
      ],
    );
  }
}

