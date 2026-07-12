class FeeRecord {
  const FeeRecord({
    required this.studentName,
    required this.email,
    required this.phone,
    required this.course,
    required this.batch,
    required this.feeAmountInr,
    required this.dueDate,
    required this.paidOn,
    required this.status, // paid | pending | overdue
    required this.receiptId,
  });

  final String studentName;
  final String email;
  final String phone;
  final String course;
  final String batch;
  final int feeAmountInr;
  final String dueDate;
  final String? paidOn;
  final String status;
  final String? receiptId;
}

class FeesData {
  FeesData._();

  static const records = <FeeRecord>[
    FeeRecord(
      studentName: 'Aarav Sharma',
      email: 'aarav.sharma@email.com',
      phone: '+91 98765 43210',
      course: 'JEE Advanced',
      batch: 'Batch A1',
      feeAmountInr: 45000,
      dueDate: '2026-05-05',
      paidOn: '2026-05-02',
      status: 'paid',
      receiptId: 'RCPT-10021',
    ),
    FeeRecord(
      studentName: 'Diya Patel',
      email: 'diya.patel@email.com',
      phone: '+91 98765 43211',
      course: 'NEET',
      batch: 'Batch B2',
      feeAmountInr: 40000,
      dueDate: '2026-05-10',
      paidOn: '2026-05-08',
      status: 'paid',
      receiptId: 'RCPT-10022',
    ),
    FeeRecord(
      studentName: 'Arjun Reddy',
      email: 'arjun.reddy@email.com',
      phone: '+91 98765 43212',
      course: 'Foundation',
      batch: 'Batch C1',
      feeAmountInr: 25000,
      dueDate: '2026-05-03',
      paidOn: null,
      status: 'overdue',
      receiptId: null,
    ),
    FeeRecord(
      studentName: 'Ananya Singh',
      email: 'ananya.singh@email.com',
      phone: '+91 98765 43213',
      course: 'JEE Mains',
      batch: 'Batch A2',
      feeAmountInr: 35000,
      dueDate: '2026-05-15',
      paidOn: null,
      status: 'pending',
      receiptId: null,
    ),
    FeeRecord(
      studentName: 'Vihaan Kumar',
      email: 'vihaan.kumar@email.com',
      phone: '+91 98765 43214',
      course: 'NEET',
      batch: 'Batch B1',
      feeAmountInr: 40000,
      dueDate: '2026-04-25',
      paidOn: null,
      status: 'overdue',
      receiptId: null,
    ),
    FeeRecord(
      studentName: 'Saanvi Gupta',
      email: 'saanvi.gupta@email.com',
      phone: '+91 98765 43215',
      course: 'Skill Dev',
      batch: 'Batch S1',
      feeAmountInr: 20000,
      dueDate: '2026-05-20',
      paidOn: null,
      status: 'pending',
      receiptId: null,
    ),
    FeeRecord(
      studentName: 'Reyansh Joshi',
      email: 'reyansh.joshi@email.com',
      phone: '+91 98765 43216',
      course: 'JEE Advanced',
      batch: 'Batch A1',
      feeAmountInr: 45000,
      dueDate: '2026-05-12',
      paidOn: '2026-05-10',
      status: 'paid',
      receiptId: 'RCPT-10023',
    ),
  ];

  static const statuses = ['All', 'paid', 'pending', 'overdue'];

  static List<String> get courses {
    final s = <String>{'All'};
    for (final r in records) {
      s.add(r.course);
    }
    return s.toList(growable: false);
  }

  static int get totalCollectedInr =>
      records.where((r) => r.status == 'paid').fold(0, (sum, r) => sum + r.feeAmountInr);

  static int get pendingInr =>
      records.where((r) => r.status == 'pending').fold(0, (sum, r) => sum + r.feeAmountInr);

  static int get overdueInr =>
      records.where((r) => r.status == 'overdue').fold(0, (sum, r) => sum + r.feeAmountInr);

  static double get collectionRate {
    final total = records.fold(0, (sum, r) => sum + r.feeAmountInr);
    if (total == 0) return 0;
    return (totalCollectedInr / total) * 100.0;
  }

  static String formatInr(int amount) {
    // Keep it simple (no intl dependency). Example: 45000 -> ₹45,000
    final s = amount.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      final remaining = idxFromEnd - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(',');
    }
    return '₹${buf.toString()}';
  }
}

