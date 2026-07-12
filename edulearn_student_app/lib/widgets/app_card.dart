import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.onTap, this.color, this.border});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: border ?? BorderSide(color: theme.dividerColor.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
      ),
    );
    return card;
  }
}
