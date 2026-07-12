import 'package:flutter/material.dart';

import '../../../widgets/shared/page_header.dart';

class LeadPipelinePage extends StatefulWidget {
  const LeadPipelinePage({super.key});

  @override
  State<LeadPipelinePage> createState() => _LeadPipelinePageState();
}

class _LeadPipelinePageState extends State<LeadPipelinePage> {
  static const _stages = ['New Leads', 'Contacted', 'Demo Scheduled', 'Proposal Sent', 'Enrolled'];

  static const _leads = [
    (1, 'Rahul Verma', '+91 98765 12345', 'rahul.v@email.com', 'JEE Advanced', 'Website', 'New Leads', '2026-05-01'),
    (2, 'Priya Desai', '+91 98765 12346', 'priya.d@email.com', 'NEET', 'Referral', 'Contacted', '2026-04-30'),
    (3, 'Ankit Sharma', '+91 98765 12347', 'ankit.s@email.com', 'Foundation', 'Facebook', 'Demo Scheduled', '2026-04-29'),
    (4, 'Sneha Patel', '+91 98765 12348', 'sneha.p@email.com', 'JEE Mains', 'Google Ads', 'Proposal Sent', '2026-04-28'),
    (5, 'Vikram Singh', '+91 98765 12349', 'vikram.s@email.com', 'NEET', 'Walk-in', 'Enrolled', '2026-04-27'),
    (6, 'Meera Reddy', '+91 98765 12350', 'meera.r@email.com', 'Skill Dev', 'Website', 'New Leads', '2026-05-01'),
    (7, 'Aditya Kumar', '+91 98765 12351', 'aditya.k@email.com', 'JEE Advanced', 'Instagram', 'Contacted', '2026-04-30'),
    (8, 'Kavya Joshi', '+91 98765 12352', 'kavya.j@email.com', 'Foundation', 'Referral', 'Demo Scheduled', '2026-04-29'),
  ];

  String? selectedStage;

  List<(int, String, String, String, String, String, String, String)> _byStage(String stage) {
    return _leads.where((l) => l.$7 == stage).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        PageHeader(
          title: 'Lead Pipeline',
          subtitle: 'Manage and track prospective student inquiries',
          action: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add lead coming soon')),
              );
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Lead'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final cols = c.maxWidth >= 1100 ? 5 : c.maxWidth >= 850 ? 3 : c.maxWidth >= 550 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: cols == 1 ? 3.2 : 2.6,
              children: [
                for (final s in _stages)
                  InkWell(
                    onTap: () => setState(() => selectedStage = selectedStage == s ? null : s),
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(s, style: const TextStyle(fontWeight: FontWeight.w700))),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_byStage(s).length}',
                                    style: const TextStyle(color: Color(0xFF4F46E5), fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text('Pipeline stage', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, c) {
            final show = selectedStage == null ? _stages : [selectedStage!];
            final cols = c.maxWidth >= 1100 ? (selectedStage == null ? 5 : 1) : c.maxWidth >= 850 ? 3 : c.maxWidth >= 550 ? 2 : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: cols == 1 ? 0.9 : 0.62,
              children: [
                for (final s in show)
                  _StageColumn(
                    title: s,
                    leads: _byStage(s),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StageColumn extends StatelessWidget {
  const _StageColumn({required this.title, required this.leads});

  final String title;
  final List<(int, String, String, String, String, String, String, String)> leads;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title (${leads.length})', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: leads.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _LeadCard(lead: leads[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  const _LeadCard({required this.lead});
  final (int, String, String, String, String, String, String, String) lead;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening lead ${lead.$2} (demo)')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lead.$2, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _MiniRow(icon: Icons.phone_outlined, text: lead.$3),
              const SizedBox(height: 6),
              _MiniRow(icon: Icons.mail_outline, text: lead.$4),
              const SizedBox(height: 6),
              _MiniRow(icon: Icons.calendar_today_outlined, text: lead.$8),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                    child: Text(lead.$5, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF4F46E5))),
                  ),
                  const Spacer(),
                  Text(lead.$6, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniRow extends StatelessWidget {
  const _MiniRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF4B5563)),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563)))),
      ],
    );
  }
}

