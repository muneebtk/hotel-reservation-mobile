import 'dart:convert';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/hotel_bookings/hotel_booking_entire/review_page_notf.dart';

class NotfBooking extends GetxController {
  var message = ''.obs;

//success booking api--------------------
  Future<String?> notf(BookingModelNotf model, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString('access_token');

    var headers = {
      'Content-Type': 'application/json',
    };

    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await http.post(
      Uri.parse("${notfUrl}api/properties/$id/book"),
      headers: headers,
      body: jsonEncode(model),
    );
    // print(model.toJson());
    try {
      if (response.statusCode == 201) {
        // final data = bookingModelFromJson(response.body);
        final id = jsonDecode((response.body))['id'].toString();
        return id;
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          message.value =
              jsonDecode(response.body)['message'] ?? 'Something went wrong'.tr;
          final success = await LoginController().refToken();
          if (success) {
            return notf(model, id);
          }
        } else {
          print(utf8.decode(response.bodyBytes));
          final data = jsonDecode(response.body);
          final msg = data['message'] ?? 'Something went wrong'.tr;
          message.value = data['message'] ?? msg;
        }
      }
    } catch (e) {
      // print(e);
      message.value = handleHttpException(e);
      throw (Exception(handleHttpException(e)));
    }

    return null;
  }
}
