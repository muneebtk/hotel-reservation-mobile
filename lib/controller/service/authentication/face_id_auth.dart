import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'dart:io' show Platform;

class LocalAuthApi {
  static final localAuth = LocalAuthentication();

  static Future<bool> canAuthenticate() async {
    final isDeviceSupported = await localAuth.isDeviceSupported();
    final canCheckBiometrics = await localAuth.canCheckBiometrics;
    return isDeviceSupported && canCheckBiometrics;
  }

  static Future<bool> authenticate(String reason) async {
    try {
      final didAuthenticate = await localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        if (e.code == auth_error.notAvailable) {
          // debugPrint('Biometric authentication is not available.');
        } else if (e.code == auth_error.notEnrolled) {
          // debugPrint('Biometric authentication is not enrolled.');
        } else {
          // debugPrint('An error occurred: ${e.message}');
        }
      } else if (Platform.isIOS) {
        if (e.code == auth_error.notAvailable) {
          // debugPrint('Biometric authentication is not available.');
        } else if (e.code == auth_error.notEnrolled) {
          // debugPrint('Biometric authentication is not enrolled.');
        } else {
          // debugPrint('An error occurred: ${e.message}');
        }
      }
      return false;
    }
  }
}
