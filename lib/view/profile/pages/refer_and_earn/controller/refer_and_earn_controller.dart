import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReferAndEarnController extends GetxController {
  RxBool loading = false.obs;
  RxString token = ''.obs;

  Future<void> getReferalCode() async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');
      var headers = {
        'Authorization': 'Bearer $accessToken',
      };

      final response = await http.get(
          Uri.parse('$baseUrl/api/generate-referral-token/'),
          headers: headers);
      if (response.statusCode == 201) {
        // print('hello');
        token.value = jsonDecode(response.body)['token'];
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) return getReferalCode();
        }
      }
      // print(response.statusCode);
      // print(json.decode(response.body));
    } finally {
      loading.value = false;
    }
  }
}
