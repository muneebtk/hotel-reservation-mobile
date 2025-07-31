import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/controller/model/auth/register_otp.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterOtpApi extends GetxController {
  RxString message = "".obs;

  final url = "${registerOtp}api/v1/auth/verify-email";

  Future<bool> otpSuccessVerify(RegisterOtpModel model) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model),
      );

      if (response.statusCode == 200) {
        final successMessage = jsonDecode(response.body);
        message.value = successMessage['message'];
        return true;
      } else {
        message.value = jsonDecode(response.body)['message'];
        return false;
      }
    } catch (e) {
      message.value = handleHttpException(e);
      throw Exception(e);
    }
  }
}
