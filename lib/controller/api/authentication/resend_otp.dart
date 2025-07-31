import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResendApi extends GetxController {
  var loading = false.obs;
  var message = "".obs;

  Future<bool> resend(String email) async {
    loading.value = true;
    final uri = Uri.parse("${resendOtp}v1/auth/resend-email/$email");
    try {
      final response = await http.post(
        uri,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        message.value = jsonDecode(response.body)['message'];
        debugPrint('Error: ${response.statusCode} - ${response.body}');
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
