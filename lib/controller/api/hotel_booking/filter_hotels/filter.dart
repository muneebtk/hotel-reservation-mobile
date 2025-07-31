import 'package:get/get.dart';

import '../../chalets_booking/chalet_list_and_detail/chalet_search_api.dart';

class FilterController extends GetxController {
  final List<String> hotelRatingOptions = [
    "5 Star",
    "4 Star",
    "3 Star",
    "2 Star",
    "1 Star"
  ];
  final List<String> guestRatingOptions = ["4", "3", "2", "1"];
  final List<String> propertyAmenityOptions = [
    "Gym",
    "Wifi",
    "Swimming pool",
  ];
  final List<String> mealOptions = [
    "Room only",
    "Breakfast included",
    "Breakfast + Lunch (or Dinner)"
  ];

  var hotelRatings = List<bool>.filled(5, false).obs;
  var guestRatings = List<bool>.filled(4, false).obs;
  var propertyAmenities = List<bool>.filled(4, false).obs;
  var meals = List<bool>.filled(3, false).obs;

  void toggleHotelRating(int index) {
    hotelRatings[index] = !hotelRatings[index];
  }

  void toggleGuestRating(int index) {
    guestRatings[index] = !guestRatings[index];
  }

  void togglePropertyAmenity(int index) {
    propertyAmenities[index] = !propertyAmenities[index];
  }

  void toggleMeal(int index) {
    meals[index] = !meals[index];
  }

  Map<String, dynamic> getSelectedFilters() {
    return {
      'hotelRatings': hotelRatings
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => hotelRatingOptions[e.key])
          .toList(),
      'guestRatings': guestRatings
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => guestRatingOptions[e.key])
          .toList(),
      'propertyAmenities': propertyAmenities
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => propertyAmenityOptions[e.key])
          .toList(),
    };
  }
}

//*CHALET==========================================================
final ChaletSearchApi chalestListController = Get.put(ChaletSearchApi());

class FilterControllerCHALET extends GetxController {
  final List<String> chaletRatingOptions = [
    "5 Star",
    "4 Star",
    "3 Star",
    "2 Star",
    "1 Star"
  ];
  final List<String> guestRatingOptions = ["4", "3", "2", "1"];
  List<String> propertyAmenityOptions =
      chalestListController.allAmanities.map((amenity) => '$amenity').toList();
  // final List<String> propertyAmenityOptions = [
  //   "Gym",
  //   "Free Wifi",
  //   "Swimming pool",
  //   "ac",
  //   "pool"
  // ];

  var chaletRatings = List<bool>.filled(100, false).obs;
  var guestRatings = List<bool>.filled(100, false).obs;
  var propertyAmenities = List<bool>.filled(100, false).obs;

  void togglechaletRating(int index) {
    chaletRatings[index] = !chaletRatings[index];
  }

  void toggleGuestRating(int index) {
    guestRatings[index] = !guestRatings[index];
  }

  void togglePropertyAmenity(int index) {
    propertyAmenities[index] = !propertyAmenities[index];
  }

  List<String> getSelectedFilters() {
    List<String> selectedFilters = [];

    selectedFilters.addAll(
      propertyAmenities
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => propertyAmenityOptions[e.key])
          .toList(),
    );

    return selectedFilters;
  }

  List<String> getSelectedFiltersHighestRating() {
    List<String> selectedRatingChalet = [];

    // Adding selected ratings to the list
    selectedRatingChalet.addAll(
      chaletRatings
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => guestRatingOptions[e.key])
          .toList(),
    );

    return selectedRatingChalet;
  }

  // double getSelectedFiltersHighestRating() {
  //   List<String> selectedRatingChalet = [];

  //   // Adding selected ratings to the list
  //   selectedRatingChalet.addAll(
  //     chaletRatings
  //         .asMap()
  //         .entries
  //         .where((e) => e.value)
  //         .map((e) => guestRatingOptions[e.key])
  //         .toList(),
  //   );

  //   List<double> ratingValues = selectedRatingChalet
  //       .map((rating) =>
  //           double.tryParse(rating) ?? 0.0) // Convert string to double
  //       .toList();

  //   if (ratingValues.isEmpty) return 0.0;
  //   double highestRating = ratingValues.reduce((a, b) => a > b ? a : b);
  //   return highestRating;
  // }
}
