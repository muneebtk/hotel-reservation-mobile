import 'dart:convert';

import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../language/controller/transalate_controller.dart';
import '../../../auth/login_page/login_page.dart';

bool hotelDetail_compare_button = false;

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final AccountDeleteController accountDeleteController =
      Get.put(AccountDeleteController());
  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      // Sign out from Firebase
      await auth.signOut();

      // Sign out from Google
      await googleSignIn.signOut();
    }

    final LanguageController languageController = Get.put(LanguageController());
    return Scaffold(
      appBar: MyAppBar(title: 'settings'.tr),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.white, child: Icon(Icons.translate)),
            title: Text('language'.tr),
            subtitle: Obx(() => Text(
                languageController.selectedLanguage.value == "English"
                    ? "English"
                    : "العربية")),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              GetPlatform.isAndroid
                  ? showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'select_language'.tr,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/640px-Flag_of_the_United_Kingdom_%281-2%29.svg.png",
                                  height: 50,
                                  width: 50,
                                ),
                                title: Text('english'.tr),
                                onTap: () {
                                  languageController.changeLanguage('English');
                                  hotelDetail_compare_button = false;

                                  Navigator.of(context).pop();
                                },
                              ),
                              ListTile(
                                leading: Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Flag_of_Oman.svg/800px-Flag_of_Oman.svg.png",
                                  height: 50,
                                  width: 50,
                                ),
                                title: Text('arabic'.tr),
                                onTap: () {
                                  languageController
                                      .changeLanguage('arabic'.tr);
                                  hotelDetail_compare_button = true;
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('select_language'.tr,
                              style: const TextStyle(
                                  fontFamily: 'IBMPlexSansArabic')),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CupertinoListTile(
                                leading: Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/640px-Flag_of_the_United_Kingdom_%281-2%29.svg.png",
                                  height: 50,
                                  width: 50,
                                ),
                                title: Text(
                                  'english'.tr,
                                  style: const TextStyle(
                                      fontFamily: 'IBMPlexSansArabic'),
                                ),
                                onTap: () {
                                  languageController.changeLanguage('English');
                                  hotelDetail_compare_button = false;

                                  Navigator.of(context).pop();
                                },
                              ),
                              CupertinoListTile(
                                leading: Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Flag_of_Oman.svg/800px-Flag_of_Oman.svg.png",
                                  height: 50,
                                  width: 50,
                                ),
                                title: Text(
                                  'arabic'.tr,
                                  style: const TextStyle(
                                      fontFamily: 'IBMPlexSansArabic'),
                                ),
                                onTap: () {
                                  languageController.changeLanguage('Arabic');
                                  hotelDetail_compare_button = true;
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Flag_of_Oman.svg/800px-Flag_of_Oman.svg.png"),
            ),
            title: Text('country'.tr),
            subtitle: Text('oman'.tr),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.monetization_on)),
            title: Text('display_currency'.tr),
            subtitle: Text('omr'.tr),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          ),

          //!----------logout -------------------------------------------------------------------
          height20,
          Padding(
            padding: const EdgeInsets.only(left: 80, right: 80),
            child: InkWell(
              onTap: () {
                // Platform specific alert dialog
                if (GetPlatform.isIOS) {
                  // iOS dialog
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          'Confirm Logout'.tr,
                          style:
                              const TextStyle(fontFamily: 'IBMPlexSansArabic'),
                        ),
                        content: Text(
                          'Are you sure you want to logout?'.tr,
                          style:
                              const TextStyle(fontFamily: 'IBMPlexSansArabic'),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel'.tr,
                              style: const TextStyle(
                                  fontFamily: 'IBMPlexSansArabic'),
                            ),
                          ),
                          CupertinoDialogAction(
                            onPressed: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.remove('access_token');
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            // isDestructiveAction: true,
                            child: Text(
                              'logout'.tr,
                              style: const TextStyle(
                                  fontFamily: 'IBMPlexSansArabic'),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Android (or other platforms) dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Logout'.tr),
                        content: Text('Are you sure you want to logout?'.tr),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'.tr),
                          ),
                          TextButton(
                            onPressed: () async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.remove('access_token');
                              signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginPage(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text('logout'.tr),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      width5,
                      Text(
                        "logout".tr,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          height20,
          if(!guestUser)
          Padding(
            padding: const EdgeInsets.only(left: 80, right: 80),
            child: InkWell(
              onTap: () {
                // Platform specific alert dialog
                if (GetPlatform.isIOS) {
                  // iOS dialog
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text(
                          'confirm_delete'.tr,
                          style:
                              const TextStyle(fontFamily: 'IBMPlexSansArabic'),
                        ),
                        content: Text(
                          'confirm_delete_message'.tr,
                          style:
                              const TextStyle(fontFamily: 'IBMPlexSansArabic'),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel'.tr,
                              style: const TextStyle(
                                  fontFamily: 'IBMPlexSansArabic'),
                            ),
                          ),
                          CupertinoDialogAction(
                            onPressed: () async {
                              Get.defaultDialog(
                                barrierDismissible: false,
                                title: "",
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: darkRed,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "loading".tr,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: kWhite,
                                radius: 10,
                              );
                              final success =
                                  await accountDeleteController.deleteAccount();
                              if (success) {
                                   showAnimatedSnackBar(
                                    'delete_successful'.tr, kBlack);
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.remove('access_token');
                                signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LoginPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                showAnimatedSnackBar(
                                    'Something went wrong'.tr, kRed);
                              }
                            },
                            // isDestructiveAction: true,
                            child: Text(
                              'delete'.tr,
                              style: const TextStyle(
                                  fontFamily: 'IBMPlexSansArabic'),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Android (or other platforms) dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('confirm_delete'.tr),
                        content: Text('confirm_delete_message'.tr),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'.tr),
                          ),
                          TextButton(
                            onPressed: () async {
                              Get.defaultDialog(
                                barrierDismissible: false,
                                title: "",
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const CircularProgressIndicator(
                                      color: darkRed,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "loading".tr,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: kWhite,
                                radius: 10,
                              );
                              final success =
                                  await accountDeleteController.deleteAccount();
                              if (success) {
                                 showAnimatedSnackBar(
                                    'delete_successful'.tr, kBlack);
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.remove('access_token');
                                signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LoginPage(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                showAnimatedSnackBar(
                                    'Something went wrong'.tr, kRed);
                              }
                            },
                            child: Text('delete'.tr),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      width5,
                      Text(
                        "delete_account".tr,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          height20,
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData && snapshot.data != null) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '1929 Way\n Version: ${snapshot.data!.version}',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                default:
                  return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}

class AccountDeleteController extends GetxController {
  var loading = false.obs;
  var errormessage = ''.obs;

  Future<bool> deleteAccount() async {
    try {
      loading.value = true;
      SharedPreferences pref = await SharedPreferences.getInstance();
      final accessToken = pref.getString('access_token');

      var headers = {
        'Content-Type': 'application/json',
      };

      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await http.delete(
          headers: headers, Uri.parse('$baseUrl/api/delete-account'));
      print(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      loading.value = false;
    }
  }
}
