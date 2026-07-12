import 'package:flutter/material.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class CouponManagementPage extends StatefulWidget {
  const CouponManagementPage({super.key});

  @override
  State<CouponManagementPage> createState() => _CouponManagementPageState();
}

class _CouponManagementPageState extends State<CouponManagementPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _coupons = [
    (
      1,
      'SUMMER2026',
      '20%',
      'Percentage',
      '₹25,000',
      '₹10,000',
      45,
      100,
      '2026-06-30',
      'active'
    ),
    (2, 'FIRSTBATCH', '₹5,000', 'Fixed', '₹30,000', '₹5,000', 28, 50, '2026-05-31', 'active'),
    (3, 'REFER10', '10%', 'Percentage', '₹20,000', '₹5,000', 67, 200, '2026-12-31', 'active'),
    (4, 'EARLY2026', '15%', 'Percentage', '₹35,000', '₹8,000', 100, 100, '2026-02-28', 'inactive'),
    (5, 'NEWUSER', '₹3,000', 'Fixed', '₹15,000', '₹3,000', 142, null, '2026-12-31', 'active'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<(int, String, String, String, String, String, int, int?, String, String)> _filtered() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_coupons);
    return _coupons.where((c) {
      return c.$2.toLowerCase().contains(q) || c.$10.toLowerCase().contains(q);
    }).toList();
  }

  void _openFilters() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filters coming soon on this page')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filtered();
    final totalUsage = _coupons.fold<int>(0, (acc, c) => acc + c.$7);
    final activeCount = _coupons.where((c) => c.$10 == 'active').length;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Coupon Management',
          subtitle: 'Create and manage discount coupons for courses',
          action: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create coupon coming soon')),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Create Coupon'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 950 ? 3 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: cols == 1 ? 2.8 : 2.4,
              children: [
                _StatCard(
                  label: 'Active Coupons',
                  value: '$activeCount',
                  valueColor: const Color(0xFF111827),
                  icon: Icons.local_offer_outlined,
                  iconColor: const Color(0xFF9CA3AF),
                ),
                _StatCard(
                  label: 'Total Usage',
                  value: '$totalUsage',
                  valueColor: const Color(0xFF4F46E5),
                  icon: Icons.people_outline,
                  iconColor: const Color(0xFF818CF8),
                ),
                const _StatCard(
                  label: 'Total Discount Given',
                  value: '₹4.2L',
                  valueColor: Color(0xFF16A34A),
                  icon: Icons.trending_up,
                  iconColor: Color(0xFF4ADE80),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        FilterBar(
          searchPlaceholder: 'Search coupons by code...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
          onFiltersPressed: _openFilters,
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Coupon Code', 'Discount', 'Min Amount', 'Max Discount', 'Usage', 'Valid Until', 'Status', 'Actions'],
          rows: [
            for (final c in rows)
              [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.local_offer_outlined, size: 18, color: Color(0xFF9333EA)),
                    ),
                    const SizedBox(width: 10),
                    Text(c.$2, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.$3, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF16A34A))),
                    Text(c.$4, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
                Text(c.$5),
                Text(c.$6),
                _UsageCell(usage: c.$7, limit: c.$8),
                Text(c.$9),
                StatusBadge(status: c.$10),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Editing coupon ${c.$2} (demo)')),
                    );
                  },
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                  child: const Text('Edit'),
                ),
              ],
          ],
        ),
      ],
    );
  }
}

class _UsageCell extends StatelessWidget {
  const _UsageCell({required this.usage, required this.limit});
  final int usage;
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final txt = limit == null ? '$usage' : '$usage/$limit';
    final pct = (limit == null || limit == 0) ? null : (usage / limit!).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(txt, style: const TextStyle(fontWeight: FontWeight.w600)),
        if (pct != null) ...[
          const SizedBox(height: 6),
          SizedBox(
            width: 84,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E7EB),
                color: const Color(0xFF4F46E5),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Color(0xFF4B5563))),
                  const SizedBox(height: 6),
                  Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: valueColor)),
                ],
              ),
            ),
            Icon(icon, size: 32, color: iconColor),
          ],
        ),
      ),
    );
  }
}

