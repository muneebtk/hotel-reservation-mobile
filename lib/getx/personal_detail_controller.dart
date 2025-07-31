import 'package:get/get.dart';

//? used this controller Hotel booking and chalet booking personal detail screen-------------------
class PersonalDetailController extends GetxController {
  var currentOption = "Myself".obs;
  var selectedValue = 'Mr'.obs;

  void changeOption(String newOption) {
    currentOption.value = newOption;
  }

  void setSelectedValue(String value) {
    selectedValue.value = value;
  }
}
