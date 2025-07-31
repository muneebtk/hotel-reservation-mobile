import 'package:e_concierge_tourism/view/hotel_booking/reviewbooking/widgets/cancellation_policy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/styles/colors.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../constant/styles/textstyle.dart';
import '../../../../getx/booking_refund_options.dart';

class RefundCancellationPolicy extends StatelessWidget {
  final String? check;
  final List<String> cancellationPolicy;
  const RefundCancellationPolicy({super.key, this.check, required this.cancellationPolicy});

  @override
  Widget build(BuildContext context) {
    BookingRefundOptions controller = Get.put(BookingRefundOptions());
    List<String> options = [
      "get_full_fare_refund_on_cancellation".tr,
      "get_full_fare_refund_on_cancellation_extra_charges".tr,
      "no_free_cancellation".tr
    ];
    return Obx(
      () => Card(
        color: kWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.06,
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Text(
                "Refund and Cancellation".tr,
                style: textBoldblack.copyWith(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: options[0],
                        groupValue: controller.currentOption.value,
                        onChanged: (value) {
                          controller.changeOption(value.toString());
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: options[0],
                                style: const TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text:
                                    "applicable_only_before_last_2_days_of_visit"
                                        .tr,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  height10,
                  Row(
                    children: [
                      Radio(
                        value: options[1],
                        groupValue: controller.currentOption.value,
                        onChanged: (value) {
                          controller.changeOption(value.toString());
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: options[1],
                                style: const TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: "cancel_anytime".tr,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: options[2],
                        groupValue: controller.currentOption.value,
                        onChanged: (value) {
                          controller.changeOption(value.toString());
                        },
                      ),
                      Text(options[2]),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: () {
                        Get.to( CancellationPolicyPage(cancellationPolicy: cancellationPolicy,));
                      },
                      child: Text(
                        "cancellation_policy".tr,
                        style: const TextStyle(
                            color: kBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
