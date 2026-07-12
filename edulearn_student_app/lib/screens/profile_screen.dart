import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme_controller.dart';
import '../widgets/app_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Rahul Kumar';
  String _email = 'rahul.kumar@email.com';
  String _grade = 'Class 12 - Science';

  Future<void> _openEditProfile() async {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final gradeCtrl = TextEditingController(text: _grade);

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: gradeCtrl,
                  decoration: const InputDecoration(labelText: 'Class / Grade'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        );
      },
    );

    if (saved == true && mounted) {
      setState(() {
        _name = nameCtrl.text.trim().isEmpty ? _name : nameCtrl.text.trim();
        _email = emailCtrl.text.trim().isEmpty ? _email : emailCtrl.text.trim();
        _grade = gradeCtrl.text.trim().isEmpty ? _grade : gradeCtrl.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }

    nameCtrl.dispose();
    emailCtrl.dispose();
    gradeCtrl.dispose();
  }

  void _openAccountSettings() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const _AccountSettingsScreen()),
    );
  }

  void _openHelpSupport() {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => const _HelpSupportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF9333EA)]),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _openEditProfile,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Text('👨‍🎓', style: TextStyle(fontSize: 36)),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Material(
                                color: Colors.white,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: _openEditProfile,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(Icons.edit, size: 14, color: primary),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: _openEditProfile,
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              Text(_email, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                              Text(_grade, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                      ListenableBuilder(
                        listenable: appThemeController,
                        builder: (_, __) {
                          return IconButton.filledTonal(
                            style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.15)),
                            onPressed: () => appThemeController.toggle(),
                            icon: Icon(
                              appThemeController.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    // Taller tiles: content (padding + icon + texts) needs more than 1.4 width/height on narrow screens.
                    childAspectRatio: 1.12,
                    children: const [
                      _StatTile(icon: Icons.track_changes, label: 'Courses Enrolled', value: '8', grad: [Color(0xFF3B82F6), Color(0xFF4F46E5)]),
                      _StatTile(icon: Icons.schedule, label: 'Hours Learned', value: '156', grad: [Color(0xFF22C55E), Color(0xFF059669)]),
                      _StatTile(icon: Icons.emoji_events_outlined, label: 'Tests Completed', value: '24', grad: [Color(0xFFF97316), Color(0xFFDC2626)]),
                      _StatTile(icon: Icons.workspace_premium_outlined, label: 'Certificates', value: '3', grad: [Color(0xFFA855F7), Color(0xFFDB2777)]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text('Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: muted)),
                const SizedBox(height: 8),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _menuTile(context, Icons.settings_outlined, 'Account Settings', null, onTap: _openAccountSettings),
                      const Divider(height: 1),
                      _menuTile(context, Icons.notifications_outlined, 'Notifications', '3', onTap: () => context.push('/notifications')),
                      const Divider(height: 1),
                      _menuTile(context, Icons.workspace_premium_outlined, 'Achievements & Badges', null, onTap: () => context.push('/achievements')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('Support', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: muted)),
                const SizedBox(height: 8),
                AppCard(
                  padding: EdgeInsets.zero,
                  child: _menuTile(context, Icons.help_outline, 'Help & Support', null, onTap: _openHelpSupport),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => context.go('/login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(color: Theme.of(context).colorScheme.error, width: 2),
                    minimumSize: const Size(0, 52),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out'),
                ),
                const SizedBox(height: 24),
                Text('EduLearn v1.0.0', textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 13)),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: TextStyle(color: muted, fontSize: 13),
                    children: [
                      WidgetSpan(child: Text('Terms of Service', style: TextStyle(color: primary))),
                      const TextSpan(text: '  •  '),
                      WidgetSpan(child: Text('Privacy Policy', style: TextStyle(color: primary))),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String label, String? badge, {VoidCallback? onTap}) {
    final primary = Theme.of(context).colorScheme.primary;
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: primary),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null)
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          Icon(Icons.chevron_right, color: muted),
        ],
      ),
    );
  }
}

class _AccountSettingsScreen extends StatefulWidget {
  const _AccountSettingsScreen();

  @override
  State<_AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<_AccountSettingsScreen> {
  bool _emailNotifs = true;
  bool _pushNotifs = true;
  bool _liveClassReminders = true;
  bool _autoplay = false;
  bool _downloadOnWifiOnly = true;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _sectionLabel('Profile', muted),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Change name & email'),
            subtitle: const Text('Update your display name and contact email'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tap the edit icon on your profile photo to update details')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password reset link sent to your email')),
            ),
          ),
          const Divider(),
          _sectionLabel('Notifications', muted),
          SwitchListTile(
            secondary: const Icon(Icons.mail_outline),
            title: const Text('Email notifications'),
            value: _emailNotifs,
            onChanged: (v) => setState(() => _emailNotifs = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text('Push notifications'),
            value: _pushNotifs,
            onChanged: (v) => setState(() => _pushNotifs = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.alarm),
            title: const Text('Live class reminders'),
            subtitle: const Text('Get notified 10 minutes before a live class starts'),
            value: _liveClassReminders,
            onChanged: (v) => setState(() => _liveClassReminders = v),
          ),
          const Divider(),
          _sectionLabel('Playback & Downloads', muted),
          SwitchListTile(
            secondary: const Icon(Icons.play_circle_outline),
            title: const Text('Autoplay next video'),
            value: _autoplay,
            onChanged: (v) => setState(() => _autoplay = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wifi),
            title: const Text('Download on Wi-Fi only'),
            value: _downloadOnWifiOnly,
            onChanged: (v) => setState(() => _downloadOnWifiOnly = v),
          ),
          const Divider(),
          _sectionLabel('Privacy', muted),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete account', style: TextStyle(color: Colors.red)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete account?'),
                  content: const Text(
                    'This will permanently remove your data, progress, and certificates. This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Account deletion request submitted')),
                        );
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label, Color? muted) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: muted, letterSpacing: 0.5),
      ),
    );
  }
}

