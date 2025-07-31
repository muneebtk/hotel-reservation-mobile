import 'dart:convert';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/view/profile/pages/notification/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../main.dart';

class PushNotificationApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  //! Handle Message -----------------------------------------------------------
  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }
    if (message.data.isNotEmpty) {
      final type = message.data['type'];
      if (type == 'login_success') {
        navigatorKey.currentState
            ?.pushNamed(BottomNav.route, arguments: message);
      } else if (type == 'booking_success') {
        navigatorKey.currentState
            ?.pushNamed(NotificationPageProfile.route, arguments: message);
      } else if (type == 'cancellation_hotel') {
        navigatorKey.currentState
            ?.pushNamed(BottomNav.route, arguments: message);
      }
    }
  }

  //! Init Local Notification --------------------------------------------------
  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings("@drawable/ic_launcher");
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // print("Notification clicked with payload: ${response.payload}");
        final Map<String, dynamic> messageData = jsonDecode(response.payload!);
        final message = RemoteMessage.fromMap({'data': messageData});
        handleMessage(message);
      },
    );
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  //! Init Notification --------------------------------------------------
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    //  final fcmToken = await _firebaseMessaging.getToken();
    //  print("fcmtoken: $fcmToken");
    initPushNotifications();
    initLocalNotifications();
    // print("success-----------");f11ebamDQTGs7zO7fhtBrY:APA91bGfgjrmG3oUUCF22OB_MgJMHal3ReCUeaIr13jmbcxbQ0KT2I-pFemTOF3NuHmknNDBUP0CEFd0TFx8C2ppGKqzmqEX3rXQCmjob0v-0XOpB8RavQo
  }

  Future<String> getFcmToken() async {
    _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    // print("fcmtoken: $fcmToken");
    return fcmToken ?? '';
  }

  //! Init Push Notification -------------------------------------------------
  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen((message) {
      print(message.data.toString());
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: "@drawable/ic_launcher",
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(message.data),
      );
    });
  }

  //! Handle Background Message --------------------------------------------------------
  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  //! Login Success Notification --------------------------------------------------------
  void showSuccessNotification(String message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'success_channel',
      'Success Notifications',
      channelDescription: 'Channel for success notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    _localNotifications.show(
      0,
      'Thank you'.tr,
      message,
      platformChannelSpecifics,
      payload: jsonEncode({'type': 'login_success'}),
    );
  }

  //! Booking Success Notification --------------------------------------------------------
  void showSuccessNotificationAfterBook(String hotelName, String name) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'success_channel',
      'Success Notifications',
      channelDescription: 'Channel for success notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    _localNotifications.show(
      0,
      '${"Thank you".tr} $name',
      '${"You have successfully booked!".tr} $hotelName',
      platformChannelSpecifics,
      payload: jsonEncode({'type': 'booking_success'}),
    );
  }

  //!resetting message ------------------------------------
  void showResetInformationNotification() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'success_channel',
      'Success Notifications',
      channelDescription: 'Channel for success notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    _localNotifications.show(
      0,
      'Password Reset Email Sent'.tr,
      'Check your email for instructions to reset your password, if the email is registered with us.'
          .tr
          .tr,
      platformChannelSpecifics,
      payload: jsonEncode({'type': 'password_reset'}),
    );
  }
//! cancell notification-------------------------------------------------------

  void cancellationBookingNotification(String hotelName) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'success_channel',
      'Success Notifications',
      channelDescription: 'Channel for success notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    _localNotifications.show(
      0,
      'Booking Cancelled'.tr,
      '${"Your reservation at".tr} $hotelName ${"has been successfully canceled. We hope to welcome you another time!".tr}'
          .tr,
      platformChannelSpecifics,
      payload: jsonEncode({'type': 'cancellation_hotel'}),
    );
  }
}
