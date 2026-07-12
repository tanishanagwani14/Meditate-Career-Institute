import 'package:flutter/material.dart';

class StudentProfileItem {
  const StudentProfileItem({
    required this.name,
    required this.course,
    required this.batch,
    required this.enrolledOn,
    required this.status,
    required this.email,
    required this.phone,
    required this.parentName,
    required this.feeStatus,
    required this.attendance,
    required this.counselor,
    required this.about,
    required this.details,
  });

  final String name;
  final String course;
  final String batch;
  final String enrolledOn;
  final String status;
  final String email;
  final String phone;
  final String parentName;
  final String feeStatus;
  final String attendance;
  final String counselor;
  final String about;
  final List<(String label, String value)> details;
}

class MonthlyRevenueItem {
  const MonthlyRevenueItem({
    required this.title,
    required this.amount,
    required this.students,
    required this.period,
    required this.body,
    required this.details,
  });

  final String title;
  final String amount;
  final String students;
  final String period;
  final String body;
  final List<(String label, String value)> details;
}

class DashboardActivity {
  const DashboardActivity({
    required this.id,
    required this.type,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.text,
    required this.time,
    required this.title,
    required this.body,
    required this.details,
  });

  final int id;
  final String type;
  final IconData icon;
  final Color bg;
  final Color fg;
  final String text;
  final String time;
  final String title;
  final String body;
  final List<(String label, String value)> details;
}

class DashboardData {
  DashboardData._();
  static final DashboardData instance = DashboardData._();

  static const activities = [
    DashboardActivity(
      id: 1,
      type: 'enrollment',
      icon: Icons.people_outline,
      bg: Color(0xFFDBEAFE),
      fg: Color(0xFF2563EB),
      text: 'Priya Sharma enrolled in JEE Advanced',
      time: '10 mins ago',
      title: 'New Enrollment',
      body: 'Priya Sharma has successfully enrolled in the JEE Advanced batch. '
          'Fee payment of ₹45,000 is confirmed and study material access is active.',
      details: [
        ('Student', 'Priya Sharma'),
        ('Course', 'JEE Advanced'),
        ('Batch', 'Batch A1'),
        ('Counselor', 'Anita Mehta'),
        ('Status', 'Active'),
      ],
    ),
    DashboardActivity(
      id: 2,
      type: 'payment',
      icon: Icons.currency_rupee,
      bg: Color(0xFFDCFCE7),
      fg: Color(0xFF16A34A),
      text: 'Rahul Kumar paid ₹15,000',
      time: '25 mins ago',
      title: 'Fee Payment Received',
      body: 'Rahul Kumar completed a partial fee payment for NEET Coaching via UPI. '
          'Receipt #INV-2026-1842 has been generated and sent to the parent.',
      details: [
        ('Student', 'Rahul Kumar'),
        ('Amount', '₹15,000'),
        ('Method', 'UPI'),
        ('Receipt', 'INV-2026-1842'),
        ('Balance', '₹10,000 pending'),
      ],
    ),
    DashboardActivity(
      id: 3,
      type: 'attendance',
      icon: Icons.calendar_today_outlined,
      bg: Color(0xFFF3E8FF),
      fg: Color(0xFF7C3AED),
      text: 'Physics Batch A - 45/50 present',
      time: '1 hour ago',
      title: 'Attendance Marked',
      body: 'Daily attendance for Physics Batch A has been recorded. '
          '5 students were marked absent; parents have been notified automatically.',
      details: [
        ('Batch', 'Physics Batch A'),
        ('Present', '45 students'),
        ('Absent', '5 students'),
        ('Teacher', 'Mr. Sharma'),
        ('Session', 'Morning slot'),
      ],
    ),
    DashboardActivity(
      id: 4,
      type: 'assignment',
      icon: Icons.menu_book_outlined,
      bg: Color(0xFFFFEDD5),
      fg: Color(0xFFEA580C),
      text: 'Dr. Singh created Organic Chemistry assignment',
      time: '2 hours ago',
      title: 'New Assignment Created',
      body: 'Dr. Singh published a new assignment for NEET Biology students. '
          'Due date is set for 3 days from now with auto-reminders enabled.',
      details: [
        ('Teacher', 'Dr. Singh'),
        ('Subject', 'Organic Chemistry'),
        ('Course', 'NEET Biology'),
        ('Due date', '3 days'),
        ('Submissions', '0 / 38'),
      ],
    ),
  ];

