import 'package:e_concierge_tourism/controller/api/hotel_booking/room_details/room_details.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/room_details.dart';
import 'package:e_concierge_tourism/getx/count_of_guest.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/styles/colors.dart';
import '../../../../getx/room_controller.dart';

class RoomSelectOptions extends StatelessWidget {
  RoomSelectOptions({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.roomTypeIndex,
    required this.hotelId,
    required this.roomName,
    required this.roomId,
  });

  final double screenWidth;
  final double screenHeight;
  final int roomTypeIndex;
  final String hotelId;
  final String roomName;
  final int roomId;

  final RoomDetailController roomDetailController = Get.find();
  final CounterController counterController = Get.find();

  @override
  Widget build(BuildContext context) {
    final RoomsController roomController = Get.find<RoomsController>();
    final roomDetails = roomDetailController.roomTypeoptionPrice;

    if (roomDetails.isEmpty || roomDetails.length <= roomTypeIndex) {
      return Container();
    }

    final room = roomDetails[roomTypeIndex];
    final meal = roomDetailController.rooms[roomTypeIndex];

    // Convert prices to double safely
    final roomPrice = double.tryParse(room.priceperNight ?? '0') ?? 0.0;
    final priceWithBreakfast =
        double.tryParse(room.pricePerNightIncludebreakfast ?? '0') ?? 0.0;
    final priceWithDinner = double.tryParse(
            room.pricePerNightIncludebreakfastwithDinner?.toString() ?? '0') ??
        0.0;

    final priceWithLunch =
        double.tryParse(room.lunch?.toString() ?? '0') ?? 0.0;

    List<double> roomPrices = [roomPrice]; // Room Only
    List<String> mealss = ['']; // no meals
    List<int> mealsId = [0]; // meals id

    if (checkMeals('breakfast', meal.meals)) {
      final breakfastSum = (roomPrice + priceWithBreakfast).toStringAsFixed(2);
      final parsedSum = (double.parse(breakfastSum));
      roomPrices.add(parsedSum); // Room with Breakfast
      mealss.add('breakfast');
      mealsId.add(getMealId('breakfast', meal.meals));
    }
    if (checkMeals('dinner', meal.meals)) {
      final dinnerSum = (roomPrice + priceWithDinner).toStringAsFixed(2);
      final parsedSum = (double.parse(dinnerSum));
      roomPrices.add(parsedSum); // Room with Dinner
      mealss.add('dinner');
      mealsId.add(getMealId('dinner', meal.meals));
    }
    if (checkMeals('lunch', meal.meals)) {
      final lunchSum = (roomPrice + priceWithLunch).toStringAsFixed(2);
      final parsedSum = (double.parse(lunchSum));
      roomPrices.add(parsedSum); // Room with lunch
      mealss.add('lunch');
      mealsId.add(getMealId('lunch', meal.meals));
    }

    List<String> roomOptionNames = ['room_only'.tr];
    if (checkMeals('breakfast', meal.meals)) {
      roomOptionNames.add('Room with Breakfast'.tr);
    }
    if (checkMeals('dinner', meal.meals)) {
      roomOptionNames.add('room_with_breakfast_dinner'.tr);
    }
    if (checkMeals('lunch', meal.meals)) {
      roomOptionNames.add('room_with_lunch'.tr);
    }

    List<String> roomOptionDescription = ['no_meals_included'.tr];
    if (checkMeals('breakfast', meal.meals)) {
      roomOptionDescription.add('Room with Breakfast'.tr);
    }
    if (checkMeals('dinner', meal.meals)) {
      roomOptionDescription.add('room_with_breakfast_dinner'.tr);
    }
    if (checkMeals('lunch', meal.meals)) {
      roomOptionDescription.add('room_with_lunch'.tr);
    }

    //meals option

    List<Map<String, dynamic>> options =
        List.generate(roomPrices.length, (index) {
      return {
        'price': roomPrices[index].toString(),
        'description': roomOptionDescription[index],
        'name': roomOptionNames[index],
        'meal': mealss[index].isEmpty ? 'No Meals' : mealss[index],
        "mealId": mealsId[index],
      };
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.map((option) {
          final rm = RoomWithMeal(
              roomName: option['name'],
              price: option['price'],
              roomId: roomId,
              meal: option['meal'],
              mealTypeId: option['mealId']);

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option['name'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  '\u2022 ${option['description']}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                if (meal.refundInfo?.title != null)
                  Text(
                    '\u2022 ${meal.refundInfo?.title}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (option["price"] != null)
                          Text(
                            "${option['price']} OMR",
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Select the room option ensuring only one option per main room
                        roomController.selectOption(
                            roomName,
                            counterController.counters[0],
                            // option['description']!,
                            roomId,
                            option['price']!,
                            option['meal'],
                            option['mealId']);
                      },
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            color: getSelectedRooms(roomController, rm)
                                ? kBlue[50]
                                : null,
                            border: Border.all(color: kBlue),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              if (getSelectedRooms(roomController, rm))
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Selected".tr,
                                  style: const TextStyle(color: kBlue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1.0,
                  height: screenHeight * 0.02,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  bool checkMeals(String meal, List<Meal> meals) {
    return meals.any((element) => element.mealType == meal);
  }

  getMealId(String meal, List<Meal> meals) {
    int mealId = 0;
    for (var element in meals) {
      if (element.mealType == meal) {
        mealId = element.mealId;
      }
    }
    return mealId;
  }

  getSelectedRooms(RoomsController roomController, RoomWithMeal rm) {
    return roomController.roomsWithMeal.any((element) =>
        element.mealTypeId == rm.mealTypeId && element.roomId == rm.roomId);
  }
}
