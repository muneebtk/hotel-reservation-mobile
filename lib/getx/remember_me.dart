import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Rem extends GetxController {
  @override
  void onInit() {
    super.onInit();
    ss();
  }

  final RxString email = ''.obs;
  final RxString pass = ''.obs;
  void ss() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    email.value = pref.getString('email') ?? "";
    pass.value = pref.getString('password_login') ?? "";
  }
}

//!----------------------------------------------------------------------------------------------------------
class EmailForProfile extends GetxController {
  final RxString email = ''.obs;
  final RxString userName = ''.obs;
  final RxString userNameFirstLetter = ''.obs;
  final RxString lastName = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxString firstname = ''.obs;
  final RxString lastName1 = ''.obs;
  @override
  void onInit() {
    super.onInit();
    loadEmailProfile();
  }

  void loadEmailProfile() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    email.value = pref.getString('email_for_profile') ?? "";
    phoneNumber.value = pref.getString('number') ?? "";
    String extractedUserName = "";
    if (email.value.isNotEmpty) {
      for (int i = 0; i < email.value.length; i++) {
        if (email.value[i] == "@") {
          break;
        }
        extractedUserName += email.value[i];
      }
      userName.value = extractedUserName;
      userNameFirstLetter.value =
          extractedUserName.isNotEmpty ? extractedUserName[0] : "";

      final int ss = userName.value.length;
      lastName.value = userName.value[ss - 1];
      firstname.value = pref.getString('first_name') ?? "";
      lastName1.value = pref.getString('last_name') ?? "";
    }
    update();
  }
}
