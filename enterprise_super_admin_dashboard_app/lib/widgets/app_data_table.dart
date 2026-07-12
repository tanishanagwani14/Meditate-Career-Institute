import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/enterprise_theme.dart';

/// Table with string or widget cells per column.
class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.showActions = false,
    this.actionBuilder,
  });

  final List<String> columns;
  final List<List<Object>> rows;
  final bool showActions;
  final Widget Function(int rowIndex)? actionBuilder;

  static Widget _cell(Object cell) {
    if (cell is Widget) return cell;
    return Text(
      cell.toString(),
      style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray900),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headers = showActions ? [...columns, 'Actions'] : columns;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EnterpriseTheme.gray200),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Horizontal scroll gives the table unbounded max width; FlexColumnWidth then
          // blows up layout. Use the parent's finite width (or a sensible minimum).
          final parentW = constraints.maxWidth;
          final tableWidth = parentW.isFinite && parentW > 0
              ? math.max(640.0, parentW)
              : math.max(640.0, MediaQuery.sizeOf(context).width);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Table(
            columnWidths: {
              for (var i = 0; i < headers.length; i++)
                i: const FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: EnterpriseTheme.gray50,
                  border: Border(
                    bottom: BorderSide(color: EnterpriseTheme.gray200),
                  ),
                ),
                children: headers
                    .map(
                      (h) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: Text(
                          h.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: EnterpriseTheme.gray500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              for (var r = 0; r < rows.length; r++)
                TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: EnterpriseTheme.gray200.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  children: [
                    ...rows[r].map(
                      (cell) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        child: _cell(cell),
                      ),
                    ),
                    if (showActions)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: actionBuilder?.call(r) ?? const SizedBox.shrink(),
                        ),
                      ),
                  ],
                ),
            ],
              ),
            ),
          );
        },
      ),
    );
  }
}