  static const newEnrollments = [
    ('Priya Sharma', 'JEE Advanced', 'Batch A1', '₹45,000', '10 mins ago', 'Paid'),
    ('Karan Mehta', 'NEET Coaching', 'Batch B2', '₹38,000', '2 hours ago', 'Paid'),
    ('Sneha Reddy', 'Foundation', 'Batch C1', '₹22,000', '5 hours ago', 'Pending'),
    ('Vikram Joshi', 'JEE Mains', 'Batch A2', '₹42,000', 'Yesterday', 'Paid'),
    ('Meera Iyer', 'Skill Development', 'Batch D1', '₹18,000', 'Yesterday', 'Paid'),
    ('Arjun Nair', 'NEET Coaching', 'Batch B1', '₹38,000', '2 days ago', 'Paid'),
  ];

  static const feeCollections = [
    ('Rahul Kumar', 'NEET Coaching', '₹15,000', 'UPI', '25 mins ago', 'Partial'),
    ('Ananya Singh', 'JEE Mains', '₹42,000', 'Card', '1 hour ago', 'Full'),
    ('Diya Patel', 'NEET', '₹38,000', 'Bank transfer', '3 hours ago', 'Full'),
    ('Aarav Sharma', 'JEE Advanced', '₹45,000', 'UPI', 'Today', 'Full'),
    ('Vihaan Kumar', 'Foundation', '₹12,000', 'Cash', 'Yesterday', 'Partial'),
    ('Isha Gupta', 'JEE Mains', '₹20,000', 'UPI', 'Yesterday', 'Partial'),
  ];

  static const activeTeachers = [
    ('Dr. Rajesh Sharma', 'Physics', 'JEE / NEET', '4 batches', '98% rating', 'Online'),
    ('Dr. Priya Singh', 'Chemistry', 'NEET Biology', '3 batches', '96% rating', 'In class'),
    ('Prof. Amit Kumar', 'Mathematics', 'JEE Advanced', '5 batches', '97% rating', 'Online'),
    ('Ms. Neha Verma', 'Biology', 'NEET', '3 batches', '95% rating', 'Offline'),
    ('Mr. Sanjay Patel', 'English', 'Foundation', '2 batches', '94% rating', 'Online'),
    ('Dr. Meera Iyer', 'Chemistry', 'JEE Mains', '4 batches', '99% rating', 'In class'),
  ];

