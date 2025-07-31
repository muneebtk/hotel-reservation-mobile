import 'dart:convert';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/exception_message/exception_message.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<bool> signInWithFacebook() async {
  try {
    final LoginResult loginResult = await FacebookAuth.instance.login(
      
    );

    if (loginResult.status == LoginStatus.success) {
      print("Access Token: ${loginResult.accessToken!.tokenString}");
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
          print(userCredential);
      final String? facebookAccessToken =
          userCredential.credential?.accessToken;
      User? user = userCredential.user;
      String? fcmToken;

      if (user == null) {
        // debugPrint('Error: User is null after sign-in');
        return false;
      }
      final deviceName = await getDeviceName();
      if (await isRealDevice()) {
        fcmToken = await PushNotificationApi().getFcmToken();
      }
      try {
        final response = await http.post(
          Uri.parse(facebookSignIn),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'access_token': facebookAccessToken,
            'device_name': deviceName,
            'fcmToken': fcmToken,
            'platform': getPlatorm()
          }),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.containsKey('user_id') &&
              data.containsKey('access') &&
              data.containsKey('refresh') &&
              data.containsKey('message')) {
            final idOfUser = data['user_id'];
            final accessToken = data['access'];
            final refreshToken = data['refresh'];
            // message.value = data['message'];

            await storeTokens(accessToken, refreshToken, idOfUser);
            return true;
          } else {
            // debugPrint('Error: API response does not contain expected fields');
          }
        } else {
          final FirebaseAuth auth = FirebaseAuth.instance;
          // final GoogleSignIn googleSignIn = GoogleSignIn();
          await auth.signOut();
          // await googleSignIn.signOut();
          await FacebookAuth.instance.logOut();
          // message.value = jsonDecode(response.body)['error'];
          // debugPrint('Error posting data to API: ${response.statusCode}');
          // debugPrint('Response body: ${response.body}');
        }
      } catch (e) {
        throw Exception(handleHttpException(e));
      }
      return false;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
