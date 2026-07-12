import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/section_header.dart';
import 'onboard_institute_screen.dart';

class InstituteManagementScreen extends StatefulWidget {
  const InstituteManagementScreen({super.key});

  @override
  State<InstituteManagementScreen> createState() => _InstituteManagementScreenState();
}

class _InstituteManagementScreenState extends State<InstituteManagementScreen> {
  int _tab = 0;

  final _searchCtrl = TextEditingController();
  String _query = '';

  final _domainCtrl = TextEditingController();
  String _savedDomain = '';
  static const String _savedBrandColor = '#6366f1';

  late final List<({String name, String plan, String users, String mrr, String status, String onboarded, String region})> _institutes = [
    (
      name: 'Bright Future Academy',
      plan: 'Enterprise',
      users: '1,250',
      mrr: '\$2,450',
      status: 'Active',
      onboarded: '2024-01-15',
      region: 'US-East',
    ),
    (
      name: 'Tech Learning Hub',
      plan: 'Professional',
      users: '890',
      mrr: '\$1,680',
      status: 'Active',
      onboarded: '2024-02-20',
      region: 'EU-West',
    ),
    (
      name: 'Global Institute',
      plan: 'Enterprise',
      users: '2,100',
      mrr: '\$3,850',
      status: 'Active',
      onboarded: '2023-11-05',
      region: 'US-West',
    ),
    (
      name: 'Smart Academy',
      plan: 'Basic',
      users: '320',
      mrr: '\$480',
      status: 'Active',
      onboarded: '2024-03-10',
      region: 'APAC',
    ),
    (
      name: 'Elite Education Center',
      plan: 'Professional',
      users: '1,450',
      mrr: '\$2,180',
      status: 'Active',
      onboarded: '2023-09-22',
      region: 'US-East',
    ),
    (
      name: 'Innovation School',
      plan: 'Enterprise',
      users: '1,800',
      mrr: '\$3,200',
      status: 'Trial',
      onboarded: '2024-04-01',
      region: 'EU-Central',
    ),
    (
      name: 'Future Leaders Institute',
      plan: 'Professional',
      users: '670',
      mrr: '\$1,250',
      status: 'Active',
      onboarded: '2024-01-28',
      region: 'APAC',
    ),
    (
      name: 'Premier Academy',
      plan: 'Basic',
      users: '280',
      mrr: '\$420',
      status: 'Suspended',
      onboarded: '2023-12-12',
      region: 'US-Central',
    ),
  ];

