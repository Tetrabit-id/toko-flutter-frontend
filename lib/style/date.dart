import 'package:intl/intl.dart';

String dateNow = DateFormat('EEEE, d MMMM y').format(DateTime.now());

String dateFormat(String date) {
  return DateFormat('EEEE, d MMMM y').format(DateTime.parse(date));
}
