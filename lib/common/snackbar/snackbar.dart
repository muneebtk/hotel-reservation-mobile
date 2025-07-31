import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../constant/styles/colors.dart';

void snackbar(String title, String message) {
  Get.snackbar(title, message, colorText: kWhite, backgroundColor: darkRed);
}
