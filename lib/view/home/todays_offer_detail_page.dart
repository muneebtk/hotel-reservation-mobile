import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/utils/date_time.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TodaysOfferDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String propertyName;
  final String startDate;
  final String endDate;
  final String code;
  final String? discounPercentage;
  final String? type;
  final num? minSpend;

  const TodaysOfferDetailPage(
      {super.key,
      required this.title,
      required this.description,
      required this.propertyName,
      required this.startDate,
      required this.endDate,
      required this.code,
      required this.discounPercentage,
      required this.type,
      required this.minSpend});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: type == 'common'
          ? null
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: ButtonWidget(
                  ontap: () {
                    Get.back();
                    copyToClipBoard(code);
                    // showAnimatedSnackBar(
                    //     'Great!, you are redeemed this offer', kBlack);
                  },
                  text: Text(
                    'Redeem Now'.tr,
                    style: const TextStyle(color: kWhite),
                  )),
            ),
      appBar: MyAppBar(title: title.tr),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title ${discounPercentage != null ? '- $discounPercentage% Off' : ''}'
                  .tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            height5,
            Text(
              description.tr,
              style: const TextStyle(fontSize: 12),
            ),
            height20,
            // Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Colors.black12,
            //       ),
            //       borderRadius: const BorderRadius.all(Radius.circular(10))),
            //   child: Padding(
            //     padding: const EdgeInsets.all(7.0),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               'Hotel name'.tr,
            //               style: const TextStyle(fontSize: 12),
            //             ),
            //             height5,
            //             Text(
            //               'Valid'.tr,
            //               style: const TextStyle(fontSize: 12),
            //             ),
            //             height5,
            //             Text(
            //               'Room types'.tr,
            //               style: const TextStyle(fontSize: 12),
            //             ),
            //             height5,
            //             Text(
            //               'Minimum Stay'.tr,
            //               style: const TextStyle(fontSize: 12),
            //             ),
            //             height5,
            //             Text(
            //               'Booking Window'.tr,
            //               style: const TextStyle(fontSize: 12),
            //             ),
            //             height5,
            //             Text(
            //               'Cancellation'.tr,
            //               style: const TextStyle(fontSize: 12),
            //             )
            //           ],
            //         ),
            //         width25,
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               height10,
            //               Text(
            //                 propertyName.tr,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //               height5,
            //               Text(
            //                 '$startDate - $endDate'.tr,
            //                 style: const TextStyle(fontSize: 12),
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //               height5,
            //               Text(
            //                 'Deluxe'.tr,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //               height5,
            //               Text(
            //                 '2 nights'.tr,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //               height5,
            //               Text(
            //                 'Must book 7 days in advance'.tr,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //               height5,
            //               Text(
            //                 'Free up to 48 hours before check-in'.tr,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //             ],
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            // height30,
            // width10,
            if (type == 'common')
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 168, 16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Common Promotion',
                  style: TextStyle(
                      fontSize: 12, color: kWhite, fontWeight: FontWeight.w500),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Terms & condition".tr,
                    style: const TextStyle(fontSize: 15),
                  ),
                  height10,
                  Text(
                    'The offer is non-transferable and cannot be combined with other promotions, discounts, or offers.'
                        .tr,
                    style: const TextStyle(fontSize: 12),
                  ),
                  if (startDate.isNotEmpty && endDate.isNotEmpty) ...[
                    height5,
                    Text(
                      'The offer is valid from ${dateTimeFormat(startDate, format: 'dd/MM/y')} to ${dateTimeFormat(endDate, format: 'dd/MM/y')}.'
                          .tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                  if (minSpend != null) ...[
                    height5,
                    Text(
                      'This offer is valid only for bookings with a minimum spend amount ${minSpend!.toStringAsFixed(2)} OMR.'
                          .tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                  height5,
                  Text(
                    'The offer is subject to availability and is valid on a first-come, first-served basis.'
                        .tr,
                    style: const TextStyle(fontSize: 12),
                  ),
                  height5,
                  Text(
                    '1929 Way Plus reserves the right to extend, modify, or terminate the offer without prior notice.'
                        .tr,
                    style: const TextStyle(fontSize: 12),
                  ),
                  height5,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
