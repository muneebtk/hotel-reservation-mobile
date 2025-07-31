import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/language/controller/transalate_controller.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/my_bookings/my_booking.dart';
import 'package:e_concierge_tourism/view/profile/pages/notification/controller/notification_controller.dart';
import 'package:e_concierge_tourism/view/profile/pages/wallet/wallets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPageProfile extends StatelessWidget {
  static const route = '/notificationPageProfile';
  NotificationPageProfile({
    super.key,
  });
  final NotificationController controller = Get.put(NotificationController());
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    controller.getNotifications();
    return Scaffold(
      appBar: MyAppBar(title: "Notification".tr),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          if (controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/emptyImage/nnotf.png"),
                  height15,
                  Text("There is no notification".tr),
                ],
              ),
            );
          }
          return ListView.separated(
              separatorBuilder: (context, index) => height10,
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notifi = controller.notifications[index];
                return GestureDetector(
                  onTap: () {
                    navigateTo(notifi.notificationType);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: kGrey[200],
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: CircleAvatar(
                          //     backgroundColor: Colors.green,
                          //     child: Icon(
                          //       Icons.done,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          buildTitle(notifi.notificationType),
                                          // "Booking Confirmed".tr,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      if (notifi.createdAt != null)
                                        Text(
                                          lastTimeFormat(
                                              notifi.createdAt!.toLocal()),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    languageController.selectedLanguage ==
                                            'English'.obs
                                        ? notifi.message ?? ''
                                        : notifi.messageArabic ?? '',
                                    style: const TextStyle(fontSize: 12.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }

  buildTitle(type) {
    if (type == 'deduct_money_from_wallet') {
      return 'Money deducted from wallet'.tr;
    } else if (type == 'booking_new') {
      return 'Booking Confirmed'.tr;
    } else if (type == 'add_money_to_wallet') {
      return 'Money added to wallet'.tr;
    } else if (type == 'booking_completed') {
      return 'Booking Completed'.tr;
    } else if (type == 'booking_cancel') {
      return 'Booking cancelled'.tr;
    } else if (type == 'booking_refund') {
      return 'Booking refund'.tr;
    } else {
      return 'Notification'.tr;
    }
  }

  navigateTo(type) {
    if (type == 'booking_cancel') {
      Get.to(() => const MyBookings(
            automaticallyImplyLeading: "ProfilePage",
            selectedTye: 'Cancelled',
          ));
    } else if (type == 'booking_new') {
      Get.to(() => const MyBookings(
            automaticallyImplyLeading: "ProfilePage",
            selectedTye: 'Upcoming',
          ));
    } else if (type == 'booking_completed') {
      Get.to(() => const MyBookings(
            automaticallyImplyLeading: "ProfilePage",
            selectedTye: 'Completed',
          ));
    } else if (type == 'deduct_money_from_wallet' ||
        type == 'add_money_to_wallet') {
      Get.to(() => const WalletsPage());
    }
  }
}
