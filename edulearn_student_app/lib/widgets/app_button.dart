import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, destructive, success }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.fullWidth = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final height = switch (size) {
      AppButtonSize.sm => 36.0,
      AppButtonSize.md => 44.0,
      AppButtonSize.lg => 56.0,
    };
    final pad = switch (size) {
      AppButtonSize.sm => const EdgeInsets.symmetric(horizontal: 12),
      AppButtonSize.md => const EdgeInsets.symmetric(horizontal: 20),
      AppButtonSize.lg => const EdgeInsets.symmetric(horizontal: 24),
    };

    Widget wrap(Widget w) =>
        fullWidth ? SizedBox(width: double.infinity, child: w) : w;

    switch (variant) {
      case AppButtonVariant.primary:
        return wrap(
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(minimumSize: Size(0, height), padding: pad),
            child: DefaultTextStyle.merge(style: TextStyle(fontSize: size == AppButtonSize.lg ? 18 : 14), child: child),
          ),
        );
      case AppButtonVariant.secondary:
        return wrap(
          FilledButton.tonal(
            onPressed: onPressed,
            style: FilledButton.styleFrom(minimumSize: Size(0, height), padding: pad),
            child: child,
          ),
        );
      case AppButtonVariant.outline:
        return wrap(
          OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(minimumSize: Size(0, height), padding: pad),
            child: child,
          ),
        );
      case AppButtonVariant.ghost:
        return wrap(
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(minimumSize: Size(0, height), padding: pad),
            child: child,
          ),
        );
      case AppButtonVariant.destructive:
        return wrap(
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
              minimumSize: Size(0, height),
              padding: pad,
            ),
            child: child,
          ),
        );
      case AppButtonVariant.success:
        return wrap(
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              minimumSize: Size(0, height),
              padding: pad,
            ),
            child: child,
          ),
        );
    }
  }
}

enum AppButtonSize { sm, md, lg }
