class WeeklyDayRecord {
  const WeeklyDayRecord({
    required this.label,
    required this.percent,
    required this.present,
    required this.absent,
    required this.batchesMarked,
  });

  final String label;
  final double percent;
  final int present;
  final int absent;
  final int batchesMarked;
}

class BatchAttendanceRecord {
  const BatchAttendanceRecord({
    required this.batch,
    required this.date,
    required this.presentCount,
    required this.absentCount,
    required this.total,
    required this.percent,
    required this.presentStudents,
    required this.absentStudents,
  });

  final String batch;
  final String date;
  final int presentCount;
  final int absentCount;
  final int total;
  final double percent;
  final List<String> presentStudents;
  final List<String> absentStudents;
}

class AttendanceData {
  AttendanceData._();

  static const double overallPercent = 92.0;
  static const int presentToday = 188;
  static const int absentToday = 22;
  static const int totalStudents = 210;

  static const weeklyTrend = [
    WeeklyDayRecord(label: 'Mon', percent: 92.0, present: 193, absent: 17, batchesMarked: 14),
    WeeklyDayRecord(label: 'Tue', percent: 89.0, present: 187, absent: 23, batchesMarked: 14),
    WeeklyDayRecord(label: 'Wed', percent: 94.0, present: 197, absent: 13, batchesMarked: 14),
    WeeklyDayRecord(label: 'Thu', percent: 91.0, present: 191, absent: 19, batchesMarked: 14),
    WeeklyDayRecord(label: 'Fri', percent: 88.0, present: 185, absent: 25, batchesMarked: 14),
    WeeklyDayRecord(label: 'Sat', percent: 85.0, present: 178, absent: 32, batchesMarked: 12),
  ];

  static const batches = [
    BatchAttendanceRecord(
      batch: 'JEE Advanced A1',
      date: '2026-05-01',
      presentCount: 45,
      absentCount: 5,
      total: 50,
      percent: 90.0,
      presentStudents: [
        'Aarav Sharma',
        'Ananya Singh',
        'Rohan Mehta',
        'Isha Gupta',
        'Karan Joshi',
        'Neha Verma',
        'Priya Nair',
        'Siddharth Rao',
        'Tanvi Shah',
        'Vikram Desai',
      ],
      absentStudents: ['Arjun Reddy', 'Meera Iyer', 'Rahul Kapoor', 'Sneha Pillai', 'Yash Malhotra'],
    ),
    BatchAttendanceRecord(
      batch: 'NEET B2',
      date: '2026-05-01',
      presentCount: 38,
      absentCount: 2,
      total: 40,
      percent: 95.0,
      presentStudents: [
        'Diya Patel',
        'Aditi Bose',
        'Harsh Tiwari',
        'Kavya Menon',
        'Manish Agarwal',
        'Pooja Sinha',
      ],
      absentStudents: ['Nitin Sharma', 'Riya Choudhary'],
    ),
    BatchAttendanceRecord(
      batch: 'Foundation C1',
      date: '2026-05-01',
      presentCount: 28,
      absentCount: 7,
      total: 35,
      percent: 80.0,
      presentStudents: [
        'Arjun Reddy',
        'Devansh Khanna',
        'Ira Kapoor',
        'Lakshmi N',
        'Om Prakash',
      ],
      absentStudents: [
        'Bhavya Seth',
        'Chirag Anand',
        'Esha Dutta',
        'Farhan Ali',
        'Gauri Mishra',
        'Himanshu Yadav',
        'Jatin Kohli',
      ],
    ),
    BatchAttendanceRecord(
      batch: 'JEE Mains A2',
      date: '2026-05-01',
      presentCount: 42,
      absentCount: 3,
      total: 45,
      percent: 93.3,
      presentStudents: [
        'Ananya Singh',
        'Dhruv Bansal',
        'Kritika Jain',
        'Mohit Saxena',
        'Sanjay Verma',
      ],
      absentStudents: ['Tanya Grover', 'Uday Singh', 'Varun Mehta'],
    ),
    BatchAttendanceRecord(
      batch: 'NEET B1',
      date: '2026-05-01',
      presentCount: 35,
      absentCount: 5,
      total: 40,
      percent: 87.5,
      presentStudents: [
        'Vihaan Kumar',
        'Aisha Khan',
        'Bharat Reddy',
        'Charu Mishra',
        'Deepak Roy',
      ],
      absentStudents: [
        'Ekta Sharma',
        'Faisal Ahmed',
        'Geeta Pandey',
        'Harish Nambiar',
        'Indira Das',
      ],
    ),
  ];

  static List<String> get allPresentToday => [
        for (final b in batches) ...b.presentStudents,
      ];

  static List<String> get allAbsentToday => [
        for (final b in batches) ...b.absentStudents,
      ];
}
