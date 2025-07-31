import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomGetSnackBar(
    String message1, String message2, Color textColor, Color backgroundColor) {
  Get.snackbar(
    message1,
    message2,
    backgroundColor: backgroundColor,
    colorText: textColor,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    borderRadius: 10,
    duration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 500),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOut,
    boxShadows: [
      const BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        spreadRadius: 1,
        offset: Offset(0, 3),
      ),
    ],
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showAnimatedSnackBar(String message, Color backgroundColor) {
  final snackBar = SnackBar(
      animation: const AlwaysStoppedAnimation(12),
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: const TextStyle(color: kWhite),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: backgroundColor);

  scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
}
