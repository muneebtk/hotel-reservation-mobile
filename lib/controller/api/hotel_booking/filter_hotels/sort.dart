import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortByController extends GetxController {
  final List<String> sortListNames = [
    "Recommended".tr,
    "Lowest Price".tr,
    "Highest Price".tr,
    "Hotel Star Rating".tr,
    // "Stars (5 to 0)".tr,
  ];
  final List<Widget> sortListIcons = [
    const Icon(
      Icons.thumb_up_off_alt,
      size: 12,
    ), // Icon 1
    Image.asset('assets/images/ion_pricetag-outline.png'), // Image 1
    Image.asset(
      'assets/images/ion_pricetag-outline.png',
    ), // Image 2
    const Icon(
      Icons.star_outline,
      size: 12,
    ), // Icon 2
  ];

  // final List<IconData> sortListIcons = [
  //   Icons.thumb_up_off_alt,
  //   Icons.attach_money,
  //   Icons.money_off,
  //   Icons.star_rate_outlined,
  //   // Icons.star_border,
  // ];

  var selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  String getSelectedSort() {
    return sortListNames[selectedIndex.value];
  }
}

//*CHALET=============================================================
class SortByControllerChalet extends GetxController {
  final List<String> sortListNames = [
    "Recommended".tr,
    "Lowest Price".tr,
    "Highest Price".tr,
    "Chalet Star Rating".tr,
  ];

  final List<IconData> sortListIcons = [
    Icons.star,
    Icons.attach_money,
    Icons.money_off,
    Icons.star_rate,
  ];

  var selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  String getSelectedSort() {
    return sortListNames[selectedIndex.value];
  }
}