  /// All enrolled students (Total Students KPI).
  static const totalStudents = <StudentProfileItem>[
    StudentProfileItem(
      name: 'Aarav Sharma',
      course: 'JEE Advanced',
      batch: 'Batch A1',
      enrolledOn: '2026-01-15',
      status: 'active',
      email: 'aarav.sharma@email.com',
      phone: '+91 98765 43210',
      parentName: 'Rajesh Sharma',
      feeStatus: 'Paid',
      attendance: '94%',
      counselor: 'Anita Mehta',
      about: 'Aarav is a consistent performer in Physics and Mathematics with strong mock-test scores.',
      details: [
        ('Roll no.', 'STU-1024'),
        ('Last test score', '86%'),
        ('Classes attended', '42 / 45'),
        ('Doubt sessions', '3 this month'),
      ],
    ),
    StudentProfileItem(
      name: 'Diya Patel',
      course: 'NEET Coaching',
      batch: 'Batch B2',
      enrolledOn: '2026-01-18',
      status: 'active',
      email: 'diya.patel@email.com',
      phone: '+91 98765 43211',
      parentName: 'Meena Patel',
      feeStatus: 'Paid',
      attendance: '91%',
      counselor: 'Rohit Desai',
      about: 'Diya excels in Biology and is preparing for NEET 2027 with regular assignment submissions.',
      details: [
        ('Roll no.', 'STU-1041'),
        ('Last test score', '82%'),
        ('Classes attended', '40 / 44'),
        ('Doubt sessions', '1 this month'),
      ],
    ),
    StudentProfileItem(
      name: 'Priya Sharma',
      course: 'JEE Advanced',
      batch: 'Batch A1',
      enrolledOn: '2026-02-01',
      status: 'active',
      email: 'priya.sharma@email.com',
      phone: '+91 98765 43220',
      parentName: 'Sunil Sharma',
      feeStatus: 'Paid',
      attendance: '96%',
      counselor: 'Anita Mehta',
      about: 'Recently enrolled in JEE Advanced. Shows high engagement in live classes.',
      details: [
        ('Roll no.', 'STU-1089'),
        ('Last test score', '79%'),
        ('Classes attended', '18 / 19'),
        ('Doubt sessions', '2 this month'),
      ],
    ),
    StudentProfileItem(
      name: 'Rahul Kumar',
      course: 'NEET Coaching',
      batch: 'Batch B1',
      enrolledOn: '2026-02-05',
      status: 'active',
      email: 'rahul.kumar@email.com',
      phone: '+91 98765 43230',
      parentName: 'Vikram Kumar',
      feeStatus: 'Pending',
      attendance: '88%',
      counselor: 'Rohit Desai',
      about: 'Rahul is working on improving Chemistry scores; fee installment due this week.',
      details: [
        ('Roll no.', 'STU-1095'),
        ('Last test score', '74%'),
        ('Classes attended', '35 / 40'),
        ('Doubt sessions', '4 this month'),
      ],
    ),
    StudentProfileItem(
      name: 'Ananya Singh',
      course: 'JEE Mains',
      batch: 'Batch A2',
      enrolledOn: '2026-02-10',
      status: 'active',
      email: 'ananya.singh@email.com',
      phone: '+91 98765 43240',
      parentName: 'Amit Singh',
      feeStatus: 'Paid',
      attendance: '93%',
      counselor: 'Kavita Nair',
      about: 'Ananya maintains steady progress across all JEE Mains modules.',
      details: [
        ('Roll no.', 'STU-1102'),
        ('Last test score', '88%'),
        ('Classes attended', '22 / 24'),
        ('Doubt sessions', '0 this month'),
      ],
    ),
    StudentProfileItem(
      name: 'Karan Mehta',
      course: 'NEET Coaching',
      batch: 'Batch B2',
      enrolledOn: '2026-02-12',
      status: 'active',
      email: 'karan.mehta@email.com',
      phone: '+91 98765 43250',
      parentName: 'Deepak Mehta',
      feeStatus: 'Paid',
      attendance: '90%',
      counselor: 'Rohit Desai',
      about: 'Karan participates actively in doubt sessions and weekend workshops.',
      details: [
        ('Roll no.', 'STU-1110'),
        ('Last test score', '81%'),
        ('Classes attended', '20 / 22'),
        ('Doubt sessions', '2 this month'),
      ],
    ),
    StudentProfileItem(
      name: 'Sneha Reddy',
      course: 'Foundation',
      batch: 'Batch C1',
      enrolledOn: '2026-02-14',
      status: 'active',
      email: 'sneha.reddy@email.com',
      phone: '+91 98765 43260',
      parentName: 'Lakshmi Reddy',
      feeStatus: 'Pending',
      attendance: '87%',
      counselor: 'Priya Verma',
      about: 'Foundation student building core concepts in Science and Mathematics.',
      details: [
        ('Roll no.', 'STU-1118'),
        ('Last test score', '76%'),
        ('Classes attended', '16 / 18'),
        ('Doubt sessions', '1 this month'),
      ],
    ),
    StudentProfileItem(
      name: 'Vihaan Kumar',
      course: 'Foundation',
      batch: 'Batch C1',
      enrolledOn: '2025-12-20',
      status: 'inactive',
      email: 'vihaan.kumar@email.com',
      phone: '+91 98765 43270',
      parentName: 'Sanjay Kumar',
      feeStatus: 'Overdue',
      attendance: '62%',
      counselor: 'Priya Verma',
      about: 'Account marked inactive due to overdue fees and low attendance in the last month.',
      details: [
        ('Roll no.', 'STU-0988'),
        ('Last test score', '58%'),
        ('Classes attended', '12 / 20'),
        ('Doubt sessions', '0 this month'),
      ],
    ),
  ];

  static StudentProfileItem? studentProfileAt(int index) {
    if (index < 0 || index >= totalStudents.length) return null;
    return totalStudents[index];
  }

