import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/getx/date_picker_controller.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/service/image_picker/image_picker_controller.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/firebase_options.dart';
import 'package:e_concierge_tourism/view/my_bookings/cancelled/cancelled.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/view/profile/pages/notification/notifications.dart';
import 'package:e_concierge_tourism/view/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/service/compare_hotels/favourites_list.dart';
import 'language/transalation_eng_arb/transalator.dart';
import 'common/main/language_controller.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Way1929',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await PushNotificationApi().initNotification();
  Get.put(DatePickerController());
  await ImagePickerController().initDatabase();
  await FavouritesService().initDatabase();
  language();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      // navigatorObservers: [routeObserver],
      translations: MyTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: '1929WAY+',
      theme: ThemeData(
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(color: darkRed),
        timePickerTheme: const TimePickerThemeData(
            backgroundColor: kWhite, shape: BeveledRectangleBorder()),
        dialogBackgroundColor: kWhite,
        datePickerTheme: const DatePickerThemeData(
            backgroundColor: kWhite, shape: BeveledRectangleBorder()),
        cardColor: kWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: kWhite,
          elevation: 1,
        ),
        fontFamily: 'IBMPlexSansArabic',
        scaffoldBackgroundColor: kWhite,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => const SplashScreen(),
        fullscreenDialog: true,
      ),
      initialRoute: '/',
      routes: {
        BottomNav.route: (context) => const BottomNav(),
        NotificationPageProfile.route: (context) => NotificationPageProfile(),
        Cancelled.route: (context) => const Cancelled()
      },
    );
  }
}
