import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/booking_detail_response.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../controller/model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';

class PaymentController extends GetxController {
  var loading = false.obs;
  var message = ''.obs;
  Future<BookingData?> pay(String bookingId, String type, String amount,
      String category, GuestDetails? userDetails) async {
    loading.value = true;
    message.value = '';
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
      final body = {
        "payment_type": type,
        "category": category,
        "total_amount": amount,
        "amount": amount,
        "first_name": userDetails?.firstName,
        "last_name": userDetails?.lastName,
        "email": userDetails?.email,
        "phone_number": userDetails?.mobileNumber
      };
      final response = await http.post(
          Uri.parse(
            "$baseUrl/api/booking/$bookingId/pay",
          ).replace(queryParameters: {"lang": lang}),
          headers: headers,
          body: jsonEncode(body));
      print(jsonEncode(body));
      print('hello${response.body}');
      if (response.statusCode == 200) {
        // print("Online".tr);
        if ("Online" == type) {
          final url = jsonDecode(response.body)['payment_url'];
          return BookingData(id: 0, adults: 0, children: 0, paymentUrl: url);
        } else {
          final data = bookingModelFromJson(utf8.decode(response.bodyBytes));
          // print(response.body);
          return data.data;
        }
      } else if (response.statusCode == 401) {
        final success = await LoginController().refToken();
        if (success) {
          return pay(bookingId, type, amount, category, userDetails);
        }
      } else {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        message.value = data['message'] ?? 'Something went wrong'.tr;
      }
    } catch (e) {
      // print(e);
    } finally {
      loading.value = false;
    }
    return null;
  }
}
