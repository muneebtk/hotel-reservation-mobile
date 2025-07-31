import 'package:get/get.dart';

import '../../language/controller/categorie_name_trans.dart';

Future<void> language() async {
  final CategoryNameController categoryController =
      Get.put(CategoryNameController());

  final SettingsNameController settingsController =
      Get.put(SettingsNameController());

  ChaletHotelNameController chaletHotelNameController =
      Get.put(ChaletHotelNameController());

  // ChaletNearbyController chaletNearbyController =
  //     Get.put(ChaletNearbyController());

  categoryController.updateTranslations();
  settingsController.updateTranslations();
  chaletHotelNameController.updateTranslations();
  //chaletNearbyController.updateTranslations();
}
