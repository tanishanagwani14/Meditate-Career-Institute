import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/enterprise_theme.dart';
import '../widgets/app_data_table.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/dashboard_badges.dart';
import '../widgets/pill_badge.dart';
import '../widgets/section_header.dart';
import 'user_add_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int _tab = 0;

  final _searchCtrl = TextEditingController();
  String _query = '';

  late List<(String, bool, bool, bool, bool)> _permDraft = List.of(_permRows);
  late List<(String, bool, bool, bool, bool)> _permSaved = List.of(_permRows);

  late final List<({String name, String email, String institute, String role, String status, String lastActive})> _users = [
    (
      name: 'John Anderson',
      email: 'john.a@brightfuture.edu',
      institute: 'Bright Future Academy',
      role: 'Admin',
      status: 'Active',
      lastActive: '2024-05-02',
    ),
    (
      name: 'Sarah Chen',
      email: 'sarah.c@techlearning.com',
      institute: 'Tech Learning Hub',
      role: 'Teacher',
      status: 'Active',
      lastActive: '2024-05-02',
    ),
    (
      name: 'Michael Brown',
      email: 'm.brown@global.edu',
      institute: 'Global Institute',
      role: 'Student',
      status: 'Active',
      lastActive: '2024-05-01',
    ),
    (
      name: 'Emily Davis',
      email: 'emily@smart.academy',
      institute: 'Smart Academy',
      role: 'Admin',
      status: 'Active',
      lastActive: '2024-05-02',
    ),
    (
      name: 'David Wilson',
      email: 'd.wilson@elite.edu',
      institute: 'Elite Education Center',
      role: 'Teacher',
      status: 'Active',
      lastActive: '2024-04-30',
    ),
    (
      name: 'Lisa Martinez',
      email: 'lisa.m@innovation.school',
      institute: 'Innovation School',
      role: 'Student',
      status: 'Suspended',
      lastActive: '2024-04-15',
    ),
  ];

  static const _roles = <({String name, int users, String permissions, Color bg, Color fg})>[
    (
      name: 'Super Admin',
      users: 5,
      permissions: 'Full platform access',
      bg: Color(0xFFFEE2E2),
      fg: Color(0xFFB91C1C),
    ),
    (
      name: 'Institute Admin',
      users: 225,
      permissions: 'Tenant-level management',
      bg: Color(0xFFE9D5FF),
      fg: Color(0xFF7E22CE),
    ),
    (
      name: 'Teacher',
      users: 3420,
      permissions: 'Course and student management',
      bg: Color(0xFFDBEAFE),
      fg: Color(0xFF1D4ED8),
    ),
    (
      name: 'Student',
      users: 41550,
      permissions: 'Learning access only',
      bg: Color(0xFFD1FAE5),
      fg: Color(0xFF047857),
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredUsers();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'User Management',
            subtitle: 'Manage global users, roles, and permissions',
            actions: [
              OutlinedButton.icon(
                onPressed: () => _exportCsv(context, filtered),
                icon: const Icon(Icons.download_outlined, size: 20),
                label: const Text('Export'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final result = await context.push<AddUserResult>('/users/add');
                  if (!mounted || result == null) return;
                  setState(() {
                    _tab = 0;
                    _users.insert(
                      0,
                      (
                        name: result.name,
                        email: result.email,
                        institute: result.institute,
                        role: result.role,
                        status: 'Active',
                        lastActive: _today(),
                      ),
                    );
                    _query = '';
                    _searchCtrl.clear();
                  });
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text('Added user ${result.name}')),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1_outlined, size: 20),
                label: const Text('Add User'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _UserTabs(index: _tab, onChanged: (i) => setState(() => _tab = i)),
          const SizedBox(height: 24),
          if (_tab == 0) ...[
            AppSearchBar(
              hint: 'Search users by name, email, or institute...',
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 16),
            AppDataTable(
              columns: const ['Name', 'Email', 'Institute', 'Role', 'Status', 'Last Active'],
              showActions: true,
              actionBuilder: (rowIndex) {
                final u = filtered[rowIndex];
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Viewing ${u.name} (coming soon)')),
                        );
                      },
                      child: const Text('View'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Reset password link sent to ${u.email}')),
                        );
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final idx = _users.indexOf(u);
                          if (idx >= 0) {
                            final nextStatus = u.status == 'Active' ? 'Suspended' : 'Active';
                            _users[idx] = (
                              name: u.name,
                              email: u.email,
                              institute: u.institute,
                              role: u.role,
                              status: nextStatus,
                              lastActive: u.lastActive,
                            );
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${u.status == 'Active' ? 'Suspended' : 'Activated'} ${u.name}')),
                        );
                      },
                      child: Text(u.status == 'Active' ? 'Suspend' : 'Activate'),
                    ),
                  ],
                );
              },
              rows: [
                for (final u in filtered)
                  [
                    u.name,
                    u.email,
                    u.institute,
                    DashboardBadges.userRole(u.role),
                    DashboardBadges.userStatus(u.status),
                    u.lastActive,
                  ],
              ],
            ),
          ],
          if (_tab == 1)
            LayoutBuilder(
              builder: (context, c) {
                final cols = c.maxWidth >= 800 ? 2 : 1;
                return GridView.count(
                  crossAxisCount: cols,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.35,
                  children: [
                    for (final r in _roles)
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: EnterpriseTheme.gray200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: EnterpriseTheme.gray900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        r.permissions,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: EnterpriseTheme.gray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PillBadge(
                                  label: '${r.users.toString()} users',
                                  background: r.bg,
                                  foreground: r.fg,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Edit permissions for ${r.name} (coming soon)')),
                                      );
                                    },
                                    child: const Text('Edit Permissions'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Role security options for ${r.name} (coming soon)')),
                                    );
                                  },
                                  child: const Icon(Icons.shield_outlined, size: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
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
                    'Permission Matrix',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: EnterpriseTheme.gray900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Toggle permissions per role, then Save Changes.',
                    style: TextStyle(fontSize: 13, color: EnterpriseTheme.gray600),
                  ),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(EnterpriseTheme.gray50),
                      border: TableBorder(
                        top: BorderSide(color: EnterpriseTheme.gray200.withValues(alpha: 0.5)),
                        bottom: BorderSide(color: EnterpriseTheme.gray200.withValues(alpha: 0.5)),
                        horizontalInside: BorderSide(color: EnterpriseTheme.gray200.withValues(alpha: 0.3)),
                      ),
                      columns: const [
                        DataColumn(label: Text('PERMISSION')),
                        DataColumn(label: Text('SUPER ADMIN'), numeric: true),
                        DataColumn(label: Text('INSTITUTE ADMIN'), numeric: true),
                        DataColumn(label: Text('TEACHER'), numeric: true),
                        DataColumn(label: Text('STUDENT'), numeric: true),
                      ],
                      rows: [
                        for (var i = 0; i < _permDraft.length; i++)
                          DataRow(
                            cells: [
                              DataCell(Text(_permDraft[i].$1)),
                              DataCell(
                                Center(
                                  child: Checkbox(
                                    value: _permDraft[i].$2,
                                    onChanged: (v) => setState(() {
                                      _permDraft[i] = (_permDraft[i].$1, v ?? false, _permDraft[i].$3, _permDraft[i].$4, _permDraft[i].$5);
                                    }),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Checkbox(
                                    value: _permDraft[i].$3,
                                    onChanged: (v) => setState(() {
                                      _permDraft[i] = (_permDraft[i].$1, _permDraft[i].$2, v ?? false, _permDraft[i].$4, _permDraft[i].$5);
                                    }),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Checkbox(
                                    value: _permDraft[i].$4,
                                    onChanged: (v) => setState(() {
                                      _permDraft[i] = (_permDraft[i].$1, _permDraft[i].$2, _permDraft[i].$3, v ?? false, _permDraft[i].$5);
                                    }),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Checkbox(
                                    value: _permDraft[i].$5,
                                    onChanged: (v) => setState(() {
                                      _permDraft[i] = (_permDraft[i].$1, _permDraft[i].$2, _permDraft[i].$3, _permDraft[i].$4, v ?? false);
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() => _permDraft = List.of(_permSaved));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cancelled changes')),
                          );
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _permSaved = List.of(_permDraft));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved permission changes')),
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

  static const _permRows = <(String, bool, bool, bool, bool)>[
    ('Manage Institutes', true, false, false, false),
    ('Manage Users', true, true, false, false),
    ('Create Courses', true, true, true, false),
    ('View Analytics', true, true, true, false),
    ('Access Content', true, true, true, true),
  ];

  List<({String name, String email, String institute, String role, String status, String lastActive})> _filteredUsers() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return List.of(_users);
    return _users.where((u) {
      return u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q) ||
          u.institute.toLowerCase().contains(q) ||
          u.role.toLowerCase().contains(q) ||
          u.status.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _exportCsv(
    BuildContext context,
    List<({String name, String email, String institute, String role, String status, String lastActive})> rows,
  ) async {
    String esc(String v) {
      final needs = v.contains(',') || v.contains('"') || v.contains('\n');
      final s = v.replaceAll('"', '""');
      return needs ? '"$s"' : s;
    }

    final header = 'Name,Email,Institute,Role,Status,Last Active';
    final lines = <String>[
      header,
      for (final r in rows)
        [
          esc(r.name),
          esc(r.email),
          esc(r.institute),
          esc(r.role),
          esc(r.status),
          esc(r.lastActive),
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
            child: SingleChildScrollView(child: SelectableText(csv)),
          ),
          actions: [
            OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
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
}

class _UserTabs extends StatelessWidget {
  const _UserTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget t(String label, int i, {String? count}) {
      final sel = index == i;
      return InkWell(
        onTap: () => onChanged(i),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
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
                  if (count != null)
                    Text(
                      ' ($count)',
                      style: const TextStyle(fontSize: 12, color: EnterpriseTheme.gray500),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 2,
                width: 100,
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
            t('All Users', 0, count: '45,200'),
            t('Roles', 1, count: '4'),
            t('Permissions', 2),
          ],
        ),
      ),
    );
  }
}
