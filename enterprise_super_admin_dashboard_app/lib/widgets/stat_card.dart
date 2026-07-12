import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';

enum StatChangeType { positive, negative, neutral }

class EnterpriseStatCard extends StatelessWidget {
  const EnterpriseStatCard({
    super.key,
    required this.label,
    required this.value,
    this.change,
    this.changeType = StatChangeType.neutral,
    required this.icon,
    this.iconBackground = const Color(0xFFEEF2FF),
    this.iconColor = EnterpriseTheme.indigo600,
  });

  final String label;
  final String value;
  final String? change;
  final StatChangeType changeType;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  Color _changeColor() {
    switch (changeType) {
      case StatChangeType.positive:
        return const Color(0xFF16A34A);
      case StatChangeType.negative:
        return const Color(0xFFDC2626);
      case StatChangeType.neutral:
        return EnterpriseTheme.gray500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EnterpriseTheme.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: EnterpriseTheme.gray600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: EnterpriseTheme.gray900,
            ),
          ),
          if (change != null) ...[
            const SizedBox(height: 8),
            Text(
              change!,
              style: TextStyle(
                fontSize: 14,
                color: _changeColor(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
