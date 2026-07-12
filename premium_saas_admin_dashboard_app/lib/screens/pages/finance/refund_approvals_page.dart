import 'package:flutter/material.dart';

import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class RefundApprovalsPage extends StatefulWidget {
  const RefundApprovalsPage({super.key});

  @override
  State<RefundApprovalsPage> createState() => _RefundApprovalsPageState();
}

class _RefundApprovalsPageState extends State<RefundApprovalsPage> {
  static const _requestsSeed = [
    ('REF001', 'Vihaan Kumar', 'NEET', '₹40,000', 'Relocation to different city', '2026-04-28', 'pending'),
    ('REF002', 'Kavya Mehta', 'Foundation', '₹12,000', 'Medical emergency', '2026-04-25', 'pending'),
    ('REF003', 'Rohan Joshi', 'JEE Mains', '₹35,000', 'Dissatisfied with course', '2026-04-20', 'approved'),
    ('REF004', 'Ishita Sharma', 'Skill Dev', '₹8,000', 'Duplicate payment', '2026-04-18', 'approved'),
    ('REF005', 'Aditya Verma', 'JEE Advanced', '₹45,000', 'Changed career path', '2026-04-15', 'rejected'),
  ];

  late final List<(String, String, String, String, String, String, String)> _requests = [
    for (final r in _requestsSeed) (r.$1, r.$2, r.$3, r.$4, r.$5, r.$6, r.$7),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingCount = _requests.where((r) => r.$7 == 'pending').length;
    final approvedCount = _requests.where((r) => r.$7 == 'approved').length;
    final rejectedCount = _requests.where((r) => r.$7 == 'rejected').length;

    int pendingAmount = 0;
    for (final r in _requests.where((r) => r.$7 == 'pending')) {
      pendingAmount += int.parse(r.$4.replaceAll('₹', '').replaceAll(',', ''));
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Refund Approvals',
          subtitle: 'Review and process student refund requests',
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
              childAspectRatio: cols == 1 ? 2.8 : 2.4,
              children: [
                _StatCard(
                  label: 'Pending Approval',
                  value: '$pendingCount',
                  valueColor: const Color(0xFFCA8A04),
                  icon: Icons.schedule,
                  iconColor: const Color(0xFFFBBF24),
                ),
                _StatCard(
                  label: 'Approved',
                  value: '$approvedCount',
                  valueColor: const Color(0xFF16A34A),
                  icon: Icons.check_circle_outline,
                  iconColor: const Color(0xFF4ADE80),
                ),
                _StatCard(
                  label: 'Rejected',
                  value: '$rejectedCount',
                  valueColor: const Color(0xFFDC2626),
                  icon: Icons.cancel_outlined,
                  iconColor: const Color(0xFFF87171),
                ),
                _StatCard(
                  label: 'Pending Amount',
                  value: '₹${(pendingAmount / 1000).round()}K',
                  valueColor: const Color(0xFF111827),
                  icon: Icons.schedule,
                  iconColor: const Color(0xFF9CA3AF),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Request ID', 'Student Details', 'Refund Amount', 'Reason', 'Request Date', 'Status', 'Actions'],
          rows: [
            for (final r in _requests)
              [
                Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(r.$3, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                  ],
                ),
                Text(r.$4, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(r.$5, style: const TextStyle(color: Color(0xFF4B5563))),
                Text(r.$6),
                StatusBadge(status: r.$7),
                r.$7 == 'pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FilledButton.icon(
                            onPressed: () => _setStatus(r.$1, 'approved'),
                            icon: const Icon(Icons.check_circle, size: 18),
                            label: const Text('Approve'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              minimumSize: const Size(0, 36),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                          const SizedBox(width: 10),
                          FilledButton.icon(
                            onPressed: () => _setStatus(r.$1, 'rejected'),
                            icon: const Icon(Icons.cancel, size: 18),
                            label: const Text('Reject'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFDC2626),
                              minimumSize: const Size(0, 36),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ],
                      )
                    : OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Viewing ${r.$1} details (demo)')),
                          );
                        },
                        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                        child: const Text('View Details'),
                      ),
              ],
          ],
        ),
      ],
    );
  }

  void _setStatus(String id, String status) {
    setState(() {
      final idx = _requests.indexWhere((r) => r.$1 == id);
      if (idx >= 0) {
        final r = _requests[idx];
        _requests[idx] = (r.$1, r.$2, r.$3, r.$4, r.$5, r.$6, status);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked $id as $status')),
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

