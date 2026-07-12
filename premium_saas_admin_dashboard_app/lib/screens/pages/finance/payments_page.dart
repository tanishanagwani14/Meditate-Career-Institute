import 'package:flutter/material.dart';

import '../../../widgets/shared/filter_bar.dart';
import '../../../widgets/shared/kpi_card.dart';
import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static const _txns = [
    ('TXN001', 'Aarav Sharma', 'JEE Advanced', '₹45,000', 'UPI', '2026-05-01', '10:24 AM', 'completed'),
    ('TXN002', 'Diya Patel', 'NEET', '₹40,000', 'Credit Card', '2026-05-01', '11:15 AM', 'completed'),
    ('TXN003', 'Ananya Singh', 'JEE Mains', '₹35,000', 'Net Banking', '2026-05-01', '12:30 PM', 'pending'),
    ('TXN004', 'Reyansh Joshi', 'JEE Advanced', '₹45,000', 'UPI', '2026-04-30', '03:45 PM', 'completed'),
    ('TXN006', 'Vihaan Kumar', 'NEET', '₹40,000', 'UPI', '2026-04-29', '09:15 AM', 'rejected'),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<(String, String, String, String, String, String, String, String)> _filtered() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_txns);
    return _txns.where((t) {
      return t.$1.toLowerCase().contains(q) ||
          t.$2.toLowerCase().contains(q) ||
          t.$3.toLowerCase().contains(q) ||
          t.$5.toLowerCase().contains(q) ||
          t.$8.toLowerCase().contains(q);
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
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Payment Transactions',
          subtitle: 'Monitor and manage all payment transactions',
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
              children: const [
                KpiCard(
                  title: "Today's Collection",
                  value: '₹200K',
                  change: '+15% from yesterday',
                  changeType: ChangeType.positive,
                  icon: Icons.currency_rupee,
                  iconBg: Color(0xFFDCFCE7),
                  iconColor: Color(0xFF16A34A),
                ),
                KpiCard(
                  title: 'Transactions Today',
                  value: '3',
                  change: 'Processed successfully',
                  changeType: ChangeType.neutral,
                  icon: Icons.trending_up,
                  iconBg: Color(0xFFDBEAFE),
                  iconColor: Color(0xFF2563EB),
                ),
                KpiCard(
                  title: 'Success Rate',
                  value: '94%',
                  change: 'Excellent rate',
                  changeType: ChangeType.positive,
                  icon: Icons.check_circle_outline,
                  iconBg: Color(0xFFDCFCE7),
                  iconColor: Color(0xFF16A34A),
                ),
                KpiCard(
                  title: 'Pending Amount',
                  value: '₹35K',
                  change: '1 pending transaction',
                  changeType: ChangeType.neutral,
                  icon: Icons.credit_card,
                  iconBg: Color(0xFFFFFBEB),
                  iconColor: Color(0xFFCA8A04),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        FilterBar(
          searchPlaceholder: 'Search by transaction ID, student name...',
          searchController: _searchCtrl,
          onSearchChanged: (v) => setState(() => _query = v),
          onFiltersPressed: _openFilters,
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Transaction ID', 'Student Name', 'Amount', 'Payment Method', 'Date & Time', 'Status', 'Actions'],
          rows: [
            for (final t in rows)
              [
                Text(t.$1),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.$2, style: const TextStyle(fontWeight: FontWeight.w600)), Text(t.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)))]),
                Text(t.$4, style: const TextStyle(fontWeight: FontWeight.w700)),
                Row(children: [const Icon(Icons.credit_card, size: 16, color: Color(0xFF9CA3AF)), const SizedBox(width: 6), Text(t.$5)]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t.$6), Text(t.$7, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)))]),
                StatusBadge(status: t.$8),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Viewing receipt for ${t.$1} (demo)')),
                    );
                  },
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

