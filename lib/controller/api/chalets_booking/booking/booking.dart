import 'dart:async';
import 'dart:convert';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/controller/model/chalet_bookings/chalet_booking_entire/chalet_booking.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../constant/styles/colors.dart';

class ChaletsBookingApi extends GetxController {
  var message = ''.obs;
  var loading = false.obs;
  var bookedData = BookingData(
          id: 0,
          bookingFname: "",
          bookingLname: "",
          bookingEmail: "",
          bookingMobileNumber: "",
          checkinDate: "",
          checkoutDate: "",
          discountPrice: "",
          serviceFee: "",
          bookedPrice: "",
          numberOfGuests: 0,
          numberOfBookingRooms: 0,
          isMySelf: true,
          bookingId: "",
          bookingDate: "",
          createdDate: "",
          modifiedDate: "",
          status: "",
          user: 0,
          qrcode: "",
          chalet: 0)
      .obs;

  Future<bool> bookingdata(BookingData2 data) async {
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
    print(token);
    try {
      final response = await http.post(Uri.parse('$baseUrl/api/bookings/'),
          body: jsonEncode(data.toJson()),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });
      print(response.body);
      print(data.toJson());
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['data'];
        BookingData fetchedDetails = BookingData.fromJson(data);
        message.value = jsonDecode(response.body)['message'];
        bookedData.value = fetchedDetails;
        return true;
      } else {
        final data = jsonDecode(response.body);
        final msg = data['message'] ?? 'Something went wrong'.tr;
        message.value = data['message'] ?? msg;
        return false;
      }
    } catch (e) {
      message.value = 'Something went wrong'.tr;
      return false;
      // throw Exception(handleHttpException(e));
    } finally {
      loading.value = false;
    }
  }
}
