import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/controller/service/authentication/face_id_auth.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/language/controller/transalate_controller.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/auth/register_page/one_time_password_page.dart';
import 'package:e_concierge_tourism/common/loading/circular_progress_widget.dart';
import 'package:e_concierge_tourism/controller/model/auth/sign_up.dart';
import 'package:e_concierge_tourism/controller/api/authentication/sign_up_controller.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:e_concierge_tourism/view/auth/widget/loginpage_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/validEmail/valid_email.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../getx/checkedbox.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  //!----------------------------------------------------------------
  final SignUpPageAgreeCheckBox signUpAgreeController =
      Get.put(SignUpPageAgreeCheckBox());
  final LanguageController languageController = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final contactNoController = TextEditingController();
  final countryCodeController = TextEditingController(text: '+968');
  final SignupApi signupApiController = Get.put(SignupApi());
  final formkey = GlobalKey<FormState>();
  final RxBool _isVisibility = true.obs;
  final RxBool _isVisibility2 = true.obs;
  final loading = false.obs;
  String isoCountryCode = 'OM';
  //!----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;

    return Scaffold(
        body: Stack(
      children: [
        //? image-------------

        LoginPageImage(
          lang: languageController.selectedLanguage.value,
          height: height,
          icon: Icons.arrow_back,
        ),

//?-----------------------------------
        Column(
          children: [
            SizedBox(
              height: height / 3.5,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: darkRed,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "sign_up".tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          height15,

                          //? first name and last name ----------------------------

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "first_name".tr,
                                      style: textColorwhite.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormFieldWidget(
                                      color: kWhite,
                                      controller: firstNameController,
                                      keyboardType: TextInputType.name,
                                      hintText: "enter_first_name".tr,
                                      hintStyle: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "last_name".tr,
                                      style: textColorwhite.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 5),
                                    TextFormFieldWidget(
                                      color: kWhite,
                                      controller: lastNameController,
                                      keyboardType: TextInputType.name,
                                      hintText: "enter_last_name".tr,
                                      hintStyle: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          height10,

                          //? password & confirm Password----------------------------
                          Text(
                            "contact_num".tr,
                            style: textColorwhite.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          IntlPhoneField(
                            keyboardType: TextInputType.text,
                            initialCountryCode: "OM",
                            invalidNumberMessage: "invalid_mobile_number".tr,
                            validator: (phone) {
                              if (phone!.number.isEmpty) {
                                Get.snackbar(
                                  'GSM required'.tr,
                                  'please_enter_contact_number'.tr,
                                  backgroundColor: darkRed,
                                  colorText: Colors.white,
                                );
                                return "enter_contact_no".tr;
                              }
                              return null;
                            },
                            controller: contactNoController,
                            pickerDialogStyle: PickerDialogStyle(
                              searchFieldInputDecoration: InputDecoration(
                                  labelText: 'Search country'.tr),
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 18.0, horizontal: 10),
                              fillColor: kWhite,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(),
                              ),
                            ),
                            languageCode:
                                languageController.selectedLanguage.value ==
                                        'English'
                                    ? "en"
                                    : 'ar',
                            onChanged: (phone) {},
                            onCountryChanged: (country) {
                              countryCodeController.text =
                                  '+${country.dialCode}';
                              isoCountryCode = country.code;
                            },
                          ),
                          height5,
                          Text(
                            "${"email".tr} *",
                            style: textColorwhite.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          TextFormFieldWidget(
                            color: kWhite,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: "enter_email_id".tr,
                            hintStyle: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          height10,
                          Text(
                            "${"password".tr} *",
                            style: textColorwhite.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          height10,
                          Obx(
                            () => TextFormFieldWidget(
                              color: kWhite,
                              visibilityIcon: _isVisibility.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              iconButtonOntap: () {
                                _isVisibility.value = !_isVisibility.value;
                              },
                              obseCure: _isVisibility.value,
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              hintText: "password".tr,
                              icon: Icons.lock,
                            ),
                          ),
                          height15,
                          Text(
                            "${"confirm_password".tr} *",
                            style: textColorwhite.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          height10,
                          Obx(
                            () => TextFormFieldWidget(
                              color: kWhite,
                              visibilityIcon: _isVisibility2.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              iconButtonOntap: () {
                                _isVisibility2.value = !_isVisibility2.value;
                              },
                              obseCure: _isVisibility2.value,
                              keyboardType: TextInputType.visiblePassword,
                              controller: confirmPasswordController,
                              hintText: "confirm_password".tr,
                              icon: Icons.lock,
                            ),
                          ),
                          height10,
                          Obx(
                            () => Row(
                              children: [
                                Checkbox(
                                  fillColor:
                                      const WidgetStatePropertyAll(kWhite),
                                  activeColor: kBlack,
                                  checkColor: kBlack,
                                  value: signUpAgreeController.isChecked.value,
                                  onChanged: (newValue) {
                                    signUpAgreeController.isChecked.value =
                                        newValue!;
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(privacyPolicy));
                                  },
                                  child: Text(
                                    "i_agree_with_privacy_policy".tr,
                                    style: textColorwhite.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height10,
                          Obx(
                            () => ButtonWidget(
                              text: loading.value == true
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressindicatorWidget())
                                  : Text(
                                      "sign_up".tr,
                                      style: textColorwhite,
                                    ),
                              //! registering user button----------------------
                              ontap: () async {
                                bool isFormValid =
                                    formkey.currentState!.validate();
                                bool isTermsAgreed =
                                    signUpAgreeController.isChecked.value;

                                if (isFormValid) {
                                  if (firstNameController.text.isEmpty) {
                                    Get.snackbar("First Name required".tr,
                                        "Please enter your first name".tr,
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: darkRed,
                                        colorText: kWhite);
                                  } else if (lastNameController.text.isEmpty) {
                                    Get.snackbar(
                                      backgroundColor: darkRed,
                                      colorText: kWhite,
                                      "Last Name required".tr,
                                      "Please enter your last name".tr,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } else if (emailController.text.isEmpty) {
                                    Get.snackbar(
                                      backgroundColor: darkRed,
                                      colorText: kWhite,
                                      "Email Required".tr,
                                      "Please enter your email".tr,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } else if (!isEmailValid(
                                      emailController.text)) {
                                    Get.snackbar("Failed".tr,
                                        'Email Format is not correct'.tr,
                                        colorText: kWhite,
                                        backgroundColor: darkRed);
                                  } else if (contactNoController.text.isEmpty) {
                                    Get.snackbar(
                                      "Validation Error".tr,
                                      "Please enter your Mobile Number".tr,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } else if (!isTermsAgreed) {
                                    Get.snackbar(
                                      colorText: kWhite,
                                      backgroundColor: darkRed,
                                      "Terms Agreement".tr,
                                      "Please agree to the terms and conditions"
                                          .tr,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } else if (!RegExp(
                                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@#$%^&+=*]).{8,}$')
                                      .hasMatch(passwordController.text)) {
                                    Get.snackbar(
                                      colorText: kWhite,
                                      backgroundColor: darkRed,
                                      "Password Error".tr,
                                      "Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit and one special character"
                                          .tr,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } else if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    Get.snackbar(
                                      colorText: kWhite,
                                      backgroundColor: darkRed,
                                      "Failed".tr,
                                      "Please check your password and confirm password"
                                          .tr,
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  } else if (await LocalAuthApi
                                      .canAuthenticate()) {
                                    final authenticated =
                                        await LocalAuthApi.authenticate(
                                            "Access secure data");
                                    if (authenticated) {
                                      loading.value = true;
                                      await signUpUser();
                                    } else {
                                      Get.snackbar(
                                        colorText: kWhite,
                                        backgroundColor: darkRed,
                                        "Authentication Failed".tr,
                                        "Please try again".tr,
                                        snackPosition: SnackPosition.TOP,
                                      );
                                    }
                                  }
                                } else {
                                  Get.snackbar(
                                    colorText: kWhite,
                                    backgroundColor: darkRed,
                                    "Biometric Authentication".tr,
                                    "Your device does not support biometrics or it is not enabled. Please enable it in your device settings."
                                        .tr,
                                    snackPosition: SnackPosition.TOP,
                                  );
                                }
                              },
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
    ));
  }

  //registering new user

  Future<void> signUpUser() async {
    String fcm = '';
    if (await isRealDevice()) {
      fcm = await PushNotificationApi().getFcmToken();
    }
    final UserModel user = UserModel(
      fcmToken: fcm,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      contactNum: '${contactNoController.text}',
      dialCode: countryCodeController.text,
      countryCode: isoCountryCode,
      emailId: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    try {
      final success = await signupApiController.createUser(user);
      if (success) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('email_text', emailController.text);
        pref.setString('password', passwordController.text);
        pref.setString('first_name', firstNameController.text);
        pref.setString('last_name', lastNameController.text);
        Get.snackbar(
          "Great!",
          signupApiController.message.value,
        );
        Get.to(OneTimePasswordPage(
          email: emailController.text,
          password: passwordController.text,
        ));
        loading.value = false;
      } else {
        Get.snackbar("Failed".tr, signupApiController.message.value,
            backgroundColor: darkRed, colorText: kWhite);
        loading.value = false;
      }
    } catch (e) {
      Get.snackbar("failed_to_sign_up".tr, e.toString(),
          backgroundColor: kBlue[50]);
      loading.value = false;
    }
  }
}
