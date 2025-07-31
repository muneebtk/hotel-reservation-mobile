import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/controller/model/chalet_bookings/chalet_booking_entire/chalet_searching.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/hotel_bookings/hotel_booking_entire/search_hotels_model.dart';

//hotel listing---------------------------------------------
class SearchHotelCityNameController extends GetxController {
  RxString errormessage = "".obs;
  var hotelId = 0.obs;
  List<HotelSearchList> hotelList = <HotelSearchList>[].obs;
  var loading = false.obs;
  var message = ''.obs;

  Future<bool> fetchData(SearchHotelCityNameModel value) async {
    loading.value = true;
    Timer(const Duration(seconds: 10), () {
      if (loading.value) {
        loading.value = false;
        message.value = "Taking too long, please try again.".tr;
        showAnimatedSnackBar(message.value, darkRed);
      }
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    final accessToken = pref.getString('access_token');
    final lang = await getLang();
    var uri = Uri.parse("${hotelSearchUrl}api/HOTEL/search");
    final newUri = uri.replace(queryParameters: {"lang": lang});

    Map<String, dynamic> requestBody = {
      "city_name": value.cityName,
      "hotel_name": value.hotelName,
      "checkin_date": value.checkingDate,
      "checkout_date": value.checkoutDate,
      "members": value.members.toString(),
      "room": value.room.toString(),
      "sorted": value.sorted,
      "priceRange": value.priceRangeSort,
      "filter": value.filter,
      if (value.lat != null) "latitude": value.lat,
      if (value.lng != null) "longitude": value.lng,
    };
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
      print(requestBody);

      var response = await http.post(
        newUri,
        headers: headers,
        body: jsonEncode(requestBody),
      );
      loading.value = false;
      log('hotel detail${response.body}');

      if (response.statusCode == 200) {
        var data = utf8.decode(response.bodyBytes);
        // print(data);
        // hotelsList.assignAll(data);
        hotelList = hotelSearchListFromJson(data);
        // print(hotelList.first.hoteltype?.icon);

        return true;
      } else if (response.statusCode == 401 && accessToken != null) {
        final success = await LoginController().refToken();
        if (success) {
          return fetchData(value);
        }
        return false;
      } else {
        errormessage.value =
            jsonDecode(utf8.decode(response.bodyBytes))['message'];
      }
    } catch (e) {
      // print(e);
      errormessage.value =
          "We’re experiencing an issue. Please try again later.";
      // throw Exception(handleHttpException(e));
    } finally {
      loading.value = false;
    }
    return false;
  }
}
