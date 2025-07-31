import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/model/payment_methods_accepted/payment_method_accepted_model.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PaymentTypesCheck extends GetxController {
  var loading = false.obs;
  var message = ''.obs;
  List<AcceptedPayments>? paymentMethodsAccepted = <AcceptedPayments>[].obs;

  checkPaymentTypesAccepted(int? id, String type) async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final lang = await getLang();
      var accessToken = pref.getString('access_token');
      final body = {"type": type, "id": "$id"};
      final response = await http.post(
        Uri.parse('$baseUrl/api/accepted-payments/?lang=$lang'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      print(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        final data =
            paymentMethodsAcceptedFromJson(utf8.decode(response.bodyBytes));
        paymentMethodsAccepted = data.data;
      }
    } catch (_) {
    } finally {
      loading.value = false;
    }
  }
}
