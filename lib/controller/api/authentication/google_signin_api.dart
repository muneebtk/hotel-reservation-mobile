import 'dart:convert';

import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../constant/exception_message/exception_message.dart';
import '../../service/authentication/google_signin_service.dart';
import 'package:http/http.dart' as http;

//google signin api
class GoogleSignInApi extends GetxController {
  RxString accessToken = "".obs;
  RxString refreshToken = "".obs;
  RxInt idOfUser = 0.obs;
  RxString message = "".obs;

  Future<bool> googleSigninApi() async {
    UserCredential? userCredential = await signInWithGoogle();
    print(userCredential);
    if (userCredential != null) {
      final String? googleAccessToken = userCredential.credential?.accessToken;
      User? user = userCredential.user;
      String? fcmToken;

      if (user == null) {
        debugPrint('Error: User is null after sign-in');
        return false;
      }
      final deviceName = await getDeviceName();
      if (await isRealDevice()) {
        fcmToken = await PushNotificationApi().getFcmToken();
      }
      try {
        final response = await http.post(
          Uri.parse(googleSignIn),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'access_token': googleAccessToken,
            'device_name': deviceName,
            'fcmToken': fcmToken,
            'platform': getPlatorm()
          }),
        );
        print(deviceName);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.containsKey('user_id') &&
              data.containsKey('access') &&
              data.containsKey('refresh') &&
              data.containsKey('message')) {
            idOfUser.value = data['user_id'];
            accessToken.value = data['access'];
            refreshToken.value = data['refresh'];
            message.value = data['message'];

            await storeTokens(
                accessToken.value, refreshToken.value, idOfUser.value);
            return true;
          } else {
            debugPrint('Error: API response does not contain expected fields');
          }
        } else {
          final FirebaseAuth auth = FirebaseAuth.instance;
          final GoogleSignIn googleSignIn = GoogleSignIn();
          await auth.signOut();
          await googleSignIn.signOut();
          message.value = jsonDecode(response.body)['error'];
          debugPrint('Error posting data to API: ${response.statusCode}');
          debugPrint('Response body: ${response.body}');
        }
      } catch (e) {
        throw Exception(handleHttpException(e));
      }
    } else {
      debugPrint('Error: User credential is null');
    }
    return false;
  }
}
