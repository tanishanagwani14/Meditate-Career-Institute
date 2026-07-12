import 'package:flutter/foundation.dart';

class Doubt {
  const Doubt({
    required this.id,
    required this.subject,
    required this.question,
    required this.askedBy,
    required this.time,
    required this.replies,
    required this.status,
    required this.views,
  });

  final int id;
  final String subject;
  final String question;
  final String askedBy;
  final String time;
  final int replies;
  final String status;
  final int views;
}

class DoubtsStore extends ChangeNotifier {
  DoubtsStore._() {
    _items.addAll(_seed);
  }

  static final DoubtsStore instance = DoubtsStore._();

  static const _seed = <Doubt>[
    Doubt(
      id: 1,
      subject: 'Physics',
      question: 'How to calculate magnetic flux through a solenoid?',
      askedBy: 'You',
      time: '2 hours ago',
      replies: 3,
      status: 'answered',
      views: 45,
    ),
    Doubt(
      id: 2,
      subject: 'Chemistry',
      question: 'Difference between SN1 and SN2 reactions?',
      askedBy: 'Priya S.',
      time: '5 hours ago',
      replies: 8,
      status: 'discussing',
      views: 120,
    ),
    Doubt(
      id: 3,
      subject: 'Mathematics',
      question: 'Integration by parts - when to use it?',
      askedBy: 'Rahul K.',
      time: '1 day ago',
      replies: 12,
      status: 'solved',
      views: 250,
    ),
  ];

  final List<Doubt> _items = [];

  List<Doubt> get items => List.unmodifiable(_items);

  int _nextId() {
    if (_items.isEmpty) return 1;
    return _items.map((d) => d.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void addDoubt({
    required String subject,
    required String question,
  }) {
    _items.insert(
      0,
      Doubt(
        id: _nextId(),
        subject: subject,
        question: question,
        askedBy: 'You',
        time: 'Just now',
        replies: 0,
        status: 'open',
        views: 0,
      ),
    );
    notifyListeners();
  }
}
