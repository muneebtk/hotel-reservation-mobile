import 'dart:convert';
import 'dart:developer';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/booking_detail_response.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingDetailApiController extends GetxController {
  var loading = false.obs;
  var message = ''.obs;
  var bookingDetails = Rxn<BookingDetailResponse>(null).obs;

  void getBookingDetails(String id, String type) async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final lang = await getLang();
      var accessToken = pref.getString('access_token');

      final response = await http.get(
          Uri.parse('$bookingDetailUrl/$id')
              .replace(queryParameters: {"lang": lang, "type": type}),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          });
      log(response.body);
      if (response.statusCode == 200) {
        final data = BookingDetailResponse.fromJson(
            json.decode(utf8.decode(response.bodyBytes))['data']);
        bookingDetails.value.value = data;
      } else {
        if (response.statusCode == 401) {
          final success = await LoginController().refToken();
          if (success) {
            return getBookingDetails(id, type);
          }
        } else {
          message.value = jsonDecode(response.body)['message'];
          // debugPrint("${response.statusCode}");
        }
      }
    } catch (e) {
      // print('Error $e');
    } finally {
      loading.value = false;
    }
  }
}
