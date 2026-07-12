import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class LiveClassScreen extends StatefulWidget {
  const LiveClassScreen({super.key});

  @override
  State<LiveClassScreen> createState() => _LiveClassScreenState();
}

class _LiveClassScreenState extends State<LiveClassScreen> {
  bool _isLive = false;
  bool _muted = false;
  bool _videoOn = true;

  @override
  Widget build(BuildContext context) {
    if (!_isLive) {
      return Scaffold(
        appBar: AppBar(title: const Text('Live Classes', style: TextStyle(fontWeight: FontWeight.w600))),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.85,
              children: const [
                _SmallStat(value: '12', label: 'Scheduled', valueColor: AppColors.primary),
                _SmallStat(value: '145', label: 'Completed', valueColor: AppColors.success),
              ],
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Schedule New Class', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'Class Title', hintText: 'e.g., Physics Doubt Session')),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: 'Select Batch'),
                    items: const [
                      DropdownMenuItem(value: 'jee2024', child: Text('JEE 2024 Batch')),
                      DropdownMenuItem(value: 'neet2024', child: Text('NEET 2024 Batch')),
                      DropdownMenuItem(value: 'class12', child: Text('Class 12 CBSE')),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Date'), keyboardType: TextInputType.datetime)),
                      SizedBox(width: 12),
                      Expanded(child: TextField(decoration: InputDecoration(labelText: 'Time'), keyboardType: TextInputType.datetime)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const TextField(decoration: InputDecoration(labelText: 'Duration (minutes)', hintText: '60'), keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => setState(() => _isLive = true),
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Start Class Now'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Upcoming Classes', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            for (final cls in const [
              ('Physics - Mechanics', 'Today, 10:00 AM', 45, 'JEE 2024'),
              ('Chemistry Doubt Session', 'Today, 2:00 PM', 38, 'NEET 2024'),
              ('Mathematics - Calculus', 'Tomorrow, 10:00 AM', 52, 'JEE 2024'),
            ]) ...[
              AppCard(
                padding: const EdgeInsets.all(12),
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cls.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined, size: 14),
                                  const SizedBox(width: 4),
                                  Text(cls.$2, style: const TextStyle(fontSize: 12)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.people_outline, size: 14),
                                  const SizedBox(width: 4),
                                  Text('${cls.$3}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                          child: Text(cls.$4, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => setState(() => _isLive = true),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: const Text('Start'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.settings_outlined, size: 18),
                            label: const Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      );
    }

    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.destructive, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      const Text('LIVE', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      Text('45:23', style: TextStyle(color: muted)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: Theme.of(context).dividerColor)),
                    child: Row(
                      children: [
                        const Icon(Icons.people_outline, size: 16),
                        const SizedBox(width: 6),
                        Text('42 watching', style: TextStyle(color: muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(color: primary.withValues(alpha: 0.2), shape: BoxShape.circle),
                          child: Icon(Icons.videocam_outlined, size: 64, color: primary),
                        ),
                        const SizedBox(height: 12),
                        const Text('Physics - Mechanics', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(
                          "You're presenting to your students",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 18,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _round(
                          icon: _muted ? Icons.mic_off : Icons.mic,
                          bg: _muted ? AppColors.destructive : Colors.white24,
                          onTap: () => setState(() => _muted = !_muted),
                        ),
                        const SizedBox(width: 10),
                        _round(
                          icon: _videoOn ? Icons.videocam : Icons.videocam_off,
                          bg: !_videoOn ? AppColors.destructive : Colors.white24,
                          onTap: () => setState(() => _videoOn = !_videoOn),
                        ),
                        const SizedBox(width: 10),
                        _round(icon: Icons.desktop_windows_outlined, bg: Colors.white24, onTap: () {}),
                        const SizedBox(width: 10),
                        _round(icon: Icons.close, bg: AppColors.destructive, onTap: () => setState(() => _isLive = false)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Live Chat', style: TextStyle(fontWeight: FontWeight.w600)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
                        child: const Row(
                          children: [
                            Icon(Icons.pan_tool_alt_outlined, size: 16, color: AppColors.warning),
                            SizedBox(width: 6),
                            Text('3 hands raised', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w700, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView(
                      children: [
                        _msg(primary, 'Rahul', 'Great explanation sir!', '1m ago'),
                        _msg(primary, 'Priya', 'Can you repeat the last part?', '2m ago', hand: true),
                        _msg(primary, 'Amit', 'Thank you!', '3m ago'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Type a message...'))),
                      const SizedBox(width: 10),
                      FilledButton(onPressed: () {}, child: const Text('Send')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _round({required IconData icon, required Color bg, required VoidCallback onTap}) {
    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(14), child: Icon(icon, color: Colors.white)),
      ),
    );
  }

  Widget _msg(Color primary, String name, String message, String time, {bool hand = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 14, backgroundColor: primary.withValues(alpha: 0.2), child: Text(name[0], style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 12))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    if (hand) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.pan_tool_alt_outlined, size: 14, color: AppColors.warning),
                    ],
                    const SizedBox(width: 8),
                    Text(time, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color)),
                  ],
                ),
                Text(message, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.value, required this.label, required this.valueColor});
  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.1, color: valueColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 11, height: 1.15),
            ),
          ],
        ),
      ),
    );
  }
}

