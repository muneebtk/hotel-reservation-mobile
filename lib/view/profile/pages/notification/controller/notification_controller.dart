import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../model/notification_model.dart';

class NotificationController extends GetxController {
  var loading = false.obs;
  RxList<Notifications> notifications = <Notifications>[].obs;
  bool retry = true;

  Future<void> getNotifications() async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      // final lang = await getLang();
      var accessToken = pref.getString('access_token');
      var header = {
        'Content-Type': 'application/json',
      };
      if (accessToken != null && accessToken.isNotEmpty) {
        header['Authorization'] = "Bearer $accessToken";
      }
      final response =
          await http.get(Uri.parse(notificationUrl), headers: header);
      // print(response.body);
      if (response.statusCode == 200) {
        final data = NotificationResponse.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));

        notifications.value = data.data ?? [];
      } else {
        if (response.statusCode == 401) {
          if (retry) {
            retry = false;
            final success = await LoginController().refToken();
            if (success) return getNotifications();
          }
        }
      }
    } finally {
      loading.value = false;
    }
  }
}
