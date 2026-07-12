import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarNav extends StatefulWidget {
  const SidebarNav({super.key, required this.onNavigate});
  final void Function(String path) onNavigate;

  @override
  State<SidebarNav> createState() => _SidebarNavState();
}

class _SidebarNavState extends State<SidebarNav> {
  final Set<String> _expanded = {
    'Students',
    'Teachers',
    'Academic',
    'CRM',
    'Finance',
    'Communication',
  };

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.toString();
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.school_outlined, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('EduAdmin Pro', style: TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _link(path, 'Dashboard', Icons.dashboard_outlined, '/', primary),
              const SizedBox(height: 6),
              _section(
                context,
                path: path,
                title: 'Students',
                icon: Icons.people_outline,
                children: const [
                  ('Directory', '/students'),
                  ('Attendance', '/students/attendance'),
                  ('Fees', '/students/fees'),
                  ('Reports', '/students/reports'),
                ],
                primary: primary,
              ),
              _section(
                context,
                path: path,
                title: 'Teachers',
                icon: Icons.school_outlined,
                children: const [
                  ('Faculty', '/teachers'),
                  ('Permissions', '/teachers/permissions'),
                  ('Performance', '/teachers/performance'),
                ],
                primary: primary,
              ),
              _section(
                context,
                path: path,
                title: 'Academic',
                icon: Icons.menu_book_outlined,
                children: const [
                  ('Courses', '/academic/courses'),
                  ('Batches', '/academic/batches'),
                  ('Assignments', '/academic/assignments'),
                  ('Content', '/academic/content'),
                ],
                primary: primary,
              ),
              _section(
                context,
                path: path,
                title: 'CRM',
                icon: Icons.manage_accounts_outlined,
                children: const [
                  ('Lead Pipeline', '/crm/leads'),
                  ('Follow-up', '/crm/followup'),
                  ('Counselor', '/crm/counselor'),
                ],
                primary: primary,
              ),
              _section(
                context,
                path: path,
                title: 'Finance',
                icon: Icons.currency_rupee,
                children: const [
                  ('Payments', '/finance/payments'),
                  ('Fee Reports', '/finance/reports'),
                  ('Refunds', '/finance/refunds'),
                  ('Coupons', '/finance/coupons'),
                ],
                primary: primary,
              ),
              _section(
                context,
                path: path,
                title: 'Communication',
                icon: Icons.chat_bubble_outline,
                children: const [
                  ('Notifications', '/communication/notifications'),
                  ('Broadcast', '/communication/broadcast'),
                ],
                primary: primary,
              ),
              const SizedBox(height: 6),
              _link(path, 'Support', Icons.headset_mic_outlined, '/support/tickets', primary),
              const SizedBox(height: 6),
              _link(path, 'Franchise', Icons.apartment_outlined, '/franchise', primary),
              const SizedBox(height: 6),
              _link(path, 'Multi-Center', Icons.hub_outlined, '/multi-center', primary),
              const SizedBox(height: 6),
              _link(path, 'Affiliate', Icons.trending_up, '/affiliate', primary),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).dividerColor))),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: primary.withValues(alpha: 0.12), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('AD', style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Admin User', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    Text('admin@edu.com', style: TextStyle(color: muted, fontSize: 11)),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.logout, color: muted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(
    BuildContext context, {
    required String path,
    required String title,
    required IconData icon,
    required List<(String, String)> children,
    required Color primary,
  }) {
    final expanded = _expanded.contains(title);
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: Icon(icon, size: 20, color: Colors.grey[500]),
          title: Text(title, style: const TextStyle(fontSize: 13)),
          trailing: AnimatedRotation(
            turns: expanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 150),
            child: const Icon(Icons.expand_more, size: 18),
          ),
          onTap: () => setState(() {
            if (expanded) {
              _expanded.remove(title);
            } else {
              _expanded.add(title);
            }
          }),
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.only(left: 44, bottom: 6),
            child: Column(
              children: [
                for (final c in children)
                  _subLink(path, c.$1, c.$2, primary),
              ],
            ),
          ),
      ],
    );
  }

  Widget _link(String current, String label, IconData icon, String to, Color primary) {
    final active = _isActive(current, to);
    return ListTile(
      dense: true,
      leading: Icon(icon, size: 20, color: active ? primary : Colors.grey[500]),
      title: Text(label, style: TextStyle(fontSize: 13, color: active ? primary : null, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      tileColor: active ? primary.withValues(alpha: 0.08) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () => widget.onNavigate(to),
    );
  }

  Widget _subLink(String current, String label, String to, Color primary) {
    final active = _isActive(current, to);
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(label, style: TextStyle(fontSize: 13, color: active ? primary : Colors.grey[600], fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      tileColor: active ? primary.withValues(alpha: 0.08) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () => widget.onNavigate(to),
    );
  }

  bool _isActive(String path, String href) {
    if (href == '/') return path == '/';
    return path.startsWith(href);
  }
}

