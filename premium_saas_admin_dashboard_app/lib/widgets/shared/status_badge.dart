import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final s = status.toLowerCase();
    final (Color fg, Color bg) = switch (s) {
      'active' || 'completed' => (const Color(0xFF16A34A), const Color(0xFFEFFDF4)),
      'inactive' || 'rejected' => (const Color(0xFFDC2626), const Color(0xFFFEF2F2)),
      'pending' => (const Color(0xFFCA8A04), const Color(0xFFFFFBEB)),
      _ => (const Color(0xFF4B5563), const Color(0xFFF9FAFB)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status, style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

