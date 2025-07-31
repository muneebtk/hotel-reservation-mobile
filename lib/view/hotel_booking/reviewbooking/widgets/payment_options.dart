import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/controller/model/payment_methods_accepted/payment_method_accepted_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/styles/colors.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../constant/styles/textstyle.dart';
import '../../../../getx/booking_refund_options.dart';

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key, required this.acceptedPayments});
  final List<AcceptedPayments> acceptedPayments;

  @override
  Widget build(BuildContext context) {
    // PaymentOptionsBooking controller = Get.find();
    // List<String> options = [
    //   "Pay Online\n".tr,
    //   "Pay Offline\n".tr,
    //   // "no_free_cancellation".tr
    // ];
    return Card(
      color: kWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
            child: Row(
              children: [
                Text(
                  "Payment Methods Accepted".tr,
                  style: textBoldblack.copyWith(fontSize: 16),
                ),
                // const Spacer(),
                // GestureDetector(
                //   onTapDown: (TapDownDetails details) {
                //     _showTooltip(context, details.globalPosition);
                //   },
                //   child: const Icon(Icons.info, size: 40, color: Colors.blue),
                // ),
              ],
            ),
          ),
          height10,
          ...List.generate(
            acceptedPayments.length,
            (index) => Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, size: 5, color: kBlack),
                      width10,
                      Text(acceptedPayments[index].category ?? ''),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 18),
                  //   child: Text(
                  //     // capitalizeFirstLetter(
                  //     //     acceptedPayments[index].isRefundable ?? ''),
                  //     style: TextStyle(
                  //         fontSize: 12,
                  //         color: acceptedPayments[index].isRefundable ==
                  //                 'refundable'.tr
                  //             ? kGreen
                  //             : kRed),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          height10,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline),
                width10,
                Expanded(child: Text('payment_info'.tr)),
              ],
            ),
          ),
          height10,
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: [
          //           Radio(
          //             value: options[0],
          //             groupValue: controller.currentOptions.value.tr,
          //             onChanged: (value) {
          //               controller.changePaymentOption(value.toString());
          //               //controller.currentOptions(value.toString());
          //             },
          //           ),
          //           Expanded(
          //             child: RichText(
          //               text: TextSpan(
          //                 children: [
          //                   TextSpan(
          //                     text: options[0],
          //                     style: const TextStyle(color: Colors.black),
          //                   ),
          //                   TextSpan(
          //                     text: "Card Available".tr,
          //                     style: const TextStyle(color: Colors.green),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       height10,
          //       Row(
          //         children: [
          //           Radio(
          //             value: options[1],
          //             groupValue: controller.currentOptions.value,
          //             onChanged: (value) {
          //               controller.changePaymentOption(value.toString());
          //             },
          //           ),
          //           Expanded(
          //             child: RichText(
          //               text: TextSpan(
          //                 children: [
          //                   TextSpan(
          //                     text: options[1],
          //                     style: const TextStyle(color: Colors.black),
          //                   ),
          //                   const WidgetSpan(
          //                     child: SizedBox(height: 4),
          //                   ),
          //                   TextSpan(
          //                     text:
          //                         "Pay offline for the booking, with the remaining balance due upon arrival at the hotel.\n"
          //                             .tr,
          //                     style: const TextStyle(
          //                         color: Color.fromARGB(255, 40, 40, 40),
          //                         fontSize: 11),
          //                   ),
          //                   const WidgetSpan(
          //                     child: SizedBox(height: 4),
          //                   ),
          //                   TextSpan(
          //                     text: "Non Refundable".tr,
          //                     style: const TextStyle(
          //                         color: Colors.red, fontSize: 13),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
