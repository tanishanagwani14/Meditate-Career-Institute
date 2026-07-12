import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
    this.border,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final BorderSide? border;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: border ?? BorderSide(color: Theme.of(context).dividerColor),
    );

    return Card(
      color: color,
      shape: shape,
      child: InkWell(
        onTap: onTap,
        borderRadius: (shape.borderRadius as BorderRadius?) ?? BorderRadius.circular(14),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

