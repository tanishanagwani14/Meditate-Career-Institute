import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_card.dart';

class _Course {
  const _Course({
    required this.id,
    required this.title,
    required this.instructor,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.students,
    required this.lessons,
    required this.gradient,
    this.badge,
  });
  final int id;
  final String title;
  final String instructor;
  final int price;
  final int originalPrice;
  final double rating;
  final int students;
  final int lessons;
  final List<Color> gradient;
  final String? badge;
}

class CoursesMarketplaceScreen extends StatefulWidget {
  const CoursesMarketplaceScreen({super.key});

  @override
  State<CoursesMarketplaceScreen> createState() => _CoursesMarketplaceScreenState();
}

class _CoursesMarketplaceScreenState extends State<CoursesMarketplaceScreen> {
  static const _categories = ['All', 'JEE', 'NEET', 'Boards', 'Foundation'];
  String _cat = 'All';
  String _query = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  bool _matchesCategory(_Course c) {
    if (_cat == 'All') return true;
    final t = c.title.toLowerCase();
    return switch (_cat) {
      'JEE' => t.contains('jee'),
      'NEET' => t.contains('neet'),
      'Boards' => t.contains('cbse') || t.contains('class'),
      'Foundation' => t.contains('foundation') || t.contains('olympiad'),
      _ => true,
    };
  }

  bool _matchesQuery(_Course c) {
    if (_query.trim().isEmpty) return true;
    final q = _query.trim().toLowerCase();
    return c.title.toLowerCase().contains(q) || c.instructor.toLowerCase().contains(q);
  }

  List<_Course> get _visibleCourses =>
      _courses.where((c) => _matchesCategory(c) && _matchesQuery(c)).toList();

  static const _courses = [
    _Course(
      id: 1,
      title: 'Complete JEE Main 2027',
      instructor: 'Team Experts',
      price: 14999,
      originalPrice: 29999,
      rating: 4.8,
      students: 12500,
      lessons: 240,
      gradient: [Color(0xFFF97316), Color(0xFFDC2626)],
      badge: 'Bestseller',
    ),
    _Course(
      id: 2,
      title: 'NEET Biology Mastery',
      instructor: 'Dr. Priya Sharma',
      price: 9999,
      originalPrice: 19999,
      rating: 4.9,
      students: 8500,
      lessons: 180,
      gradient: [Color(0xFF22C55E), Color(0xFF059669)],
      badge: 'Top Rated',
    ),
    _Course(
      id: 3,
      title: 'Class 12 Physics CBSE',
      instructor: 'Prof. Rajesh Kumar',
      price: 6999,
      originalPrice: 12999,
      rating: 4.7,
      students: 15000,
      lessons: 150,
      gradient: [Color(0xFF3B82F6), Color(0xFF4F46E5)],
    ),
    _Course(
      id: 4,
      title: 'Mathematics Olympiad Prep',
      instructor: 'Mr. Arjun Patel',
      price: 11999,
      originalPrice: 24999,
      rating: 4.9,
      students: 4200,
      lessons: 200,
      gradient: [Color(0xFFA855F7), Color(0xFFDB2777)],
      badge: 'New',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Explore Courses', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Search courses...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                      prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.6)),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: Icon(Icons.clear, color: Colors.white.withValues(alpha: 0.8)),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _query = '');
                              },
                            ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final c in _categories)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _CategoryPill(
                              label: c,
                              selected: _cat == c,
                              selectedTextColor: primary,
                              onTap: () => setState(() => _cat = c),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_visibleCourses.length} courses found', style: TextStyle(color: muted, fontSize: 13)),
                    Row(
                      children: [
                        Icon(Icons.trending_up, size: 18, color: muted),
                        const SizedBox(width: 6),
                        Text('Sort by: Popular', style: TextStyle(color: muted, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_visibleCourses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: muted),
                        const SizedBox(height: 12),
                        const Text('No courses match your search', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('Try a different keyword or category', style: TextStyle(color: muted, fontSize: 13)),
                      ],
                    ),
                  ),
                for (final course in _visibleCourses) ...[
                  InkWell(
                    onTap: () => context.go('/courses/${course.id}'),
                    borderRadius: BorderRadius.circular(20),
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 128,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: course.gradient),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                ),
                              ),
                              if (course.badge != null)
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                                    child: Text(course.badge!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: primary)),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(course.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                const SizedBox(height: 6),
                                Text(course.instructor, style: TextStyle(color: muted, fontSize: 13)),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 18, color: Color(0xFFFACC15)),
                                    const SizedBox(width: 4),
                                    Text('${course.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.people_outline, size: 18, color: muted),
                                    const SizedBox(width: 4),
                                    Text(_fmt(course.students), style: TextStyle(fontSize: 12, color: muted)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.menu_book_outlined, size: 18, color: muted),
                                    const SizedBox(width: 4),
                                    Text('${course.lessons} lessons', style: TextStyle(fontSize: 12, color: muted)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('₹${course.price}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primary)),
                                        const SizedBox(width: 8),
                                        Text(
                                          '₹${course.originalPrice}',
                                          style: TextStyle(decoration: TextDecoration.lineThrough, color: muted, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                    FilledButton(onPressed: () => context.go('/courses/${course.id}'), child: const Text('Enroll Now')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedTextColor,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedTextColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.white : Colors.white.withValues(alpha: 0.18);
    final fg = selected ? selectedTextColor : Colors.white;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: icon == null ? 16 : 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fg),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(color: fg, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
