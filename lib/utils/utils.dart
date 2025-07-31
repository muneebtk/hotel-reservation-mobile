import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/view/auth/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

copyToClipBoard(String? text, {String? content}) async {
  if (text != null && text.isNotEmpty) {
    await Clipboard.setData(ClipboardData(text: text));
    showAnimatedSnackBar(content ?? "Copied to clipboard", kBlack);
  }
}

Future<bool> isFirstTime() async {
  final pref = await SharedPreferences.getInstance();
  return !pref.containsKey('isFirstTime');
}

Future<bool> setSecondTime() async {
  final pref = await SharedPreferences.getInstance();
  return pref.setBool('isFirstTime', false);
}

Future<bool> isGuestUser() async {
  final pref = await SharedPreferences.getInstance();
  final data = pref.getString('access_token');
  return data == null;
}

Future<String> getLang() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? language = prefs.getString('selected_language');
  if (language == 'Arabic') {
    return 'ar';
  } else {
    return 'en';
  }
}

removecompareHotelFromLocal(String id) async {
  final prefs = await SharedPreferences.getInstance();
  final list = prefs.getStringList('CMHotels') ?? [];
  list.remove(id);
  prefs.setStringList('CMHotels', list);
}

urlLauncher(String url) {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

loadingDialog() {
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
}

Future<String> getDeviceName() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (GetPlatform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  } else if (GetPlatform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  }
  return 'No Device Found';
}

String getPlatorm() {
  if (GetPlatform.isAndroid) {
    return 'Android';
  } else if (GetPlatform.isIOS) {
    return 'IOS';
  } else {
    return 'Unknown';
  }
}

Future<bool> isRealDevice() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  return deviceInfo.data['isPhysicalDevice'];
}

String lastTimeFormat(DateTime date, {bool isTime = true}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final messageDate = DateTime(date.year, date.month, date.day);
  final format = isTime ? 'dd/MM/yyyy' : 'd MMMM y';

  if (messageDate == today) {
    return isTime ? DateFormat('hh:mm a').format(date) : 'Today'.tr;
  } else if (messageDate == yesterday) {
    return 'Yesterday'.tr;
  } else {
    return DateFormat(format).format(date);
  }
}

String getRatingText(double rating) {
  if (rating > 4.0) {
    return "Excellent".tr;
  } else if (rating >= 3.0) {
    return "Very Good".tr;
  } else if (rating >= 2.0) {
    return "Good".tr;
  } else {
    return "Fair".tr;
  }
}

loginPrompt({bool isBooking = true}) {
  Get.dialog(
    Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: Container(
          width: 300, // Adjust width as needed
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Login Required'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isBooking ? 'login_required'.tr : 'login_required_content'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Cancel'.tr),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.offAll(const LoginPage());
                    },
                    child: Text('login'.tr),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String getPropertyStarIcon(String rating) {
  switch (rating) {
    case '1':
      return 'https://storage.1929way.app:9000/1929way-stagingserver/static/common_documents/hotel_star_rating/نجمة واحدة One Star .png';
    case '2':
      return 'https://storage.1929way.app:9000/1929way-stagingserver/static/common_documents/hotel_star_rating/نجمتان Two Star .png';
    case '3':
      return 'https://storage.1929way.app:9000/1929way-stagingserver/static/common_documents/hotel_star_rating/ثلاث نجوم Three Star .png';
    case '4':
      return 'https://storage.1929way.app:9000/1929way-stagingserver/static/common_documents/hotel_star_rating/%D8%A7%D8%B1%D8%A8%D8%B9%20%D9%86%D8%AC%D9%88%D9%85%20Four%20Star%20.png';
    case '5':
      return 'https://storage.1929way.app:9000/1929way-stagingserver/static/common_documents/hotel_star_rating/خمس نجوم Five Star .png';
    default:
      return '';
  }
}

String showPropertyStarText(String rating) {
  switch (rating) {
    case '1':
      return 'One Star'.tr;
    case '2':
      return 'Two Star'.tr;
    case '3':
      return 'Three Star'.tr;
    case '4':
      return 'Four Star'.tr;
    case '5':
      return 'Five Star'.tr;
    default:
      return '';
  }
}

void openMailApp(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    // print("Could not launch email app");
  }
}
