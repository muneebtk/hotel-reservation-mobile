import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['profile', 'email']).signIn();

    if (googleUser == null) {
      // debugPrint('Google Sign-In failed: user canceled');
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("email_for_profile", user.email ?? '');
      return userCredential;
    } else {
      // debugPrint('Google Sign-In failed: no user data');
      return null;
    }
  } catch (e) {
    // debugPrint("Error during Google Sign-In: $e");
    return null;
  }
}
