import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

enum _DownloadStatus { idle, downloading, done }

class _ChapterDownload {
  _ChapterDownload({this.status = _DownloadStatus.idle, this.progress = 0});
  _DownloadStatus status;
  double progress;
}

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, required this.courseId, this.from});
  final String courseId;
  // Optional origin hint (e.g. 'notifications') controlling the back arrow.
  final String? from;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);
  bool _fav = false;

  final Map<String, _ChapterDownload> _downloads = {};
  final Map<String, Timer> _timers = {};

  @override
  void dispose() {
    _tabs.dispose();
    for (final t in _timers.values) {
      t.cancel();
    }
    _timers.clear();
    super.dispose();
  }

  _ChapterDownload _downloadFor(String key) =>
      _downloads.putIfAbsent(key, () => _ChapterDownload());

  void _toggleDownload(String key, String label) {
    final entry = _downloadFor(key);

    if (entry.status == _DownloadStatus.downloading) {
      _timers.remove(key)?.cancel();
      setState(() {
        entry.status = _DownloadStatus.idle;
        entry.progress = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download cancelled: $label')),
      );
      return;
    }

    if (entry.status == _DownloadStatus.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label already downloaded'),
          action: SnackBarAction(
            label: 'Remove',
            onPressed: () => setState(() {
              entry.status = _DownloadStatus.idle;
              entry.progress = 0;
            }),
          ),
        ),
      );
      return;
    }

    setState(() {
      entry.status = _DownloadStatus.downloading;
      entry.progress = 0;
    });

    _timers.remove(key)?.cancel();
    _timers[key] = Timer.periodic(const Duration(milliseconds: 220), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        entry.progress = (entry.progress + 0.1).clamp(0.0, 1.0);
        if (entry.progress >= 1.0) {
          entry.status = _DownloadStatus.done;
          timer.cancel();
          _timers.remove(key);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded: $label')),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF97316), Color(0xFFDC2626)]),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (widget.from == 'notifications') {
                            context.go('/notifications');
                          } else {
                            context.pop();
                          }
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => setState(() => _fav = !_fav),
                        icon: Icon(_fav ? Icons.favorite : Icons.favorite_border, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Course link copied to share')),
                          );
                        },
                        icon: const Icon(Icons.share_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Complete JEE Main 2027', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Master all concepts with expert guidance', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 18),
                            const SizedBox(width: 4),
                            Text('4.8', style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.w600)),
                            Text(' (2.5k reviews)', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                            const SizedBox(width: 16),
                            const Icon(Icons.people_outline, color: Colors.white, size: 18),
                            const SizedBox(width: 4),
                            Text('12.5k students', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(Icons.schedule, '180+ hours'),
                            _chip(Icons.menu_book_outlined, '240 lessons'),
                            _chip(Icons.download_outlined, 'Offline'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: cardColor,
            elevation: 0,
            child: TabBar(
              controller: _tabs,
              labelColor: primary,
              unselectedLabelColor: muted,
              indicatorColor: primary,
              tabs: const [Tab(text: 'Overview'), Tab(text: 'Curriculum'), Tab(text: 'Reviews')],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _overview(context, muted),
                _curriculum(context, muted, primary),
                _reviews(context, muted),
              ],
            ),
          ),
          Material(
            elevation: 8,
            color: cardColor,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price', style: TextStyle(color: muted, fontSize: 12)),
                        Text('₹14,999', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enrollment flow coming soon')),
                          );
                        },
                        child: const Text('Enroll Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _overview(BuildContext context, Color? muted) {
    const learnItems = [
      'Master all JEE Main topics with detailed explanations',
      'Solve 5000+ practice problems and previous year questions',
      'Learn time management and exam strategies',
      'Access to exclusive study materials and notes',
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('About this course', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 8),
        Text(
          'Comprehensive JEE Main preparation course covering Physics, Chemistry, and Mathematics. '
          'Learn from experienced faculty with 15+ years of expertise. Includes live doubt solving, '
          'weekly tests, and personalized study plans.',
          style: TextStyle(color: muted, height: 1.5, fontSize: 14),
        ),
        const SizedBox(height: 24),
        const Text("What you'll learn", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        for (final item in learnItems)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.12), shape: BoxShape.circle),
                  child: const Center(child: Icon(Icons.circle, size: 8, color: Color(0xFF10B981))),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(item, style: TextStyle(color: muted, fontSize: 14, height: 1.4))),
              ],
            ),
          ),
        const SizedBox(height: 16),
        const Text('Instructor', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF9333EA)]),
                  shape: BoxShape.circle,
                ),
                child: const Text('TE', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Team Experts', style: TextStyle(fontWeight: FontWeight.w600)),
                    Text('IIT Alumni & Expert Faculty', style: TextStyle(color: muted, fontSize: 13)),
                    const SizedBox(height: 6),
                    Text('15+ Years Experience  •  50k+ Students', style: TextStyle(color: muted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _curriculum(BuildContext context, Color? muted, Color primary) {
    final sections = [
      ('Physics', 80, '60h'),
      ('Chemistry', 80, '60h'),
      ('Mathematics', 80, '60h'),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        for (final s in sections) ...[
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('${s.$2} lessons • ${s.$3}', style: TextStyle(color: muted, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                for (var lesson = 1; lesson <= 3; lesson++)
                  _chapterRow(
                    subjectKey: s.$1,
                    lesson: lesson,
                    title: 'Chapter $lesson: Introduction',
                    duration: '45 min',
                    muted: muted,
                    primary: primary,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _chapterRow({
    required String subjectKey,
    required int lesson,
    required String title,
    required String duration,
    required Color? muted,
    required Color primary,
  }) {
    final key = '$subjectKey-$lesson';
    final entry = _downloadFor(key);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.push('/video-player/${widget.courseId}-$key'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.play_arrow_rounded, color: primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(duration, style: TextStyle(fontSize: 12, color: muted)),
                      if (entry.status == _DownloadStatus.downloading) ...[
                        Text('  •  ', style: TextStyle(color: muted)),
                        Text(
                          '${(entry.progress * 100).round()}%',
                          style: TextStyle(fontSize: 12, color: primary, fontWeight: FontWeight.w600),
                        ),
                      ] else if (entry.status == _DownloadStatus.done) ...[
                        Text('  •  ', style: TextStyle(color: muted)),
                        const Text(
                          'Saved offline',
                          style: TextStyle(fontSize: 12, color: Color(0xFF10B981), fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            _downloadButton(entry, key, title, muted, primary),
          ],
        ),
      ),
    );
  }

  Widget _downloadButton(
    _ChapterDownload entry,
    String key,
    String label,
    Color? muted,
    Color primary,
  ) {
    final tooltip = switch (entry.status) {
      _DownloadStatus.idle => 'Download',
      _DownloadStatus.downloading => 'Cancel download',
      _DownloadStatus.done => 'Downloaded',
    };

    Widget icon;
    switch (entry.status) {
      case _DownloadStatus.idle:
        icon = Icon(Icons.download_outlined, size: 20, color: muted);
        break;
      case _DownloadStatus.downloading:
        icon = SizedBox(
          width: 20,
          height: 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: entry.progress,
                strokeWidth: 2,
                color: primary,
                backgroundColor: primary.withValues(alpha: 0.15),
              ),
              const Icon(Icons.close, size: 12),
            ],
          ),
        );
        break;
      case _DownloadStatus.done:
        icon = const Icon(Icons.download_done, size: 20, color: Color(0xFF10B981));
        break;
    }

    return IconButton(
      tooltip: tooltip,
      onPressed: () => _toggleDownload(key, label),
      icon: icon,
    );
  }

  Widget _reviews(BuildContext context, Color? muted) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                const Text('4.8', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                Row(children: List.generate(5, (_) => const Icon(Icons.star, size: 18, color: Color(0xFFFACC15)))),
                Text('2.5k reviews', style: TextStyle(color: muted, fontSize: 12)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  for (final r in [(5, 0.8), (4, 0.15), (3, 0.05), (2, 0.0), (1, 0.0)])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          SizedBox(width: 32, child: Text('${r.$1} ⭐', style: TextStyle(fontSize: 11, color: muted))),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: r.$2,
                                minHeight: 8,
                                backgroundColor: Theme.of(context).dividerColor,
                                color: const Color(0xFFFACC15),
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
        const SizedBox(height: 24),
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFA855F7), Color(0xFFDB2777)]),
                          shape: BoxShape.circle,
                        ),
                        child: const Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Amit Kumar', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            Row(
                              children: [
                                ...List.generate(5, (_) => const Icon(Icons.star, size: 14, color: Color(0xFFFACC15))),
                                const SizedBox(width: 8),
                                Text('2 days ago', style: TextStyle(fontSize: 11, color: muted)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Excellent course! The explanations are crystal clear and the practice problems '
                    'really help solidify the concepts. Highly recommended for JEE preparation.',
                    style: TextStyle(fontSize: 13, color: muted, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
