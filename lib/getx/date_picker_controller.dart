import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePickerController extends GetxController {
  final selectedStartDate = DateTime.now().obs;
  final selectedEndDate = DateTime.now().add(const Duration(days: 1)).obs;
  PickerDateRange? selecedRange;

  final DateFormat _dateFormat = DateFormat('dd, MMM, yyyy');
  final DateFormat _dateFormatReverse = DateFormat('yyyy-MM-dd');

  final DateFormat _timeFormat = DateFormat('hh:mm a');
  final checkInTime = const TimeOfDay(hour: 10, minute: 0).obs;
  final checkOutTime = const TimeOfDay(hour: 12, minute: 0).obs;

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

  void validateAndUpdateDates() {
    final range = selecedRange;
    if (range != null) {
      if (range.startDate != null) {
        if (range.endDate == null) {
          selectedStartDate.value = range.startDate!;
          selectedEndDate.value = range.startDate!;
        } else if (range.startDate!.isAfter(range.endDate!)) {
          Get.snackbar(
              'Error'.tr, 'Check-in date cannot be after check-out date'.tr,
              snackPosition: SnackPosition.TOP);
        } else if (range.startDate == range.endDate) {
          Get.snackbar(
              'Error'.tr, 'Check-in and check-out dates cannot be the same'.tr,
              snackPosition: SnackPosition.TOP);
        } else {
          selectedStartDate.value = range.startDate!;
          selectedEndDate.value = range.endDate!;
        }
      }
    }
  }

  void validateDates() {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (selectedStartDate.value.isBefore(today)) {
      selectedStartDate.value = today;
    }
    if (selectedEndDate.value.isBefore(today)) {
      selectedEndDate.value = today.add(const Duration(days: 1));
    }
    if (selectedStartDate.value.isAfter(selectedEndDate.value)) {
      selectedEndDate.value =
          selectedStartDate.value.add(const Duration(days: 1));
    }
  }
}
