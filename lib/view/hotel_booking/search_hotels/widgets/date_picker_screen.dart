import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../getx/date_picker_controller.dart';
import 'checkin_checkout.dart';
import 'time_picker.dart';

class DatePickerScreen extends StatelessWidget {
  DatePickerScreen({super.key});

  final DatePickerController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: MyAppBar(title: "Calendar".tr),
        body: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "checkin".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  )),
                  Expanded(
                      child: Text(
                    "checkout".tr,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  )),
                ],
              ),
              height15,
              Row(
                children: [
                  Obx(() => CheckInCheckout(
                        text: "date".tr,
                        date: controller.getFormattedDate(
                            controller.selectedStartDate.value),
                        onTap: () {},
                      )),
                  width10,
                  Obx(() => CheckInCheckout(
                        text: "date".tr,
                        date: controller
                            .getFormattedDate(controller.selectedEndDate.value),
                        onTap: () {},
                      )),
                  const SizedBox(width: 10),
                ],
              ),
              height10,
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => TimePicker(
                            time: controller
                                .getFormattedTime(controller.checkInTime.value),
                            showTimeOnTap: () {
                              selectTime(context, true);
                            },
                          ),
                        ),
                      ),
                      width10,
                      Expanded(
                        child: Obx(
                          () => TimePicker(
                            time: controller.getFormattedTime(
                                controller.checkOutTime.value),
                            showTimeOnTap: () {
                              selectTime(context, false);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              height20,
              Expanded(
                child: SfDateRangePicker(
                  minDate: DateTime.now(),
                  headerStyle: const DateRangePickerHeaderStyle(
                      backgroundColor: kWhite, textAlign: TextAlign.center),
                  selectionShape: DateRangePickerSelectionShape.circle,
                  enableMultiView: false,
                  navigationMode: DateRangePickerNavigationMode.scroll,
                  navigationDirection:
                      DateRangePickerNavigationDirection.vertical,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    if (args.value is PickerDateRange) {
                      controller.selecedRange = args.value;
                    }
                  },
                  backgroundColor: kGrey[50],
                  rangeSelectionColor: kBlue[100],
                  startRangeSelectionColor: kBlue,
                  endRangeSelectionColor: kBlue,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                    controller.selectedStartDate.value,
                    controller.selectedEndDate.value,
                  ),
                  allowViewNavigation: true,
                  view: DateRangePickerView.month,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
          child: ButtonWidget(
            text: Text(
              "confirm".tr,
              style: textColorwhite,
            ),
            ontap: () {
              DateTime today = DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day);

              if (controller.selectedStartDate.value.isBefore(today) ||
                  controller.selectedEndDate.value.isBefore(today)) {
                Get.snackbar(
                  'Invalid Date Selection'.tr,
                  'Dates cannot be in the past'.tr,
                );
              } else if (controller.selectedStartDate.value
                  .isAfter(controller.selectedEndDate.value)) {
                Get.snackbar(
                  'Invalid Date Range'.tr,
                  'Please select a valid date range',
                );
              } else if (controller.selectedStartDate.value
                  .isAtSameMomentAs(controller.selectedEndDate.value)) {
                Get.snackbar(
                  'Invalid Date Selection'.tr,
                  'Check-out date must be after Check-in date'.tr,
                );
              } else {
                final range = controller.selecedRange;
                if (range?.startDate != null &&
                    range?.endDate != null &&
                    range?.startDate != range?.endDate) {
                  controller.validateAndUpdateDates();
                  Get.closeCurrentSnackbar();
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar('Invalid Date Selection'.tr,
                      'Check-out date must be after Check-in date'.tr,
                      isDismissible: true);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> selectTime(BuildContext context, bool isCheckIn) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isCheckIn
          ? controller.checkInTime.value
          : controller.checkOutTime.value,
    );
    if (pickedTime != null) {
      if (isCheckIn) {
        controller.checkInTime.value = pickedTime;
      } else {
        controller.checkOutTime.value = pickedTime;
      }
    }
  }
}
