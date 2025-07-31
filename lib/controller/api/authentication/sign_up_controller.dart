import 'dart:convert';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/controller/model/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignupApi extends GetxController {
  RxInt otp = 0.obs;
  RxString email = "".obs;
  RxString message = "".obs;
  Future<bool> createUser(UserModel user) async {
    final Uri url = Uri.parse("${signupUrl}api/v1/auth/signup");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user),
      );   print(jsonEncode(user));    print(json.decode(utf8.decode(response.bodyBytes)));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        otp.value = data['otp'];
        email.value = data['user_email'];
        message.value = jsonDecode(response.body)['message'];
        return true;
      } else {
        debugPrint("${response.statusCode}");
        message.value = jsonDecode(response.body)['message'];
        return false;
      }
    } catch (e) {
      message.value = handleHttpException(e);
      throw Exception(e);
    }
  }
}