  /// Monthly revenue line items (Monthly Revenue KPI).
  static const monthlyRevenue = <MonthlyRevenueItem>[
    MonthlyRevenueItem(
      title: 'JEE Advanced fees',
      amount: '₹2.1L',
      students: '248 students',
      period: 'This month',
      body: 'Fee collections from JEE Advanced batches including installments, '
          'registration, and test-series add-ons.',
      details: [
        ('Transactions', '186'),
        ('Avg per student', '₹8,468'),
        ('Collected', '₹2.1L'),
        ('Pending', '₹42K'),
        ('Last payment', 'Today, 11:20 AM'),
      ],
    ),
    MonthlyRevenueItem(
      title: 'NEET Coaching fees',
      amount: '₹1.8L',
      students: '312 students',
      period: 'This month',
      body: 'Revenue from NEET coaching programs across morning and evening batches.',
      details: [
        ('Transactions', '241'),
        ('Avg per student', '₹5,769'),
        ('Collected', '₹1.8L'),
        ('Pending', '₹28K'),
        ('Last payment', 'Today, 9:45 AM'),
      ],
    ),
    MonthlyRevenueItem(
      title: 'JEE Mains fees',
      amount: '₹1.2L',
      students: '186 students',
      period: 'This month',
      body: 'JEE Mains program fees including crash course top-ups and mock test packs.',
      details: [
        ('Transactions', '152'),
        ('Avg per student', '₹6,452'),
        ('Collected', '₹1.2L'),
        ('Pending', '₹18K'),
        ('Last payment', 'Yesterday'),
      ],
    ),
    MonthlyRevenueItem(
      title: 'Foundation program',
      amount: '₹85K',
      students: '142 students',
      period: 'This month',
      body: 'Foundation batch tuition and study material fees for grades 9–10.',
      details: [
        ('Transactions', '98'),
        ('Avg per student', '₹5,985'),
        ('Collected', '₹85K'),
        ('Pending', '₹12K'),
        ('Last payment', 'Yesterday'),
      ],
    ),
    MonthlyRevenueItem(
      title: 'Skill Development',
      amount: '₹45K',
      students: '96 students',
      period: 'This month',
      body: 'Short-term skill courses and weekend workshop enrollments.',
      details: [
        ('Transactions', '64'),
        ('Avg per student', '₹4,688'),
        ('Collected', '₹45K'),
        ('Pending', '₹6K'),
        ('Last payment', '2 days ago'),
      ],
    ),
    MonthlyRevenueItem(
      title: 'Workshops & tests',
      amount: '₹30K',
      students: '—',
      period: 'This month',
      body: 'One-time workshop registrations and paid mock test series across programs.',
      details: [
        ('Transactions', '41'),
        ('Events', '6 workshops'),
        ('Collected', '₹30K'),
        ('Pending', '₹4K'),
        ('Last payment', '3 days ago'),
      ],
    ),
  ];

  static MonthlyRevenueItem? monthlyRevenueAt(int index) {
    if (index < 0 || index >= monthlyRevenue.length) return null;
    return monthlyRevenue[index];
  }

  /// Active courses (Active Courses KPI).
  static const activeCourses = [
    ('Complete JEE Main 2027', 'JEE', '240 lessons', '1,248 enrolled', 'active'),
    ('NEET Biology Mastery', 'NEET', '180 lessons', '892 enrolled', 'active'),
    ('Foundation Science', 'Foundation', '120 lessons', '456 enrolled', 'active'),
    ('JEE Advanced Physics', 'JEE', '95 lessons', '324 enrolled', 'active'),
    ('Organic Chemistry Pro', 'NEET', '88 lessons', '278 enrolled', 'active'),
    ('Mathematics for JEE', 'JEE', '156 lessons', '512 enrolled', 'active'),
  ];

  /// Attendance records (Avg Attendance KPI).
  static const attendanceRecords = [
    ('Physics Batch A', '45/50', '90%', 'Mr. Sharma', 'Today'),
    ('Chemistry Batch B', '38/40', '95%', 'Dr. Verma', 'Today'),
    ('Math JEE Advanced', '52/55', '95%', 'Prof. Kumar', 'Today'),
    ('NEET Biology', '41/45', '91%', 'Ms. Verma', 'Yesterday'),
    ('Foundation C1', '28/32', '88%', 'Mr. Patel', 'Yesterday'),
    ('English Batch D', '35/38', '92%', 'Ms. Iyer', 'Yesterday'),
  ];

  DashboardActivity? activityById(int id) {
    for (final a in activities) {
      if (a.id == id) return a;
    }
    return null;
  }
}
