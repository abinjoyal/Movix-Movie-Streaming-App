/// Formatting utilities for movie metadata and numbers.
class Formatters {
  Formatters._();

  /// Formats minutes into 'Xh Ym' (e.g. 135 -> '2h 15m').
  static String formatRuntime(int? minutes) {
    if (minutes == null || minutes <= 0) return 'N/A';
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) return '${remainingMinutes}m';
    if (remainingMinutes == 0) return '${hours}h';
    return '${hours}h ${remainingMinutes}m';
  }

  /// Formats a vote average to single decimal string (e.g. 7.84 -> '7.8').
  static String formatVoteAverage(double? vote) {
    if (vote == null || vote <= 0) return '0.0';
    return vote.toStringAsFixed(1);
  }

  /// Formats large numbers with suffixes (e.g. 14200 -> '14.2k').
  static String formatVoteCount(int? count) {
    if (count == null || count <= 0) return '0';
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  /// Extracts year from date string (e.g. '2023-12-15' -> '2023').
  static String extractYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    final parts = dateString.split('-');
    return parts.isNotEmpty ? parts[0] : 'N/A';
  }

  /// Formats currency amounts in USD (e.g. 120000000 -> '\$120M').
  static String formatCurrency(int? amount) {
    if (amount == null || amount <= 0) return 'N/A';
    if (amount >= 1000000000) {
      return '\$${(amount / 1000000000).toStringAsFixed(1)}B';
    }
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    }
    return '\$$amount';
  }
}

