import 'dart:developer';
import 'dart:io';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/controller/api/authentication/apple_signin.dart';
import 'package:e_concierge_tourism/controller/service/authentication/facebook_auth_service.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../constant/styles/colors.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../controller/api/authentication/google_signin_api.dart';
import '../../bottom_nav.dart/bottom_nav.dart';

//social media authenticationnn

//facebook / google /
class SocialAuthentication extends StatelessWidget {
  SocialAuthentication({super.key});
  final GoogleSignInApi googleSignInController = Get.put(GoogleSignInApi());
  @override
  Widget build(BuildContext context) {
    PushNotificationApi notfController = Get.put(PushNotificationApi());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Platform.isIOS)
          InkWell(
            onTap: () async {
              final cred = await signInWithApple(context);
              if (cred) {
                if (await isFirstTime()) {
                  await setSecondTime();
                }
                Get.offAll(const BottomNav());
              } else {
                snackbar('Login Failed'.tr, 'Something went wrong'.tr);
              }
            },
            child: CircleAvatar(
              backgroundColor: kWhite,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 24,
                  child: CustomPaint(
                    painter: AppleLogoPainter(
                      color: kBlack,
                    ),
                  ),
                ),
              ),
            ),
          ),
        width20,
        InkWell(
          onTap: () async {
            final cred = await signInWithFacebook();
            if (cred) {
              if (await isFirstTime()) {
                await setSecondTime();
              }
              Get.offAll(const BottomNav());
            } else {
              snackbar('Login Failed'.tr, 'Something went wrong'.tr);
            }
          },
          child: const CircleAvatar(
            backgroundColor: kWhite,
            child: Icon(
              Icons.facebook,
              color: Colors.blue,
            ),
          ),
        ),
        width20,
        InkWell(
          onTap: () async {
            try {
              final success = await googleSignInController.googleSigninApi();
              if (success) {
                if (await isFirstTime()) {
                  await setSecondTime();
                }
                Get.offAll(const BottomNav());
                // notfController
                //     .showSuccessNotification("You have succesfully registered");
              } else {
                if (googleSignInController.message.value.isNotEmpty) {
                  showAnimatedSnackBar(
                      googleSignInController.message.value, kBlack);
                }
              }
            } catch (e) {
              snackbar('Error', e.toString());
            }
          },
          child: const CircleAvatar(
            backgroundColor: kWhite,
            backgroundImage: AssetImage(
              "assets/images/google_PNG19635.png",
            ),
          ),
        ),
      ],
    );
  }
}
