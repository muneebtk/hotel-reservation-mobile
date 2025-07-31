import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/styles/colors.dart';
import '../../constant/styles/textstyle.dart';

class BottomButtomHotelDetailsPage extends StatelessWidget {
  final String price;
  final VoidCallback ontap;
  final String buttonname;
  final shape;

  const BottomButtomHotelDetailsPage({
    super.key,
    required this.price,
    required this.ontap,
    required this.buttonname,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            price,
            style: textBoldblack.copyWith(fontSize: 21),
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: shape,
                backgroundColor: const WidgetStatePropertyAll(darkRed)),
            onPressed: ontap,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14, top: 14),
              child: Text(
                buttonname.tr,
                style: const TextStyle(color: kWhite, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
