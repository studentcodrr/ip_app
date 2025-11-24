import 'package:intl/intl.dart';

class AppDateFormatter {
  static final DateFormat _shortFormat = DateFormat('MMM d');

  static String shortDate(DateTime date) {
    return _shortFormat.format(date);
  }
}