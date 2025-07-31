import 'dart:convert';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RatingReviewApi extends GetxController {
  var ratingReview = [].obs;
  var message = ''.obs;
  var review = ''.obs;
  var userrating = 0.0.obs;
  Future<bool> rating(double rating, String hotelid, String reviewText,
      String bookingID) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');
      final lang = await getLang();

      final response = await http.post(
        Uri.parse(ratingReviewUrl).replace(queryParameters: {"lang": lang}),
        body: {
          'hotelid': hotelid,
          'review_text': reviewText,
          'rating': rating.toString(),
          'booking_id': bookingID
        },
        headers: {
          // 'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      // print(response.body);

      // print(response.statusCode);
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        review.value = data['review']['review_text'] ?? '';
        userrating.value = data['review']['rating'] ?? 0.0;
        message.value =
            jsonDecode(utf8.decode(response.bodyBytes))['message'] ??
                'Something went wrong'.tr;
        return true;
      } else {
        message.value =
            jsonDecode(utf8.decode(response.bodyBytes))['message'] ??
                'Something went wrong'.tr;
        // debugPrint('${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print(e);
      message.value = 'Something went wrong'.tr;
      return false;
    }
  }
}
