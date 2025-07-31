import 'dart:convert';

import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<bool> signInWithApple(BuildContext context) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Fallback if Apple doesn't return the name
    String? firstName = credential.givenName;
    String? lastName = credential.familyName;

    // if (firstName.isEmpty || lastName.isEmpty) {
    //   final name = await promptForName(context);
    //   firstName = name['first_name'] ?? '';
    //   lastName = name['last_name'] ?? '';

    //   if (firstName.isEmpty || lastName.isEmpty) {
    //     return false;
    //   }
    // }

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    String? accessToken = userCredential.credential?.accessToken;
    String? fcmToken;
    final deviceName = await getDeviceName();
    if (await isRealDevice()) {
      fcmToken = await PushNotificationApi().getFcmToken();
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/auth/apple-signin/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'access_token': accessToken,
        'device_name': deviceName,
        'fcmToken': fcmToken,
        'platform': getPlatorm(),
      }),
    );

    ;
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('user_id') &&
          data.containsKey('access') &&
          data.containsKey('refresh')) {
        await storeTokens(data['access'], data['refresh'], data['user_id']);
        await pref.setString("email_for_profile", credential.email ?? '');

        return true;
      }
      return false;
    } else if (response.statusCode == 400) {
      final name = await promptForName(context);
      print(name);
      firstName = name['first_name'] ?? '';
      lastName = name['last_name'] ?? '';

      if (firstName.isEmpty || lastName.isEmpty) {
        return false;
      }
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/apple-signin/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'access_token': accessToken,
          'device_name': deviceName,
          'fcmToken': fcmToken,
          'platform': getPlatorm(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('user_id') &&
            data.containsKey('access') &&
            data.containsKey('refresh')) {
          await storeTokens(data['access'], data['refresh'], data['user_id']);
          await pref.setString("email_for_profile", credential.email ?? '');
          
          return true;
        }
      }
      return false;
    } else {
      await FirebaseAuth.instance.signOut();
      return false;
    }
  } catch (error) {
    print('Apple Sign-In failed: $error');
    return false;
  }
}

// Future<bool> _requestAPI(
//     BuildContext context,
//     String? firstName,
//     String? lastName,
//     String? accessToken,
//     String deviceName,
//     String? fcmToken) async {}

Future<Map<String, String>> promptForName(BuildContext context) async {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final result = await showDialog<Map<String, String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: darkRed,
        title: Text("Enter your name", style: TextStyle(color: kWhite)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "first_name".tr,
              style: textColorwhite.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextFormFieldWidget(
              color: kWhite,
              controller: firstNameController,
              keyboardType: TextInputType.name,
              hintText: "enter_first_name".tr,
              hintStyle: const TextStyle(fontSize: 14),
            ),
            Text(
              "last_name".tr,
              style: textColorwhite.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            TextFormFieldWidget(
              color: kWhite,
              controller: lastNameController,
              keyboardType: TextInputType.name,
              hintText: "enter_last_name".tr,
              hintStyle: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop({
                'first_name': firstNameController.text.trim(),
                'last_name': lastNameController.text.trim(),
              });
            },
            child: Text(
              'Submit',
              style: TextStyle(color: kWhite),
            ),
          ),
        ],
      );
    },
  );
  return result ?? {'first_name': '', 'last_name': ''};
}
