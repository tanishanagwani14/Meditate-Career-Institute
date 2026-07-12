/// Formats a user-entered phone value for display on the OTP screen.
String formatPhoneForDisplay(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';

  if (trimmed.startsWith('+')) return trimmed;

  final digits = trimmed.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 10) {
    return '+91 ${digits.substring(0, 5)} ${digits.substring(5)}';
  }
  if (digits.length == 12 && digits.startsWith('91')) {
    final local = digits.substring(2);
    return '+91 ${local.substring(0, 5)} ${local.substring(5)}';
  }
  if (digits.isNotEmpty) return '+$digits';
  return trimmed;
}
