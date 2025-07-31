import 'dart:async';
import 'dart:convert';
import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/model/auth/login.dart';
import 'package:e_concierge_tourism/view/auth/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/api_service/api_url.dart';

class LoginController extends GetxController {
  RxString accessToken = "".obs;
  RxString refreshToken = "".obs;
  RxInt userId = 0.obs;
  RxString message = "".obs;
  var loading = false.obs;

//login------------------------------------------------------------------------
  Future<bool> loginCheck(LoginUserModel loginUser, {bool retry = true}) async {
    loading.value = true;
    Timer(const Duration(seconds: 10), () {
      if (loading.value) {
        loading.value = false;
        message.value = "Login took too long, please try again.";
        showAnimatedSnackBar(message.value, darkRed);
      }
    });
    try {
      final response = await http.post(
        Uri.parse("${loginurl}api/v1/auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(loginUser),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        accessToken.value = data['access'];
        refreshToken.value = data['refresh'];
        userId.value = data['user_id'];
        await storeTokens(accessToken.value, refreshToken.value, userId.value);
        message.value = data['message'];
        return true;
      } else if (response.statusCode == 401) {
        if (retry) {
          await refToken();
          return loginCheck(loginUser, retry: false);
        } else {
          message.value = jsonDecode(response.body)['message'];
          debugPrint('Invalid login credentials');
          return false;
        }
      } else {
        message.value = jsonDecode(response.body)['message'];
        debugPrint('Login failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      message.value = handleHttpException(e);
    } finally {
      loading.value = false;
    }
    return false;
  }

//?-----------------------------------------------------------------------------------------
//refresh token
  Future<bool> refToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final refresh = prefs.getString("refresh_token");
      print(accessToken);
      print('Refresh Toke $refresh');
      if (refresh == null) {
        debugPrint('No refresh token available');
        return false;
      }

      final response = await http.post(
        Uri.parse("${refreshurl}api/api/token/refresh/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );

      if (response.statusCode == 200) {
        final newAccessToken = jsonDecode(response.body)['access'];
        // final newRefreshToken = jsonDecode(response.body)['refresh'];
        accessToken.value = newAccessToken;
        await prefs.setString('access_token', newAccessToken);
        // await prefs.setString('refresh_token', newRefreshToken);
        return true;
      } else {
        debugPrint(
            'Failed to refresh token with status code: ${response.statusCode}');
        snackbar('Session Expired'.tr, 'Session expired message'.tr);
        Get.offAll(const LoginPage());
        return false;
        // throw Exception("Failed to refresh token");
      }
    } catch (e) {
      debugPrint('Error during token refresh: $e');
      return false;
    }
  }
}

Future<void> storeTokens(String accessToken, String refreshToken,
    [int? userid]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', accessToken);
  await prefs.setString('refresh_token', refreshToken);
  await prefs.setInt("user_id", userid!);
}

Future<Map<String, String?>> getTokens() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('access_token');
  final String? refreshToken = prefs.getString('refresh_token');

  return {
    'access_token': accessToken,
    'refresh_token': refreshToken,
  };
}
