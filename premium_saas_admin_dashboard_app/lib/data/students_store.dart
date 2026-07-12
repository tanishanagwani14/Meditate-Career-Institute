import 'package:flutter/foundation.dart';

/// (name, email, phone, course, batch, status, feeStatus, enrolledOn)
typedef StudentRow = (
  String name,
  String email,
  String phone,
  String course,
  String batch,
  String status,
  String feeStatus,
  String enrolledOn,
);

class StudentsStore extends ChangeNotifier {
  StudentsStore._();
  static final StudentsStore instance = StudentsStore._();

  final List<StudentRow> items = [
    ('Aarav Sharma', 'aarav.sharma@email.com', '+91 98765 43210', 'JEE Advanced', 'Batch A1', 'active', 'Paid', '2026-01-15'),
    ('Diya Patel', 'diya.patel@email.com', '+91 98765 43211', 'NEET', 'Batch B2', 'active', 'Paid', '2026-01-18'),
    ('Arjun Reddy', 'arjun.reddy@email.com', '+91 98765 43212', 'Foundation', 'Batch C1', 'active', 'Pending', '2026-02-01'),
    ('Ananya Singh', 'ananya.singh@email.com', '+91 98765 43213', 'JEE Mains', 'Batch A2', 'active', 'Paid', '2026-02-10'),
    ('Vihaan Kumar', 'vihaan.kumar@email.com', '+91 98765 43214', 'NEET', 'Batch B1', 'inactive', 'Overdue', '2025-12-20'),
  ];

  void addStudent(StudentRow student) {
    items.insert(0, student);
    notifyListeners();
  }

  static List<String> get courses => [
        'All',
        'JEE Advanced',
        'NEET',
        'Foundation',
        'JEE Mains',
      ];

  static List<String> get statuses => ['All', 'active', 'inactive'];

  static List<String> get feeStatuses => ['All', 'Paid', 'Pending', 'Overdue'];
}
