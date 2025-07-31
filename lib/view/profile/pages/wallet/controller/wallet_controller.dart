import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletController extends GetxController {
  RxBool loading = false.obs;
  RxDouble balance = 0.0.obs;
  RxString message = ''.obs;
  RxBool showError = false.obs;
  var isGuest = false.obs;

  Future<void> getBalance() async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');
      var headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      final response = await http
          .get(Uri.parse('$baseUrl/api/wallet/add-funds/'), headers: headers);
      if (response.statusCode == 200) {
        // print(jsonDecode(response.body)['balance']);
        balance.value = jsonDecode(response.body)['balance'] ?? 0;
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) return getBalance();
        }
      }
      isGuest.value = await isGuestUser();
      // print(isGuest.value);
    } finally {
      loading.value = false;
    }
  }

  Future<String?> addMoneyToWallet(String amount) async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      var accessToken = pref.getString('access_token');
      var headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({'amount': int.parse(amount)});

      final response = await http.post(
        Uri.parse('$baseUrl/api/wallet/add-funds/?lang=en'),
        headers: headers,
        body: body,
      );
      // print(response.body);
      if (response.statusCode == 200) {
        final paymentUrl = jsonDecode(response.body)['payment_url'];
        // message.value =
        //     jsonDecode(response.body)['message'] ?? 'Payment Success';
        return paymentUrl;
      } else {
        if (response.statusCode == 401 && accessToken != null) {
          final success = await LoginController().refToken();
          if (success) return addMoneyToWallet(amount);
        } else {
          // print(response.body);
          message.value =
              jsonDecode(response.body)['message'] ?? 'Something went wrong'.tr;
        }
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      loading.value = false;
    }
  }
}
