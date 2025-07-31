import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:get/get.dart';

class SearchingHotelName extends GetxController {
  var loading = false.obs;
  var searchQuery = ''.obs;
  var filteredHotelsList = <HotelSearchList>[].obs;
  var apical = true.obs;
  void updateSearchQuery(String query, List<HotelSearchList> hotelsList) async {
    loading.value = true;
    searchQuery.value = query;
    try {
      if (query.isEmpty) {
        filteredHotelsList.value = hotelsList;
        loading.value = false;
      } else {
        filteredHotelsList.value = hotelsList
            .where((hotel) =>
                hotel.hotelName?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      loading.value = false;
    }
  }
}
