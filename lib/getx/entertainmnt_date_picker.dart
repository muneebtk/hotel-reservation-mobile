import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatePickerControllerEntertainment extends GetxController {
  final selectedDate = DateTime.now().obs;

  final DateFormat _dateFormat = DateFormat('dd, MMM, yyyy');
  final DateFormat _dateFormatReverse = DateFormat('yyyy-MM-dd');

  final DateFormat _timeFormat = DateFormat('hh:mm a');
  final checkInTime = const TimeOfDay(hour: 10, minute: 0).obs;
  // final checkOutTime = const TimeOfDay(hour: 12, minute: 0).obs;

  void updateSelectedDate(DateTime date) {
    selectedDate(date);
  }

  String getFormattedDate(DateTime date) {
    return _dateFormat.format(date);
  }

  String getFormattedDateReverse(DateTime date) {
    return _dateFormatReverse.format(date);
  }

  String getFormattedTime(TimeOfDay time) {
    final dateTime = DateTime(0, 0, 0, time.hour, time.minute);
    return _timeFormat.format(dateTime);
  }
}