  final List<({String name, String submitted, String contact, String plan, String region})> _pending = [
    (
      name: 'NextGen Learning',
      submitted: '2024-05-01',
      contact: 'john@nextgen.edu',
      plan: 'Enterprise',
      region: 'US-East',
    ),
    (
      name: 'Modern Education Co',
      submitted: '2024-04-29',
      contact: 'sarah@modernedu.com',
      plan: 'Professional',
      region: 'EU-West',
    ),
    (
      name: 'Digital Academy',
      submitted: '2024-04-28',
      contact: 'mike@digital.edu',
      plan: 'Professional',
      region: 'APAC',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _domainCtrl.text = _savedDomain;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _domainCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredInstitutes = _filteredInstitutes();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'Institute Management',
            subtitle: 'Manage all tenant organizations',
            actions: [
              OutlinedButton.icon(
                onPressed: () => _exportCsv(context, filteredInstitutes),
                icon: const Icon(Icons.download_outlined, size: 20),
                label: const Text('Export'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await context.push<OnboardInstituteResult>('/institutes/onboard');
                  if (!mounted || result == null) return;
                  setState(() {
                    _tab = 1;
                    _pending.insert(
                      0,
                      (
                        name: result.name,
                        submitted: _today(),
                        contact: result.contact,
                        plan: result.plan,
                        region: result.region,
                      ),
                    );
                  });
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text('Submitted onboarding for ${result.name}')),
                  );
                },
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Onboard Institute'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _InstituteTabs(
            index: _tab,
            pendingCount: _pending.length,
            onChanged: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 24),
          if (_tab == 0) ...[
            AppSearchBar(
              hint: 'Search institutes...',
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 16),
            AppDataTable(
              columns: const [
                'Institute Name',
                'Plan',
                'Users',
                'MRR',
                'Status',
                'Region',
                'Onboarded',
              ],
              rows: [
                for (final r in filteredInstitutes)
                  [
                    r.name,
                    DashboardBadges.plan(r.plan),
                    r.users,
                    r.mrr,
                    DashboardBadges.instituteStatus(r.status),
                    r.region,
                    r.onboarded,
                  ],
              ],
            ),
          ],
          if (_tab == 1)
            Column(
              children: [
                for (final p in _pending)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: EnterpriseTheme.gray200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: EnterpriseTheme.gray900,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    LayoutBuilder(
                                      builder: (context, c) {
                                        final narrow = c.maxWidth < 520;
                                        final children = <Widget>[
                                          _kv('Contact', p.contact),
                                          _kv('Requested Plan', DashboardBadges.plan(p.plan)),
                                          _kv('Submitted', p.submitted),
                                        ];
                                        if (narrow) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              for (final w in children) ...[w, const SizedBox(height: 12)],
                                            ],
                                          );
                                        }
                                        return Row(
                                          children: [
                                            Expanded(child: children[0]),
                                            Expanded(child: children[1]),
                                            Expanded(child: children[2]),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() => _pending.remove(p));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Rejected ${p.name}')),
                                      );
                                    },
                                    child: const Text('Reject'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _pending.remove(p);
                                        _institutes.insert(
                                          0,
                                          (
                                            name: p.name,
                                            plan: p.plan,
                                            users: '—',
                                            mrr: '—',
                                            status: 'Trial',
                                            onboarded: _today(),
                                            region: p.region,
                                          ),
                                        );
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Approved ${p.name}')),
                                      );
                                    },
                                    child: const Text('Approve'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          if (_tab == 2)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: EnterpriseTheme.gray200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'White-label Configuration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: EnterpriseTheme.gray900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, c) {
                      final narrow = c.maxWidth < 560;
                      final domain = _labeledField(
                        label: 'Custom Domain',
                        child: TextField(
                          controller: _domainCtrl,
                          decoration: InputDecoration(
                            hintText: 'institute.yourdomain.com',
                          ),
                        ),
                      );
                      final colorField = _labeledField(
                        label: 'Brand Color',
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: EnterpriseTheme.indigo600,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: EnterpriseTheme.gray200),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: _savedBrandColor,
                                readOnly: true,
                                decoration: const InputDecoration(),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (narrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            domain,
                            const SizedBox(height: 16),
                            colorField,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: domain),
                          const SizedBox(width: 24),
                          Expanded(child: colorField),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _labeledField(
                    label: 'Custom Logo',
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logo upload coming soon')),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(
                          border: Border.all(color: EnterpriseTheme.gray200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          children: [
                            Text(
                              'Drag and drop logo or click to upload',
                              style: TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'PNG, SVG up to 2MB',
                              style: TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _domainCtrl.text = _savedDomain;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cancelled changes')),
                          );
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _savedDomain = _domainCtrl.text.trim();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved changes')),
                          );
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<({String name, String plan, String users, String mrr, String status, String onboarded, String region})> _filteredInstitutes() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_institutes);
    return _institutes.where((r) {
      return r.name.toLowerCase().contains(q) ||
          r.plan.toLowerCase().contains(q) ||
          r.status.toLowerCase().contains(q) ||
          r.region.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _exportCsv(
    BuildContext context,
    List<({String name, String plan, String users, String mrr, String status, String onboarded, String region})> rows,
  ) async {
    String esc(String v) {
      final needs = v.contains(',') || v.contains('"') || v.contains('\n');
      final s = v.replaceAll('"', '""');
      return needs ? '"$s"' : s;
    }

    final header = 'Institute Name,Plan,Users,MRR,Status,Region,Onboarded';
    final lines = <String>[
      header,
      for (final r in rows)
        [
          esc(r.name),
          esc(r.plan),
          esc(r.users),
          esc(r.mrr),
          esc(r.status),
          esc(r.region),
          esc(r.onboarded),
        ].join(','),
    ];
    final csv = lines.join('\n');

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Export CSV'),
          content: SizedBox(
            width: 560,
            child: SingleChildScrollView(
              child: SelectableText(csv),
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: csv));
                if (ctx.mounted) Navigator.pop(ctx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied export to clipboard')),
                  );
                }
              },
              child: const Text('Copy'),
            ),
          ],
        );
      },
    );
  }

  static String _today() {
    final d = DateTime.now();
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }

  static Widget _kv(String k, Object v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          k,
          style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray600),
        ),
        const SizedBox(height: 4),
        if (v is Widget)
          v
        else
          Text(
            v.toString(),
            style: const TextStyle(fontSize: 14, color: EnterpriseTheme.gray900),
          ),
      ],
    );
  }

  static Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: EnterpriseTheme.gray700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _InstituteTabs extends StatelessWidget {
  const _InstituteTabs({
    required this.index,
    required this.pendingCount,
    required this.onChanged,
  });

  final int index;
  final int pendingCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget tab(String label, int i, {Widget? suffix}) {
      final sel = index == i;
      return InkWell(
        onTap: () => onChanged(i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: sel ? EnterpriseTheme.indigo600 : EnterpriseTheme.gray600,
                    ),
                  ),
                  if (suffix != null) ...[const SizedBox(width: 8), suffix],
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                width: 120,
                decoration: BoxDecoration(
                  color: sel ? EnterpriseTheme.indigo600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: EnterpriseTheme.gray200)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            tab('All Institutes', 0),
            tab(
              'Pending Onboarding',
              1,
              suffix: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF9C3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$pendingCount',
                  style: const TextStyle(fontSize: 12, color: Color(0xFFA16207)),
                ),
              ),
            ),
            tab('White-label Settings', 2),
          ],
        ),
      ),
    );
  }
}
