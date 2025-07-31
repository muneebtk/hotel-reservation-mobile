import 'dart:convert';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordApi extends GetxController {
  RxString message = ''.obs;
  Future<bool> sendingEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse("${forgotEmailVerifying}api/get-email"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        message.value = jsonDecode(response.body)['message'];
        return false;
      }
    } catch (e) {
      throw Exception('Error sending email: $e');
    }
  }
}
