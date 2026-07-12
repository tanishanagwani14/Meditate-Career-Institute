import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/dashboard_data.dart';
import '../../../widgets/shared/page_header.dart';

class KpiAttendancePage extends StatelessWidget {
  const KpiAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Avg Attendance',
          subtitle: '92% institute-wide average',
          action: OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        for (final a in DashboardData.attendanceRecords)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_today_outlined, color: Color(0xFFEA580C)),
              ),
              title: Text(a.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${a.$4} · ${a.$5}', style: TextStyle(color: muted, fontSize: 12)),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(a.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(
                    a.$3,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: _attendanceColor(a.$3),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  static Color _attendanceColor(String pct) {
    final n = int.tryParse(pct.replaceAll('%', '')) ?? 0;
    if (n >= 90) return const Color(0xFF16A34A);
    if (n >= 80) return const Color(0xFFCA8A04);
    return const Color(0xFFDC2626);
  }
}
