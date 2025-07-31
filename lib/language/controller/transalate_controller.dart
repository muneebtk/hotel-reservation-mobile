import 'dart:ui';

import 'package:get/get.dart';

// class LanguageController extends GetxController {
//   var selectedLanguage = 'English'.obs;

//   void changeLanguage(String language) {
//     selectedLanguage.value = language;
//     if (language == 'Arabic') {
//       Get.updateLocale(const Locale('ar', 'SA'));
//     } else {
//       Get.updateLocale(const Locale('en', 'US'));
//     }
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  void changeLanguage(String language) async {
    selectedLanguage.value = language;
    await _saveLanguage(language);
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('selected_language');
    selectedLanguage.value = language!;
    if (language == 'Arabic') {
      Get.updateLocale(const Locale('ar'));
    } else {
      Get.updateLocale(const Locale('en'));
    }
  }

  Future<void> _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
    if (language == 'Arabic') {
      Get.updateLocale(const Locale('ar'));
    } else {
      Get.updateLocale(const Locale('en'));
    }
  }
}
