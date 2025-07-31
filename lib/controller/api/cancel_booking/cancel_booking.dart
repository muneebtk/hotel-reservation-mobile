import 'dart:async';
import 'dart:convert';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/cancel_booking/cancel_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/login_controller.dart';

class CancelBookingApi extends GetxController {
  var loading = false.obs;
  var message = ''.obs;
  var refundAmount = 0.0.obs;
  var refundPercent = 0.obs;
  Future<bool> cancelBooking(BookingCancellationModel cancelModel) async {
    loading.value = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('access_token');

    try {
      final response = await http.post(Uri.parse(cancelBookingUrl),
          body: jsonEncode(cancelModel.toJson()),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          });
      if (response.statusCode == 201) {
        return true;
      } else {
        if (response.statusCode == 401) {
          final success = await LoginController().refToken();
          if (success) {
            return cancelBooking(cancelModel);
          }
        } else {
          message.value = jsonDecode(response.body)['message'];
          debugPrint("${response.statusCode}");
        }
      }
    } catch (e) {
      message.value = handleHttpException(e);
      throw Exception(e);
    } finally {
      loading.value = false;
    }
    return false;
  }

  checkRefundEligibility(String bookingId, String category) async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');
      final response = await http.post(
          Uri.parse(
              '$baseUrl/api/booking/$bookingId/refund/eligibility/?category=$category'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          });
      print(response.body);
      refundAmount.value = jsonDecode(response.body)['refund_amount'] ?? 0.0;
      refundPercent.value = jsonDecode(response.body)['refund_percentage'] ?? 0;
    } finally {
      loading.value = false;
    }
  }
}

//cancel booking chalet---------------------------------------------------

class CancelBookingApiCHALET extends GetxController {
  var loading = false.obs;
  var message = ''.obs;
  Future<bool> cancelBookingChalet(
      BookingCancellationCHALETModel cancelModel) async {
    loading.value = true;
    Timer(const Duration(seconds: 10), () {
      if (loading.value) {
        loading.value = false;
        message.value = "Taking too long, please try again.".tr;
        Get.snackbar("Timeout", message.value,
            colorText: kWhite, backgroundColor: darkRed);
      }
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('access_token');

    try {
      final response = await http.post(Uri.parse(cancelBookingCHALETUrl),
          body: jsonEncode(cancelModel.toJson()),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          });
      print(jsonEncode(cancelModel.toJson()));
      print(response.body);
      if (response.statusCode == 201) {
        print(response.statusCode);
        return true;
      } else {
        if (response.statusCode == 401) {
          await LoginController().refToken();
          return cancelBookingChalet(cancelModel);
        } else {
          message.value = jsonDecode(response.body)['message'];
          debugPrint("${response.statusCode}");
        }
      }
    } catch (e) {
      message.value = handleHttpException(e);
      throw Exception(handleHttpException(e));
    } finally {
      loading.value = false;
    }
    return false;
  }
}
