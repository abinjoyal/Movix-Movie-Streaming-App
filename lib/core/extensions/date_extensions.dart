/// Extension methods on [DateTime].
extension DateTimeExtensions on DateTime {
  /// Returns year as string.
  String get yearString => year.toString();

  /// Formats date into readable string e.g. 'Oct 24, 2024'.
  String toReadableDate() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final monthStr = months[month - 1];
    return '$monthStr $day, $year';
  }
}

