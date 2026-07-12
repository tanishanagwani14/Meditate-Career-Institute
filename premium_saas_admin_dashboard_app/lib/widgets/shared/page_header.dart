import 'package:flutter/material.dart';

import '../shell_navigation.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.includeShellActions = false,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  /// When true, shows notification + settings buttons beside [action].
  final bool includeShellActions;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!, style: TextStyle(color: muted)),
              ],
            ],
          ),
        ),
        if (includeShellActions || action != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (includeShellActions) const ShellHeaderActions(),
              if (includeShellActions && action != null) const SizedBox(width: 8),
              if (action != null) action!,
            ],
          ),
      ],
    );
  }
}

