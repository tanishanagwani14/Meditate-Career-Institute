import 'package:flutter/material.dart';

class SimpleDataTable extends StatelessWidget {
  const SimpleDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
  });

  final List<String> columns;
  final List<List<Widget>> rows;
  final void Function(int index)? onRowTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [for (final c in columns) DataColumn(label: Text(c, style: const TextStyle(fontWeight: FontWeight.w700)))],
          rows: [
            for (var i = 0; i < rows.length; i++)
              DataRow(
                onSelectChanged: onRowTap != null ? (_) => onRowTap!(i) : null,
                cells: [for (final cell in rows[i]) DataCell(cell)],
              ),
          ],
        ),
      ),
    );
  }
}

