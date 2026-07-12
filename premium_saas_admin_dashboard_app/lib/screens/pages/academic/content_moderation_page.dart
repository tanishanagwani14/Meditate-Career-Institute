import 'package:flutter/material.dart';

import '../../../widgets/shared/page_header.dart';
import '../../../widgets/shared/simple_data_table.dart';
import '../../../widgets/shared/status_badge.dart';

class ContentModerationPage extends StatefulWidget {
  const ContentModerationPage({super.key});

  @override
  State<ContentModerationPage> createState() => _ContentModerationPageState();
}

class _ContentModerationPageState extends State<ContentModerationPage> {
  static const _items = [
    (
      1,
      'Physics Lecture - Newton\'s Laws',
      'video',
      'Dr. Rajesh Singh',
      '2026-04-28',
      '245 MB',
      'approved'
    ),
    (2, 'Chemistry Notes - Organic Compounds', 'document', 'Prof. Meera Iyer', '2026-04-29', '12 MB', 'approved'),
    (3, 'Mathematics Practice Sheet', 'document', 'Mrs. Priya Sharma', '2026-04-30', '8 MB', 'pending'),
    (4, 'Biology Diagram - Cell Structure', 'image', 'Dr. Amit Kumar', '2026-04-30', '2 MB', 'pending'),
    (5, 'JEE Mock Test PDF', 'document', 'Dr. Rajesh Singh', '2026-05-01', '15 MB', 'pending'),
    (6, 'NEET Question Bank', 'document', 'Dr. Amit Kumar', '2026-04-25', '20 MB', 'rejected'),
  ];

  late final List<(int, String, String, String, String, String, String)> _rows = [
    for (final i in _items) (i.$1, i.$2, i.$3, i.$4, i.$5, i.$6, i.$7),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeader(
          title: 'Content Moderation',
          subtitle: 'Review and approve educational content uploaded by teachers',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 1100 ? 4 : c.maxWidth >= 700 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: cols == 1 ? 2.8 : 2.4,
              children: const [
                _StatCard(
                  label: 'Total Content',
                  value: '1,248',
                  valueColor: Color(0xFF111827),
                  icon: Icons.description_outlined,
                  iconColor: Color(0xFF9CA3AF),
                ),
                _StatCard(
                  label: 'Pending Review',
                  value: '12',
                  valueColor: Color(0xFFCA8A04),
                  icon: Icons.remove_red_eye_outlined,
                  iconColor: Color(0xFFFBBF24),
                ),
                _StatCard(
                  label: 'Approved',
                  value: '1,210',
                  valueColor: Color(0xFF16A34A),
                  icon: Icons.check_circle_outline,
                  iconColor: Color(0xFF4ADE80),
                ),
                _StatCard(
                  label: 'Rejected',
                  value: '26',
                  valueColor: Color(0xFFDC2626),
                  icon: Icons.cancel_outlined,
                  iconColor: Color(0xFFF87171),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        SimpleDataTable(
          columns: const ['Content Title', 'Uploaded By', 'Upload Date', 'File Size', 'Status', 'Actions'],
          rows: [
            for (final i in _rows)
              [
                _ContentTitleCell(title: i.$2, type: i.$3),
                Text(i.$4),
                Text(i.$5),
                Text(i.$6),
                StatusBadge(status: i.$7),
                _ActionsCell(
                  status: i.$7,
                  onApprove: () => _setStatus(i.$1, 'approved'),
                  onReject: () => _setStatus(i.$1, 'rejected'),
                  onPreview: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Preview: ${i.$2}')),
                    );
                  },
                ),
              ],
          ],
        ),
      ],
    );
  }

  void _setStatus(int id, String status) {
    setState(() {
      final idx = _rows.indexWhere((r) => r.$1 == id);
      if (idx >= 0) {
        final r = _rows[idx];
        _rows[idx] = (r.$1, r.$2, r.$3, r.$4, r.$5, r.$6, status);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marked as $status')),
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

class _ContentTitleCell extends StatelessWidget {
  const _ContentTitleCell({required this.title, required this.type});
  final String title;
  final String type;

  static (IconData, Color, Color) _typeStyle(String type) {
    switch (type) {
      case 'video':
        return (Icons.videocam_outlined, const Color(0xFF9333EA), const Color(0xFFF3E8FF));
      case 'document':
        return (Icons.description_outlined, const Color(0xFF2563EB), const Color(0xFFDBEAFE));
      case 'image':
        return (Icons.image_outlined, const Color(0xFF16A34A), const Color(0xFFDCFCE7));
      default:
        return (Icons.insert_drive_file_outlined, const Color(0xFF4B5563), const Color(0xFFF3F4F6));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _typeStyle(type);
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: s.$3, borderRadius: BorderRadius.circular(12)),
          child: Icon(s.$1, color: s.$2),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(type, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionsCell extends StatelessWidget {
  const _ActionsCell({
    required this.status,
    required this.onPreview,
    required this.onApprove,
    required this.onReject,
  });
  final String status;
  final VoidCallback onPreview;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final isPending = status.toLowerCase() == 'pending';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPreview,
          tooltip: 'Preview',
          icon: const Icon(Icons.remove_red_eye_outlined, size: 18, color: Color(0xFF4B5563)),
        ),
        if (isPending) ...[
          IconButton(
            onPressed: onApprove,
            tooltip: 'Approve',
            icon: const Icon(Icons.check_circle, size: 18, color: Color(0xFF16A34A)),
          ),
          IconButton(
            onPressed: onReject,
            tooltip: 'Reject',
            icon: const Icon(Icons.cancel, size: 18, color: Color(0xFFDC2626)),
          ),
        ],
      ],
    );
  }
}

