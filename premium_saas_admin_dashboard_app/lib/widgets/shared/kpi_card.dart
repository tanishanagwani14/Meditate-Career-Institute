import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.changeType = ChangeType.neutral,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.onTap,
  });

  final String title;
  final String value;
  final String? change;
  final ChangeType changeType;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final chip = switch (changeType) {
      ChangeType.positive => (const Color(0xFF16A34A), const Color(0xFFEFFDF4)),
      ChangeType.negative => (const Color(0xFFDC2626), const Color(0xFFFEF2F2)),
      ChangeType.neutral => (const Color(0xFF4B5563), const Color(0xFFF9FAFB)),
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: muted, fontSize: 12, height: 1.15),
                  ),
                  const SizedBox(height: 6),
                  // Keep the big number inside the card on small widths.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.05),
                    ),
                  ),
                  if (change != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: chip.$2, borderRadius: BorderRadius.circular(999)),
                        child: Text(
                          change!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: chip.$1, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

enum ChangeType { positive, negative, neutral }

