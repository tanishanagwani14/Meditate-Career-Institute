import 'package:flutter/material.dart';

class PillBadge extends StatelessWidget {
  const PillBadge({
    super.key,
    required this.label,
    this.background = const Color(0xFFE5E7EB),
    this.foreground = const Color(0xFF374151),
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: foreground,
        ),
      ),
    );
  }
}
