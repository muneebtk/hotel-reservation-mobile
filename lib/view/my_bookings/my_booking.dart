import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import '../../constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/view/my_bookings/cancelled/cancelled.dart';
import 'package:e_concierge_tourism/view/my_bookings/completed/completed_booking.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/upcoming_bookings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBookings extends StatefulWidget {
  final String automaticallyImplyLeading;
  final String selectedTye;

  const MyBookings({
    super.key,
    required this.automaticallyImplyLeading,
    required this.selectedTye,
  });

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  RxString selectedOption = 'Upcoming'.tr.obs;

  @override
  void initState() {
    selectedOption.value = widget.selectedTye.tr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "My Bookings".tr,
        automaticallyImplyLeadingANDROID:
            widget.automaticallyImplyLeading == "ProfilePage" ? true : false,
      ),
      body: Column(
        children: [
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              bookingOption('Upcoming'.tr),
              width15,
              bookingOption('Completed'.tr),
              width15,
              bookingOption('Cancelled'.tr),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: getContentForOption(),
          ),
        ],
      ),
    );
  }

  Widget bookingOption(String option) {
    return GestureDetector(
      onTap: () {
        selectedOption.value = option;
      },
      child: Obx(() => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: darkRed),
              color:
                  selectedOption.value == option ? darkRed : Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                option,
                style: TextStyle(
                    color: selectedOption.value == option ? kWhite : darkRed),
              ),
            ),
          )),
    );
  }

  Widget getContentForOption() {
    return Obx(() {
      if (selectedOption.value == "Upcoming".tr) {
        return const UpComingBookings();
      } else if (selectedOption.value == "Completed".tr) {
        return const MyBookingsSuccess();
      } else if (selectedOption.value == "Cancelled".tr) {
        return const Cancelled();
      }
      // switch (selectedOption.value) {
      //   case 'Upcoming':
      //   case 'Completed':
      //     return const MyBookingsSuccess();
      //   case 'Cancelled':
      //     return const Cancelled();
      //   default:
      //     return const SizedBox.shrink();
      // }
      return const SizedBox.shrink();
    });
  }
}
