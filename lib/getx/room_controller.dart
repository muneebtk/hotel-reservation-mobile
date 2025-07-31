import 'package:e_concierge_tourism/controller/api/hotel_booking/room_details/room_details.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';
import 'package:get/get.dart';

class RoomsController extends GetxController {
  //!-------------------------------------------------------------------------
  // RxList<int> selectedIndexes = <int>[].obs;
  // RxList<String> roomNameList = <String>[].obs;
  // RxMap<int, String> roomIndexMap = <int, String>{}.obs;
  // RxList<String> roomDescriptionList = <String>[].obs;
  // RxMap<int, String> roomDescriptionMapIndex = <int, String>{}.obs;
  // RxList<int> roomIdList = <int>[].obs;
  // RxList<int> roomOptionNameIDList = <int>[].obs;
  // RxList<String> roomTypesPrice = <String>[].obs;
  // RxMap<int, String> roomTypesPriceMap = <int, String>{}.obs;
  RxList<RoomWithMeal> roomsWithMeal = <RoomWithMeal>[].obs;
  final RoomDetailController roomdetailController = Get.find();

  //!-------------------------------------------------------------------------

  // bool isSelected(int index) => selectedIndexes.contains(index);

  void selectOption(
      String roomName,
      int roomCount,
      // String roomDescription,
      int roomId,
      String roomTypePrices,
      String meals,
      int mealId) {
    // int roomTypeIndex = index ~/ 3;
    // if (roomsWithMeal.any((element) => element.roomId == roomId)) {
    // for (var element in List.from(roomsWithMeal)) {
    // if (element.roomId == roomId && element.mealTypeId != mealId) {
    // roomsWithMeal.remove(element);
    // roomsWithMeal.clear();
    if (roomsWithMeal.isNotEmpty) {
      if (roomsWithMeal.first.roomId == roomId &&
          roomsWithMeal.first.mealTypeId == mealId) {
        roomsWithMeal.clear();
      } else {
        roomsWithMeal.clear();
        roomsWithMeal.add(RoomWithMeal(
            roomId: roomId,
            meal: meals,
            mealTypeId: mealId,
            roomName: roomName,
            price: roomTypePrices));
      }
    } else {
      roomsWithMeal.add(RoomWithMeal(
          roomId: roomId,
          meal: meals,
          mealTypeId: mealId,
          roomName: roomName,
          price: roomTypePrices));
    }

    // final availableRoom = roomdetailController.availableRooms[roomName];
    // print('availableRooms $availableRoom roomcount $roomCount');
    // print(roomCount > 1 && availableRoom.isNotEmpty);
    // if (roomCount > 1 && availableRoom.isNotEmpty) {
    // for (var i = 0; i < availableRoom.length; i++) {
    //   if (availableRoom[i] != roomId) {
    //     roomsWithMeal.add(RoomWithMeal(
    //         roomId: availableRoom[i],
    //         meal: meals,
    //         mealTypeId: mealId,
    //         roomName: roomName,
    //         price: roomTypePrices));
    //   // }
    //   if (roomCount == roomsWithMeal.length) break;
    // }
    // }

    // } else if (element.roomId == roomId) {
    // roomsWithMeal.removeWhere((element) => element.roomId == roomId);
    // }
    // }
    // }
    // else {
    //   roomsWithMeal.add(RoomWithMeal(
    //       roomId: roomId,
    //       meal: meals,
    //       mealTypeId: mealId,
    //       roomName: roomName,
    //       price: roomTypePrices));
    // }
    // if (
    //     // selectedIndexes.contains(index) &&
    //     roomNameList.contains(roomName) &&
    //         roomDescriptionList.contains(roomDescription) &&
    //         roomTypesPrice.contains(roomTypePrices)) {
    //   // selectedIndexes.remove(index);
    //   roomNameList.remove(roomName);
    //   roomTypesPrice.remove(roomTypePrices);
    //   roomTypesPriceMap.remove(index);

    //   roomDescriptionList.remove(roomDescription);
    //   roomDescriptionMapIndex.remove(index);
    //   roomIndexMap.remove(index);
    //   roomIdList.remove(roomId);
    //   // roomOptionNameIDList.remove(roomoptionNameID);

    //   roomsWithMeal.removeWhere((element) =>
    //       element.mealTypeId == mealId && element.roomId == roomId);
    //   roomsWithMeal.remove(
    //       RoomWithMeal(roomId: roomId, meal: meals, mealTypeId: mealId));
    // } else {
    //   roomsWithMeal.removeWhere((element) => element.roomId == roomId);
    //   if (roomIdList.contains(roomId)) {
    //     roomsWithMeal
    //         .add(RoomWithMeal(roomId: roomId, meal: meals, mealTypeId: mealId));
    //     // selectedIndexes.removeWhere((selectedIndex) => selectedIndex == index);
    //   }
    //   print('index $index');

    //   roomIndexMap.removeWhere((key, value) => key == index);
    //   roomNameList.clear();
    //   roomNameList.addAll(roomIndexMap.values);

    //   roomTypesPriceMap.removeWhere((key, value) => key == index);
    //   roomTypesPrice.clear();
    //   roomTypesPrice.addAll(roomTypesPriceMap.values);

    //   roomDescriptionMapIndex.removeWhere((key, value) => key == index);
    //   roomDescriptionList.clear();
    //   roomDescriptionList.addAll(roomDescriptionMapIndex.values);

    //   // selectedIndexes.add(index);
    //   roomIndexMap[index] = roomName;
    //   roomNameList.clear();
    //   roomNameList.addAll(roomIndexMap.values);
    //   print(roomIndexMap.values);
    //   roomTypesPriceMap[index] = roomTypePrices;
    //   roomTypesPrice.clear();
    //   roomTypesPrice.addAll(roomTypesPriceMap.values);

    //   roomDescriptionMapIndex[index] = roomDescription;
    //   roomDescriptionList.clear();
    //   roomDescriptionList.addAll(roomDescriptionMapIndex.values);

    //   if (!roomIdList.contains(roomId)) {
    //     roomIdList.add(roomId);
    //     roomsWithMeal
    //         .add(RoomWithMeal(roomId: roomId, meal: meals, mealTypeId: mealId));
    //   }

    //   // if (!roomOptionNameIDList.contains(roomoptionNameID)) {
    //   //   roomOptionNameIDList.add(roomoptionNameID);
    //   // }
    // }
    // print(selectedIndexes);
  }
}
