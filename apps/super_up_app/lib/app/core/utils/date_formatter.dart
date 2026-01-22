import 'package:intl/intl.dart';

class DateFormatter {
  static String formatRelativeTime(DateTime dateTime, {String locale = 'fr'}) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'à l\'instant';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'il y a $minutes minute${minutes > 1 ? 's' : ''}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'il y a $hours heure${hours > 1 ? 's' : ''}';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'il y a $days jour${days > 1 ? 's' : ''}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'il y a $months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'il y a $years an${years > 1 ? 's' : ''}';
    }
  }

  static String formatRelativeDate(DateTime dateTime, {String locale = 'fr'}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final announcementDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = now.difference(dateTime);

    if (announcementDate == today) {
      return 'Aujourd\'hui';
    } else if (announcementDate == yesterday) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', locale).format(dateTime);
    } else {
      return DateFormat('dd MMM yyyy', locale).format(dateTime);
    }
  }
}
