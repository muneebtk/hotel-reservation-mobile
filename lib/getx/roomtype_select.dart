import 'package:get/get.dart';

class RoomTypeController extends GetxController {
  var selectRoomType = 'Room Type'.tr.obs;
  void selectPropertyType(String type) {
    selectRoomType.value = type;
  }
}
