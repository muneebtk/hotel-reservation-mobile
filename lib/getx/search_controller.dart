import 'package:get/get.dart';

class SearchControllerHotel extends GetxController {
  RxString selectedOption = "city".tr.obs;

  void updateSelectedOption(String newValue) {
    selectedOption.value = newValue;
  }
}
