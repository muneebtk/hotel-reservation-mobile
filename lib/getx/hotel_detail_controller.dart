import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HotelDetailController extends GetxController {
  RxInt currentPage = 0.obs;
  GoogleMapController? googleMapController;

  void updatePage(int index) {
    currentPage.value = index;
  }

  void setGoogleMapController(GoogleMapController controller) {
    googleMapController = controller;
  }
}

class ChaletDetailController extends GetxController {
  RxInt currentPage = 0.obs;

  void updatePage(int index) {
    currentPage.value = index;
  }
}
