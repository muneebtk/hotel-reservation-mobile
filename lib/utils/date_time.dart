import 'package:intl/intl.dart';

String dateTimeFormat(String? dateTime, {String format = 'dd MMM, EEE'}) {
  final date = dateTime == null ? null : DateTime.parse(dateTime).toLocal();
  try {
    if (date != null) {
      return DateFormat(format).format(date);
    }
  } catch (e) {
    return '';
  }
  return '';
}
