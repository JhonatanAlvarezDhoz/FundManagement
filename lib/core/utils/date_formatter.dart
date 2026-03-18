import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy HH:mm');

  static String dateTime(DateTime date) => _dateTime.format(date);
}
