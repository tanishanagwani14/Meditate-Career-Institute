import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions,
  });

  final String title;
  final String subtitle;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final narrow = c.maxWidth < 640;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: narrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: EnterpriseTheme.gray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: EnterpriseTheme.gray600,
                      ),
                    ),
                    if (actions != null && actions!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(spacing: 12, runSpacing: 8, children: actions!),
                    ],
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: EnterpriseTheme.gray900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: EnterpriseTheme.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (actions != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < actions!.length; i++) ...[
                            if (i > 0) const SizedBox(width: 12),
                            actions![i],
                          ],
                        ],
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class TabUnderlineBar extends StatelessWidget {
  const TabUnderlineBar({
    super.key,
    required this.tabs,
    required this.activeIndex,
    required this.onChanged,
  });

  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: EnterpriseTheme.gray200),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            InkWell(
              onTap: () => onChanged(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[i],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: i == activeIndex
                            ? EnterpriseTheme.indigo600
                            : EnterpriseTheme.gray600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 2,
                      width: 48 + tabs[i].length * 4.0,
                      constraints: const BoxConstraints(minWidth: 64),
                      decoration: BoxDecoration(
                        color: i == activeIndex ? EnterpriseTheme.indigo600 : Colors.transparent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
