import 'package:get/get.dart';

class PropertyTypeController extends GetxController {
  var selectedPropertyType = 'FARM'.obs;
  var searchCityController = ''.obs;
  var cityId = ''.obs;
  void selectPropertyType(String type) {
    selectedPropertyType.value = type;
  }

  void selectCity(String type) {
    searchCityController.value = type;
  }
}
