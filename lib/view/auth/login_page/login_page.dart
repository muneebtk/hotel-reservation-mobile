import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/common/validEmail/valid_email.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/api/authentication/login_controller.dart';
import 'package:e_concierge_tourism/controller/service/authentication/face_id_auth.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/language/controller/transalate_controller.dart';
import 'package:e_concierge_tourism/utils/Paging/paging.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/auth/login_page/forgot_password.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:e_concierge_tourism/view/auth/register_page/register_page.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/controller/service/location_service/location_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../getx/remember_me.dart';
import '../../../common/button/button.dart';
import '../../../controller/model/auth/login.dart';
import '../../../getx/checkedbox.dart';
import '../widget/loginpage_image.dart';
import '../widget/social_auth.dart';

bool guestUser = false;

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage(
      {super.key, this.isFirstTime = false, this.email, this.passsword});
  final bool isFirstTime;
  final String? email;
  final String? passsword;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RememberMeController rememberMeController =
      Get.put(RememberMeController());

  // Controllers for email and password input fields
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool _isVisibility = true.obs;

  final Rem rem = Get.put(Rem());

  bool _hasSetSavedData = false;

  final LoginController logincontroller = Get.put(LoginController());

  final LanguageController languageController = Get.put(LanguageController());

  String selectedLanguage = Paging.languages.keys.first;
  bool firstTime = false;
  bool showButton = false;

  @override
  void initState() {
    prefillForm();
    firstTime = widget.isFirstTime;
    // print(firstTime);
    if (firstTime) {
      showButton = !firstTime;
    } else {
      showButton = firstTime;
    }

    selectedLanguage = languageController.selectedLanguage.value;
    // print(languageController.selectedLanguage.value);
    super.initState();
  }

  prefillForm() {
    if (widget.email != null && widget.passsword != null) {
      emailController.text = widget.email!;
      passwordController.text = widget.passsword!;
    }
  }

  @override
  Widget build(BuildContext context) {
    rem.ss();
    if (rem.email.isNotEmpty && rem.pass.isNotEmpty && !_hasSetSavedData) {
      emailController.text = rem.email.value;
      passwordController.text = rem.pass.value;
      _hasSetSavedData = true;
    }
    LocationService locationController = Get.put(LocationService());
    var size = MediaQuery.of(context).size;
    double height = size.height;

    return Scaffold(
      body: Stack(
        children: [
          LoginPageImage(
            lang: selectedLanguage,
            height: height,
            onTap: () {
              setState(() {
                firstTime = true;
                showButton = !firstTime;
              });
            },
            icon: showButton ? Icons.arrow_back : null,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height / 3.5),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFAE1F23),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: firstTime
                          ? Column(
                              children: [
                                height10,
                                const Text(
                                  "Select your language",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                height10,
                                const Text(
                                  'Select your preferred language to personalize your experience. You can change your language preference at any time in your settings.',
                                  style: TextStyle(fontSize: 13, color: kWhite),
                                  textAlign: TextAlign.center,
                                ),
                                height10,
                                ...List.generate(
                                    Paging.languages.entries.length, (index) {
                                  final lang =
                                      Paging.languages.values.elementAt(index);
                                  final langkey =
                                      Paging.languages.keys.elementAt(index);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: kWhite,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: RadioListTile(
                                        title: Text(lang),
                                        value: langkey,
                                        groupValue: selectedLanguage,
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedLanguage = value;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                }),
                                height40,
                                ButtonWidget(
                                  ontap: () {
                                    languageController
                                        .changeLanguage(selectedLanguage);
                                    firstTime = false;
                                    showButton = !firstTime;
                                    setState(() {});
                                  },
                                  text: const Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: kWhite,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            )
                          : Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      "login".tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (widget.isFirstTime == false) ...[
                                    const SizedBox(height: 15),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 35),
                                          child: ListTile(
                                            leading: GestureDetector(
                                              onTap: () async {
                                                await biometricAuth();
                                              },
                                              child: GetPlatform.isAndroid
                                                  ? Image.asset(
                                                      'assets/images/image.png',
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.070,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              9.5,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/face id.png',
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.070,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              9.5,
                                                    ),
                                            ),
                                            title: GetPlatform.isAndroid
                                                ? Text(
                                                    "Login with Fingerprint".tr,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    "login_with_face_id".tr,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                            subtitle: GetPlatform.isAndroid
                                                ? const Text(
                                                    "Please put your finger to login",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                : Text(
                                                    "login_faceID_subtitle".tr,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 10),
                                  Text(
                                    "${"email".tr} *",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormFieldWidget(
                                    keyboardType: TextInputType.emailAddress,
                                    color: Colors.white,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'please_enter_email'.tr
                                            : null,
                                    controller: emailController,
                                    hintText: 'enter_Email'.tr,
                                    icon: Icons.person,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "${"password".tr} *",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(
                                    () => TextFormFieldWidget(
                                      iconButtonOntap: () {
                                        _isVisibility.value =
                                            !_isVisibility.value;
                                      },
                                      obseCure: _isVisibility.value,
                                      color: Colors.white,
                                      visibilityIcon: _isVisibility.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? "please_enter_password".tr
                                              : null,
                                      controller: passwordController,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      hintText: "password".tr,
                                      icon: Icons.lock,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(
                                    () => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              fillColor:
                                                  const WidgetStatePropertyAll(
                                                      kWhite),
                                              activeColor: Colors.black,
                                              checkColor: Colors.black,
                                              value: rememberMeController
                                                  .isChecked.value,
                                              onChanged: (newValue) {
                                                rememberMeController.isChecked
                                                    .value = newValue!;
                                              },
                                            ),
                                            Text(
                                              "remember_me".tr,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => ForgotPassword());
                                          },
                                          child: Text(
                                            "forgot_password".tr,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(
                                    () => ButtonWidget(
                                      text: logincontroller.loading.value
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: kWhite,
                                              ),
                                            )
                                          : Text(
                                              "login".tr,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                      ontap: () async {
                                        if (locationController
                                            .currentAddress.isEmpty) {
                                          await locationController
                                              .getLocation();
                                        }
                                        if (!isEmailValid(
                                            emailController.text)) {
                                          showAnimatedSnackBar(
                                            'Email Format is not correct'.tr,
                                            kBlack,
                                          );
                                        } else {
                                          logincontroller.loading.value = true;
                                          await login();
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Center(
                                    child: Text(
                                      "or_continue_with".tr,
                                      style: const TextStyle(
                                          color: Colors.white54),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  SocialAuthentication(),
                                  const SizedBox(height: 20),
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: "dont_have_an_account".tr,
                                        style: const TextStyle(
                                            color: Colors.white54),
                                        children: [
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.to(() => RegisterPage());
                                              },
                                            text: "signup".tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  height5,
                                  height10,
                                  Center(
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Continue as".tr,
                                        style: const TextStyle(
                                            color: Colors.white54),
                                        children: [
                                          TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                guestUser = true;
                                                Get.offAll(const BottomNav(
                                                    guest: 'guestUser',
                                                  ));
                                              },
                                                  
                                            text: "Guest".tr,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//login --------
  Future<void> login() async {
    String fcm = '';
    final deviceName = await getDeviceName();
    if (await isRealDevice()) {
      fcm = await PushNotificationApi().getFcmToken();
    }

    // print(PushNotificationApi().getFcmToken());
    // snackbar('fcm token', fcm);
    if (formKey.currentState!.validate()) {
      final loginUser = LoginUserModel(
          fcmToken: fcm,
          email: emailController.text,
          passsword: passwordController.text,
          platform: getPlatorm(),
          deviceName: deviceName);

      try {
        final success = await logincontroller.loginCheck(loginUser);
        if (success) {
          guestUser =false;
          SharedPreferences pref = await SharedPreferences.getInstance();

          //storing email & password
          await pref.setString('email_for_profile', emailController.text);
          if (rememberMeController.isChecked.value) {
            await pref.setString("email", emailController.text);
            await pref.setString("password_login", passwordController.text);
          }
          if (await isFirstTime()) {
            await setSecondTime();
          }

          //removing email & password of when signup time

          //this is useful when login with biometric (the latest logincredential can make a login)

          await pref.setString('email_text', emailController.text);
          await pref.setString('password', passwordController.text);

          Get.offAll(() => const BottomNav());

          //push notification

          // PushNotificationApi()
          //   .showSuccessNotification(logincontroller.message.value);
        } else {
          showAnimatedSnackBar(logincontroller.message.value, kBlack);
        }
      } catch (e) {
        showAnimatedSnackBar(e.toString(), kBlack);
        Get.snackbar("Failed".tr, e.toString(),
            colorText: Colors.white, backgroundColor: darkRed);
      } finally {
        logincontroller.loading.value = false;
      }
    } else {
      showAnimatedSnackBar(
          "Please enter both your email and password to proceed.".tr, kBlack);

      logincontroller.loading.value = false;
    }
  }

  //biometric auth ---- IOS (FaceID) Android - (Fingerprint) ---
  Future<void> biometricAuth() async {
    try {
      final fcm = await PushNotificationApi().getFcmToken();
      final deviceName = await getDeviceName();
      // print(PushNotificationApi().getFcmToken());
      if (await LocalAuthApi.canAuthenticate()) {
        final authenticated =
            await LocalAuthApi.authenticate("Access secure data");
        if (authenticated) {
          logincontroller.loading.value = true;
          SharedPreferences pref = await SharedPreferences.getInstance();

          //sending email & pass from sharedpref when user login with biometric

          final email = pref.getString('email_text') ?? pref.getString('email');
          final password =
              pref.getString('password') ?? pref.getString('password_login');

          if (email!.isEmpty || password!.isEmpty) {
            return showAnimatedSnackBar(
                'Please Register at one time to Authenticate with biometric'.tr,
                kBlack);
          }
          final biometricUser = LoginUserModel(
              fcmToken: fcm,
              email: email,
              passsword: password,
              deviceName: deviceName,
              platform: GetPlatform.isAndroid ? 'Android' : 'IOS');

          final success = await logincontroller.loginCheck(biometricUser);

          if (success) {
            await pref.setString('email_for_profile', email.toString());
            Get.offAll(() => const BottomNav());
            // PushNotificationApi()
            //     .showSuccessNotification("You have successfully registered".tr);
          } else {
            showAnimatedSnackBar(
                'Please check your credentials and try again.'.tr, kBlack);
          }
        } else {
          showAnimatedSnackBar(
              'Authentication was not completed. Please try again.'.tr, kBlack);
        }
      } else {
        showAnimatedSnackBar(
            'Your device does not support biometric authentication. Please enable it in your device settings.'
                .tr,
            kBlack);
      }
    } catch (e) {
      showAnimatedSnackBar(
          'Please register at one time to authenticate with biometric'.tr,
          kBlack);
    } finally {
      logincontroller.loading.value = false;
    }
  }
  
}
