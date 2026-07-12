import 'package:flutter/material.dart';

import '../../widgets/shared/filter_bar.dart';
import '../../widgets/shared/kpi_card.dart';
import '../../widgets/shared/page_header.dart';
import '../../widgets/shared/simple_data_table.dart';
import '../../widgets/shared/status_badge.dart';

class FranchiseManagementPage extends StatelessWidget {
  const FranchiseManagementPage({super.key});

  static const _franchises = [
    (
      1,
      'EduAdmin - Mumbai Central',
      'Mumbai, Maharashtra',
      'Rajesh Patel',
      450,
      '₹18.5L',
      '2024-03-15',
      'active'
    ),
    (2, 'EduAdmin - Pune West', 'Pune, Maharashtra', 'Priya Sharma', 320, '₹14.2L', '2024-06-20', 'active'),
    (3, 'EduAdmin - Delhi NCR', 'Gurgaon, Haryana', 'Amit Kumar', 580, '₹24.8L', '2023-11-10', 'active'),
    (4, 'EduAdmin - Bangalore South', 'Bangalore, Karnataka', 'Kavita Iyer', 410, '₹17.5L', '2024-01-05', 'active'),
    (5, 'EduAdmin - Hyderabad', 'Hyderabad, Telangana', 'Vikram Reddy', 280, '₹12.0L', '2025-02-12', 'pending'),
  ];

  @override
  Widget build(BuildContext context) {
    final totalStudents = _franchises.fold<int>(0, (acc, f) => acc + f.$5);
    final activeCount = _franchises.where((f) => f.$8 == 'active').length;
    double totalRevenueL = 0;
    for (final f in _franchises) {
      totalRevenueL += double.parse(f.$6.replaceAll('₹', '').replaceAll('L', '').replaceAll(',', ''));
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Franchise Management',
          subtitle: 'Manage and monitor franchise locations across regions',
          action: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Franchise'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 1100 ? 4 : c.maxWidth >= 700 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: cols == 1 ? 2.2 : 1.7,
              children: [
                KpiCard(
                  title: 'Total Franchises',
                  value: '${_franchises.length}',
                  change: '$activeCount active',
                  changeType: ChangeType.positive,
                  icon: Icons.apartment_outlined,
                  iconBg: const Color(0xFFDBEAFE),
                  iconColor: const Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Total Students',
                  value: _fmtInt(totalStudents),
                  change: 'Across all locations',
                  changeType: ChangeType.neutral,
                  icon: Icons.people_outline,
                  iconBg: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF9333EA),
                ),
                KpiCard(
                  title: 'Combined Revenue',
                  value: '₹${totalRevenueL.toStringAsFixed(1)}L',
                  change: 'Monthly total',
                  changeType: ChangeType.positive,
                  icon: Icons.currency_rupee,
                  iconBg: const Color(0xFFDCFCE7),
                  iconColor: const Color(0xFF16A34A),
                ),
                const KpiCard(
                  title: 'Avg Performance',
                  value: '92%',
                  change: '+5% from last month',
                  changeType: ChangeType.positive,
                  icon: Icons.trending_up,
                  iconBg: Color(0xFFFFEDD5),
                  iconColor: Color(0xFFEA580C),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const FilterBar(searchPlaceholder: 'Search franchises by name or location...'),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const [
            'Franchise Name',
            'Franchise Owner',
            'Total Students',
            'Monthly Revenue',
            'Established On',
            'Status',
            'Actions'
          ],
          rows: [
            for (final f in _franchises)
              [
                _FranchiseNameCell(name: f.$2, location: f.$3),
                _OwnerCell(name: f.$4),
                Row(
                  children: [
                    const Icon(Icons.people_outline, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    Text('${f.$5}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                Text(f.$6, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
                Text(f.$7),
                StatusBadge(status: f.$8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                  child: const Text('View Details'),
                ),
              ],
          ],
        ),
      ],
    );
  }
}

String _fmtInt(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final fromEnd = s.length - i;
    buf.write(s[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
  }
  return buf.toString();
}

class _FranchiseNameCell extends StatelessWidget {
  const _FranchiseNameCell({required this.name, required this.location});
  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.apartment_outlined, color: Color(0xFF4F46E5)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF6B7280)),
                  const SizedBox(width: 4),
                  Expanded(child: Text(location, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OwnerCell extends StatelessWidget {
  const _OwnerCell({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .where((p) => p.trim().isNotEmpty)
        .map((p) => p.trim()[0])
        .take(2)
        .join()
        .toUpperCase();
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(999)),
          child: Text(initials, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF6B21A8))),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(name)),
      ],
    );
  }
}