class _HelpSupportScreen extends StatelessWidget {
  const _HelpSupportScreen();

  static const _faqs = <(String, String)>[
    (
      'How do I enroll in a course?',
      'Go to the Courses tab, pick a course you like, and tap "Enroll Now". '
          'Paid courses will prompt you to complete payment; free courses are added to your library immediately.',
    ),
    (
      'How do I join a live class?',
      'Open the Live tab to see all upcoming classes. Tap "Join Now" on any class to enter the live room. '
          'You can also tap "Remind" to get a push notification 10 minutes before it starts.',
    ),
    (
      'Can I download videos for offline viewing?',
      'Yes. Inside any course, open the Curriculum tab and tap the download icon next to a chapter. '
          'Downloaded chapters work without internet and show a green tick.',
    ),
    (
      'How are doubts answered?',
      'Post your doubt from the Doubts tab. Teachers and peers from our community can answer. '
          'You will receive a notification when someone responds.',
    ),
    (
      'How do I reset my password?',
      'On the login screen tap "Forgot Password" and enter your email. We will send a reset link.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.support_agent, color: primary, size: 28),
                    const SizedBox(width: 12),
                    const Text('Contact Support', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Our team usually replies within 24 hours.',
                  style: TextStyle(color: muted, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening email to support@edulearn.com')),
                        ),
                        icon: const Icon(Icons.email_outlined, size: 18),
                        label: const Text('Email'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Starting live chat...')),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline, size: 18),
                        label: const Text('Live Chat'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'FREQUENTLY ASKED QUESTIONS',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: muted, letterSpacing: 0.5),
          ),
          const SizedBox(height: 8),
          for (final faq in _faqs)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                title: Text(faq.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(faq.$2, style: TextStyle(color: muted, height: 1.4)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'EduLearn v1.0.0',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.label, required this.value, required this.grad});

  final IconData icon;
  final String label;
  final String value;
  final List<Color> grad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: LinearGradient(colors: grad)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.15),
              ),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10, height: 1.2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
