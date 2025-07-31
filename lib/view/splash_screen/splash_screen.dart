import 'dart:async';
import 'dart:io';
import 'package:app_links/app_links.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_detail/chalet_detail.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:e_concierge_tourism/view/profile/pages/settings/settings.dart';
import 'package:e_concierge_tourism/view/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:video_player/video_player.dart';
import '../../language/controller/transalate_controller.dart';
import '../auth/login_page/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LanguageController languageController = Get.put(LanguageController());
  bool isCheck = false;
  // bool isChaeckChalet = false;
  late VideoPlayerController _controller;

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset(
      'assets/videos/splash.mp4',
    )..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.setLooping(true);
  }

  void _initializeDeepLinks() async {
    await _checkLanguageSettings();
    _appLinks = AppLinks();
    _appLinks.getInitialLink().then((uri) {
      _handleIncomingLink(uri);
    });

    _linkSubscription = _appLinks.uriLinkStream.listen(_handleIncomingLink);
  }

  void _handleIncomingLink(Uri? uri) {
    if (uri != null) {
      // debugPrint("Received deep link: ${uri.path}");
      final List<String> segments = uri.pathSegments;

      if (segments[0] == 'hotel' && segments[1] == 'details') {
        final int? hotelId = int.tryParse(segments[2]);
        // final String? roomPrice = uri.queryParameters['roomPrice'];
        isCheck = true;
        if (hotelId != null && isCheck) {
          Get.to(() => HotelDetail(
                hotelId: hotelId,
                // roomPrice: roomPrice ?? '',
              ));
        } else {
          isCheck = false;
          // debugPrint("Invalid hotelId: Unable to parse hotelId to int");
        }
      } else if (segments[0] == 'chalet' && segments[1] == 'details') {
        final int? chaletId = int.tryParse(segments[2]);
        final String cityName = uri.queryParameters['city'] ?? '';
        isCheck = true;

        if (chaletId != null && isCheck) {
          Get.to(() => ChaletsDetail(
                id: chaletId,
                cityName: cityName,
                // chaletPrice: chaletPRICE.toString(),
              ));
        } else {
          isCheck = false;
          // debugPrint("Invalid chalet: Unable to parse hotelId to int");
        }
      } else {
        isCheck = false;
      }
    }
  }

  Future<void> _checkLanguageSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selected_language');
    if (savedLanguage == 'Arabic') {
      languageController.changeLanguage('Arabic');
      hotelDetail_compare_button = true;
    } else {
      languageController.changeLanguage('English');
      hotelDetail_compare_button = false;
    }

    // Navigate to home screen after checking the language settings
    // if (!isCheck) {
    await navigateToHomeScreen();
    // }
  }

  Future<void> navigateToHomeScreen() async {
    loadingOnce = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('loadingOnce', true);
    await Future.delayed(const Duration(seconds: 4));
    // if (!isCheck) {
    if (pref.containsKey("access_token")) {
      Get.off(() => const BottomNav());
    } else {
      final firstTime = await isFirstTime();
      Get.off(() => LoginPage(
            isFirstTime: firstTime,
          ));
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        barrierDismissible: false,
        dialogStyle: Platform.isIOS
            ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,
        // upgrader: Upgrader(debugLogging: true),
        child: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _linkSubscription?.cancel();
    super.dispose();
  }
}
