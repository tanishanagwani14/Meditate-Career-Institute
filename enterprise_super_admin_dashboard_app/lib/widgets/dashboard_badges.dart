import 'package:flutter/material.dart';

import 'pill_badge.dart';

/// Pill badges matching Tailwind classes from the React dashboard.
class DashboardBadges {
  DashboardBadges._();

  static Widget instituteStatus(String status) {
    return switch (status) {
      'Active' => const PillBadge(
          label: 'Active',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      'Trial' => const PillBadge(
          label: 'Trial',
          background: Color(0xFFDBEAFE),
          foreground: Color(0xFF1D4ED8),
        ),
      'Suspended' => const PillBadge(
          label: 'Suspended',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      _ => PillBadge(label: status),
    };
  }

  static Widget plan(String plan) {
    return switch (plan) {
      'Enterprise' => const PillBadge(
          label: 'Enterprise',
          background: Color(0xFFE9D5FF),
          foreground: Color(0xFF7E22CE),
        ),
      'Professional' => const PillBadge(
          label: 'Professional',
          background: Color(0xFFE0E7FF),
          foreground: Color(0xFF4338CA),
        ),
      'Basic' => const PillBadge(
          label: 'Basic',
          background: Color(0xFFF3F4F6),
          foreground: Color(0xFF374151),
        ),
      _ => PillBadge(label: plan),
    };
  }

  static Widget userStatus(String status) {
    return switch (status) {
      'Active' => const PillBadge(
          label: 'Active',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      'Suspended' => const PillBadge(
          label: 'Suspended',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      'Pending' => const PillBadge(
          label: 'Pending',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      _ => PillBadge(label: status),
    };
  }

  static Widget userRole(String role) {
    return switch (role) {
      'Admin' => const PillBadge(
          label: 'Admin',
          background: Color(0xFFE9D5FF),
          foreground: Color(0xFF7E22CE),
        ),
      'Teacher' => const PillBadge(
          label: 'Teacher',
          background: Color(0xFFDBEAFE),
          foreground: Color(0xFF1D4ED8),
        ),
      'Student' => const PillBadge(
          label: 'Student',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      _ => PillBadge(label: role),
    };
  }

  static Widget txnStatus(String status) {
    return switch (status) {
      'Completed' => const PillBadge(
          label: 'Completed',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      'Pending' => const PillBadge(
          label: 'Pending',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      'Failed' => const PillBadge(
          label: 'Failed',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      _ => PillBadge(label: status),
    };
  }

  static Widget ticketPriority(String p) {
    return switch (p) {
      'High' => const PillBadge(
          label: 'High',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      'Medium' => const PillBadge(
          label: 'Medium',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      'Low' => const PillBadge(
          label: 'Low',
          background: Color(0xFFDBEAFE),
          foreground: Color(0xFF1D4ED8),
        ),
      _ => PillBadge(label: p),
    };
  }

  static Widget ticketStatus(String s) {
    return switch (s) {
      'Open' => const PillBadge(
          label: 'Open',
          background: Color(0xFFDBEAFE),
          foreground: Color(0xFF1D4ED8),
        ),
      'In Progress' => const PillBadge(
          label: 'In Progress',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      'Resolved' => const PillBadge(
          label: 'Resolved',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      _ => PillBadge(label: s),
    };
  }

  static Widget regionStatus(String s) {
    return switch (s) {
      'Healthy' => const PillBadge(
          label: 'Healthy',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      'Degraded' => const PillBadge(
          label: 'Degraded',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      'Down' => const PillBadge(
          label: 'Down',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      _ => PillBadge(label: s),
    };
  }

  static Widget severity(String s) {
    return switch (s) {
      'Critical' => const PillBadge(
          label: 'Critical',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      'High' => const PillBadge(
          label: 'High',
          background: Color(0xFFFFEDD5),
          foreground: Color(0xFFC2410C),
        ),
      'Medium' => const PillBadge(
          label: 'Medium',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      'Low' => const PillBadge(
          label: 'Low',
          background: Color(0xFFDBEAFE),
          foreground: Color(0xFF1D4ED8),
        ),
      _ => PillBadge(label: s),
    };
  }

  static Widget securityEventStatus(String s) {
    return switch (s) {
      'Blocked' => const PillBadge(
          label: 'Blocked',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      'Mitigated' => const PillBadge(
          label: 'Mitigated',
          background: Color(0xFFDBEAFE),
          foreground: Color(0xFF1D4ED8),
        ),
      'Investigating' => const PillBadge(
          label: 'Investigating',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      _ => PillBadge(label: s),
    };
  }

  static Widget subscriptionStatus(String s) {
    return switch (s) {
      'Active' => const PillBadge(
          label: 'Active',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      'Trial' => const PillBadge(
          label: 'Trial',
          background: Color(0xFFDBEAFE),
          foreground: Color(0xFF1D4ED8),
        ),
      'Cancelled' => const PillBadge(
          label: 'Cancelled',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      _ => PillBadge(label: s),
    };
  }

  static Widget auditStatus(String s) {
    return switch (s) {
      'Success' => const PillBadge(
          label: 'Success',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      'Failed' => const PillBadge(
          label: 'Failed',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      'Active' => const PillBadge(
          label: 'Active',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFB91C1C),
        ),
      'Investigating' => const PillBadge(
          label: 'Investigating',
          background: Color(0xFFFEF9C3),
          foreground: Color(0xFFA16207),
        ),
      'Resolved' => const PillBadge(
          label: 'Resolved',
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF047857),
        ),
      _ => PillBadge(label: s),
    };
  }
}
