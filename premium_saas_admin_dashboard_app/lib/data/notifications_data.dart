class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.recipients,
    required this.channel,
    required this.sentOn,
    required this.sentBy,
    required this.status,
  });

  final int id;
  final String title;
  final String message;
  final String recipients;
  final String channel;
  final String sentOn;
  final String sentBy;
  final String status;
}

class NotificationsData {
  NotificationsData._();

  static const items = <NotificationItem>[
    NotificationItem(
      id: 1,
      title: 'Fee Payment Reminder',
      message: 'Reminder for May month fee payment',
      recipients: 'All Students',
      channel: 'Email + SMS',
      sentOn: '2026-05-01',
      sentBy: 'Admin',
      status: 'completed',
    ),
    NotificationItem(
      id: 2,
      title: 'Class Rescheduled - Physics',
      message: 'Physics class moved to 3 PM tomorrow',
      recipients: 'JEE Advanced Batch A1',
      channel: 'Push + SMS',
      sentOn: '2026-05-01',
      sentBy: 'Dr. Rajesh Singh',
      status: 'completed',
    ),
    NotificationItem(
      id: 3,
      title: 'Assignment Deadline Extended',
      message: 'Chemistry assignment deadline extended by 2 days',
      recipients: 'NEET Batch B2',
      channel: 'Email',
      sentOn: '2026-04-30',
      sentBy: 'Prof. Meera Iyer',
      status: 'completed',
    ),
    NotificationItem(
      id: 4,
      title: 'Holiday Announcement',
      message: 'Institute closed on May 5th for public holiday',
      recipients: 'All Students + Teachers',
      channel: 'Email + Push',
      sentOn: '2026-04-29',
      sentBy: 'Admin',
      status: 'completed',
    ),
    NotificationItem(
      id: 5,
      title: 'Mock Test Schedule',
      message: 'JEE Mock test scheduled for May 10th',
      recipients: 'All JEE Students',
      channel: 'Push',
      sentOn: '2026-05-01',
      sentBy: 'Admin',
      status: 'pending',
    ),
  ];

  static NotificationItem? byId(int id) {
    for (final n in items) {
      if (n.id == id) return n;
    }
    return null;
  }
}

