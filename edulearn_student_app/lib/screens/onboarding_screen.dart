import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _Slide {
  const _Slide({required this.icon, required this.title, required this.desc, required this.gradient});
  final IconData icon;
  final String title;
  final String desc;
  final List<Color> gradient;
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _slides = [
    _Slide(
      icon: Icons.menu_book_rounded,
      title: 'Learn at Your Pace',
      desc:
          'Access thousands of courses, video lectures, and study materials anytime, anywhere.',
      gradient: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    ),
    _Slide(
      icon: Icons.track_changes_rounded,
      title: 'Track Your Progress',
      desc: 'Monitor your learning journey with detailed analytics and personalized insights.',
      gradient: [Color(0xFFA855F7), Color(0xFFDB2777)],
    ),
    _Slide(
      icon: Icons.emoji_events_rounded,
      title: 'Achieve Your Goals',
      desc: 'Earn certificates, compete with peers, and unlock achievements as you learn.',
      gradient: [Color(0xFFF97316), Color(0xFFDC2626)],
    ),
  ];

  int _index = 0;

  void _next() {
    if (_index < _slides.length - 1) {
      setState(() => _index++);
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_index];
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: slide.gradient.map((c) => c.withValues(alpha: 0.05)).toList(),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(colors: slide.gradient),
                            boxShadow: const [BoxShadow(blurRadius: 16, offset: Offset(0, 8), color: Colors.black26)],
                          ),
                          child: Icon(slide.icon, size: 80, color: Colors.white),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.desc,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: active ? 32 : 8,
                      decoration: BoxDecoration(
                        color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_index < _slides.length - 1)
                      Expanded(
                        child: TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Skip'),
                        ),
                      ),
                    Expanded(
                      flex: _index < _slides.length - 1 ? 1 : 1,
                      child: FilledButton(
                        onPressed: _next,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_index == _slides.length - 1 ? 'Get Started' : 'Next'),
                            const Icon(Icons.chevron_right, size: 22),
                          ],
                        ),
                      ),
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
}
