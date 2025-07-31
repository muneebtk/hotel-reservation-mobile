import 'dart:async';
import 'dart:developer';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../constant/styles/colors.dart';
import '../../../model/hotel_bookings/hotel_booking_entire/room_details.dart';

class RoomDetailController extends GetxController {
  var message = ''.obs;
  var rooms = <Room>[].obs;
  var roomTypeoptionPrice = <RoomTypePrice>[].obs;
  var roomTypeName = [].obs;
  var errorMessage = ''.obs;
  var loading = false.obs;
  var sortList = [].obs;
  var availableRooms = {}.obs;

  Future<void> fetchRooms(String id, String room, String members,
      String checkin, String checkout) async {
    loading.value = true;

    Timer(const Duration(seconds: 10), () {
      if (loading.value) {
        loading.value = false;
        message.value = "Taking too long, please try again.".tr;
        showAnimatedSnackBar(message.value, darkRed);
      }
    });

    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('access_token');
    final lang = await getLang();
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      final query = {
        "checkin_date": checkin,
        "checkout_date": checkout,
        "rooms": room,
        "members": members,
        "lang": lang,
      };
      final response = await http.get(
          Uri.parse('${roomDetailUrl}api/properties/$id/room-listing')
              .replace(queryParameters: query),
          headers: headers);
      loading.value = false;
      if (response.statusCode == 200) {
        log(response.body);
        final List<dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes))['room_data'];
        final List<dynamic> roomTypeNames = responseData
            .map((roomJson) => roomJson['roomtype_name'][0]['room_types'])
            .toList();

        rooms.assignAll(
          responseData.map((roomJson) => Room.fromJson(roomJson)).toList(),
        );
        roomTypeName.value = roomTypeNames;
        final List<dynamic> responseDatasprice =
            json.decode(response.body)['room_data'];
        roomTypeoptionPrice.assignAll(
          responseDatasprice
              .map((roomJsonPrice) => RoomTypePrice.fromJson(roomJsonPrice))
              .toList(),
        );
        availableRooms.value =
            json.decode(utf8.decode(response.bodyBytes))['rooms_available'];
      } else {
        if (response.statusCode == 401 && token != null) {
          final success = await LoginController().refToken();
          if (success) {
            return fetchRooms(id, room, members, checkin, checkout);
          }
        } else {
          message.value = jsonDecode(response.body)['message'];
        }
      }
    } catch (e) {
      // print(e);
      message.value = handleHttpException(e);
      throw Exception(handleHttpException(e));
    }
  }
}
