import 'package:get/get.dart';

//? language checking in main---------------------------------
class CategoryNameController extends GetxController {
  var categorieName = <String>[].obs;
  // var isLoading = false.obs;
  //var apicall = true.obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() async {
    await _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    //  isLoading.value = true;
    categorieName.value = ['hotel'.tr, 'chalets'.tr, 'entertainments'.tr];
    // isLoading.value = false;
  }

  void updateTranslations() {
    initialize();
  }
}
//? Home shimmer effect-----------------------------

//? settings page name controller ----------------------------------------

class SettingsNameController extends GetxController {
  var profilePageText = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTranslations();
  }

  void _loadTranslations() {
    profilePageText.value = [
      'bookings'.tr,
      "offers".tr,
      "favourites".tr,
      "wallets".tr,
      "notifications".tr,
      "Refer_and_Earn".tr,
      "settings".tr,
      "manage_account".tr
    ];
    update();
  }

  void updateTranslations() {
    _loadTranslations();
    update();
  }
}

//? chalet hotel name-----------------------------------------------------------

class ChaletHotelNameController extends GetxController {
  var chaletIncludedOptions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTranslationsChaletsIncluded();
  }

  void _loadTranslationsChaletsIncluded() {
    chaletIncludedOptions.value = [
      'Sort'.tr,
      'Filter'.tr,
    ];
    update();
  }

  void updateTranslations() {
    _loadTranslationsChaletsIncluded();
    update();
  }
}

// class ChaletNearbyController extends GetxController {
//   var chaletNearbyPlaces = <String>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _loadTranslations();
//   }

//   void _loadTranslations() {
//     chaletNearbyPlaces.value = ['masirah_island'.tr, 'nizwa'.tr, 'salalah'.tr];
//     update();
//   }

//   void updateTranslations() {
//     _loadTranslations();
//     update();
//   }
// }
