import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String bdt(dynamic date) {
    if (date == null) return '';
    final parsed = DateTime.tryParse('$date');
    if (parsed == null) return '$date';
    final bdtTime = parsed.toUtc().add(const Duration(hours: 6));
    return DateFormat('dd MMM, yyyy hh:mm a').format(bdtTime);
  }

  static String simple(dynamic date) {
    final parsed = DateTime.tryParse('$date');
    if (parsed == null) return '$date';
    return DateFormat('dd-MM-yyyy').format(parsed);
  }

  static String daysFromNow(dynamic date) {
    final parsed = DateTime.tryParse('$date');
    if (parsed == null) return '-';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(parsed.year, parsed.month, parsed.day);
    final diff = day.difference(today).inDays;
    if (diff == 0) return 'আজ';
    if (diff == 1) return 'আগামীকাল';
    return '$diff দিন';
  }
}
