import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RatingReviewChalet extends GetxController {
  var message = ''.obs;
  var review = ''.obs;
  var userrating = 0.0.obs;
  Future<bool> ratingChalet(String chaletID, String rating, String reviewText,
      String bookingID) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      final lang = await getLang();
      final response = await http.post(
          Uri.parse("$baseUrl/api/chalet/rating-review")
              .replace(queryParameters: {"lang": lang}),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${pref.getString('access_token')}',
          },
          body: jsonEncode({
            "chaletid": chaletID,
            "rating": rating,
            "review_text": reviewText,
            "booking_id": bookingID
          }));
      if (response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        review.value = data['review']['review_text'] ?? '';
        userrating.value = data['review']['rating'] ?? 0.0;
        message.value = data['message'] ?? 'Something went wrong'.tr;
        return true;
      } else {
        message.value =
            jsonDecode(utf8.decode(response.bodyBytes))['message'] ??
                'Something went wrong'.tr;
        return false;
      }
    } catch (e) {
      message.value = 'Something went wrong'.tr;
      return false;
    }
  }
}
