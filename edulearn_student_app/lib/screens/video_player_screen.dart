import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.id});
  final String id;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with SingleTickerProviderStateMixin {
  bool _playing = false;
  bool _bookmark = false;
  bool _muted = false;
  double _volume = 0.8;
  double _speed = 1.0;
  String _quality = 'Auto';
  bool _fullscreen = false;
  late final TabController _tab = TabController(length: 3, vsync: this);

  static const _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  static const _qualityOptions = ['Auto', '1080p', '720p', '480p', '360p'];

  static final _modules = [
    (
      'Chapter 1: Introduction',
      [
        ('What is Magnetism?', '12:30', true),
        ('Magnetic Field Lines', '15:45', true),
        ('Bar Magnets', '18:20', false),
      ],
    ),
    (
      'Chapter 2: Magnetic Effects',
      [
        ('Current Carrying Conductor', '20:15', false),
        ('Electromagnetic Induction', '25:30', false),
      ],
    ),
  ];

  @override
  void dispose() {
    _tab.dispose();
    if (_fullscreen) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _muted = !_muted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_muted ? 'Muted' : 'Unmuted'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _showVolumeSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Volume', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setSheetState(() => _muted = !_muted);
                          setState(() {});
                        },
                        icon: Icon(_muted || _volume == 0
                            ? Icons.volume_off
                            : _volume < 0.5
                                ? Icons.volume_down
                                : Icons.volume_up),
                      ),
                      Expanded(
                        child: Slider(
                          value: _muted ? 0 : _volume,
                          onChanged: (v) {
                            setSheetState(() {
                              _volume = v;
                              if (v > 0) _muted = false;
                            });
                            setState(() {});
                          },
                        ),
                      ),
                      SizedBox(
                        width: 44,
                        child: Text(
                          '${((_muted ? 0 : _volume) * 100).round()}%',
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Playback Settings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Playback speed', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in _speedOptions)
                        ChoiceChip(
                          label: Text(s == 1.0 ? 'Normal' : '${s}x'),
                          selected: _speed == s,
                          onSelected: (_) {
                            setSheetState(() => _speed = s);
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Quality', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final q in _qualityOptions)
                        ChoiceChip(
                          label: Text(q),
                          selected: _quality == q,
                          onSelected: (_) {
                            setSheetState(() => _quality = q);
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _toggleFullscreen() {
    setState(() => _fullscreen = !_fullscreen);
    if (_fullscreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    final player = Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF581C87)]),
                  ),
                  child: Center(
                    child: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        foregroundColor: Colors.white,
                      ),
                      iconSize: 48,
                      onPressed: () => setState(() => _playing = !_playing),
                      icon: Icon(_playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                    onPressed: () {
                      if (_fullscreen) {
                        _toggleFullscreen();
                      } else {
                        context.pop();
                      }
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                    onPressed: () => setState(() => _bookmark = !_bookmark),
                    icon: Icon(_bookmark ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.75), Colors.transparent],
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(onPressed: () => setState(() => _playing = !_playing), icon: Icon(_playing ? Icons.pause : Icons.play_arrow, color: Colors.white)),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(value: 1 / 3, minHeight: 4, backgroundColor: Colors.white30, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('04:30 / 12:30', style: TextStyle(color: Colors.white, fontSize: 12)),
                        IconButton(
                          onPressed: _toggleMute,
                          onLongPress: _showVolumeSheet,
                          tooltip: _muted ? 'Unmute (long-press for volume)' : 'Mute (long-press for volume)',
                          icon: Icon(
                            _muted || _volume == 0
                                ? Icons.volume_off
                                : _volume < 0.5
                                    ? Icons.volume_down_outlined
                                    : Icons.volume_up_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        IconButton(
                          onPressed: _showSettingsSheet,
                          tooltip: 'Settings',
                          icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
                        ),
                        IconButton(
                          onPressed: _toggleFullscreen,
                          tooltip: _fullscreen ? 'Exit fullscreen' : 'Fullscreen',
                          icon: Icon(_fullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white, size: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

    if (_fullscreen) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _toggleFullscreen();
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(child: player),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: player,
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('What is Magnetism?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text('Chapter 1: Introduction • Physics - Class 12', style: TextStyle(fontSize: 13, color: muted)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Notes added to downloads')),
                                );
                              },
                              icon: const Icon(Icons.description_outlined, size: 18),
                              label: const Text('Download Notes'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.push('/ask-doubt'),
                              icon: const Icon(Icons.chat_bubble_outline, size: 18),
                              label: const Text('Ask Doubt'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Theme.of(context).cardColor,
                  child: TabBar(
                    controller: _tab,
                    labelColor: primary,
                    unselectedLabelColor: muted,
                    indicatorColor: primary,
                    tabs: const [Tab(text: 'Modules'), Tab(text: 'Notes'), Tab(text: 'Doubts')],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tab,
                    children: [
                      ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          for (final mod in _modules) ...[
                            Text(mod.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 12),
                            for (var i = 0; i < mod.$2.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: AppCard(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: mod.$2[i].$3
                                              ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                              : (i == 0 ? primary.withValues(alpha: 0.1) : Theme.of(context).dividerColor.withValues(alpha: 0.3)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: mod.$2[i].$3
                                              ? const Color(0xFF10B981)
                                              : (i == 0 ? primary : muted),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(mod.$2[i].$1, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                            Text(mod.$2[i].$2, style: TextStyle(fontSize: 12, color: muted)),
                                          ],
                                        ),
                                      ),
                                      if (mod.$2[i].$3)
                                        const CircleAvatar(radius: 12, backgroundColor: Color(0xFF10B981), child: Icon(Icons.check, size: 14, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                      ListView(
                        padding: const EdgeInsets.all(24),
                        children: [
                          for (var n = 1; n <= 3; n++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppCard(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                      child: Icon(Icons.description_outlined, color: primary),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Chapter $n Notes', style: const TextStyle(fontWeight: FontWeight.w600)),
                                          Text('PDF • 2.5 MB', style: TextStyle(fontSize: 12, color: muted)),
                                          const SizedBox(height: 8),
                                          OutlinedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Chapter $n Notes downloaded')),
                                              );
                                            },
                                            child: const Text('Download'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 64, color: muted),
                              const SizedBox(height: 12),
                              Text('No doubts asked yet', style: TextStyle(color: muted)),
                              const SizedBox(height: 16),
                              FilledButton(onPressed: () => context.push('/ask-doubt'), child: const Text('Ask Your First Doubt')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
