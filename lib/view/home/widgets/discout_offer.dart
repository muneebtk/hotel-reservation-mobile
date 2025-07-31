import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constant/styles/sizedbox.dart';

class DiscountOffer extends StatelessWidget {
  final String discountPercentage;
  final String discounPercentage2;
  final String discountCondition;
  final String? promocode;

  const DiscountOffer(
      {super.key,
      required this.discountPercentage,
      required this.discounPercentage2,
      required this.discountCondition,
      this.promocode});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      //elevation: 1,
      // color: kWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
          color: Theme.of(context).brightness == Brightness.dark
              ? null // removes color if in dark theme
              : const Color(0xFFEDF0F9),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Container(
                height: 80,
                width: screenWidth / 5,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                  "assets/images/Group 633183.png",
                ))),
                child: Transform.rotate(
                  angle: -15.5 * (2.14159 / 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 11),
                        child: Text(
                          "up_to".tr,
                          style: textBoldwhite.copyWith(fontSize: 6),
                        ),
                      ),
                      Center(
                          child: Text(
                        "$discountPercentage % off",
                        style: textBoldwhite.copyWith(fontSize: 7),
                      )),
                    ],
                  ),
                ),
              ),
              width10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Up to $discounPercentage2 % Off'.tr,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxHeight: 100, maxWidth: 200),
                    child: Text(
                      discountCondition,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 136, 137, 141),
                      ),
                    ),
                  ),
                  height10,
                  if (promocode?.isNotEmpty ?? false)
                    InkWell(
                      onTap: () {
                        copyToClipBoard(promocode);
                      },
                      child: Text(
                        'collect'.tr,
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
