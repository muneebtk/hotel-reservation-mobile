import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/service/push_notification/push_notification_api.dart';
import 'package:e_concierge_tourism/language/controller/transalate_controller.dart';
import 'package:e_concierge_tourism/view/auth/widget/loginpage_image.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/validEmail/valid_email.dart';
import '../../../controller/api/authentication/forgot_password/sending_email.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final forgotEmailController = TextEditingController();
  final LanguageController languageController = Get.find();
  final formkey = GlobalKey<FormState>();
  final ForgotPasswordApi controller = Get.put(ForgotPasswordApi());
  @override
  Widget build(BuildContext context) {
    var loading = false.obs;
    var size = MediaQuery.of(context).size;
    double height = size.height;
    return Scaffold(
      body: Stack(
        children: [
          LoginPageImage(
            lang: languageController.selectedLanguage.value,
            height: height,
            icon: Icons.arrow_back,
          ),
          Form(
            key: formkey,
            child: Column(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height5,
                            Center(
                              child: Text(
                                "Forget Password".tr,
                                style: textBoldwhite.copyWith(fontSize: 17),
                              ),
                            ),
                            height45,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Enter Email".tr,
                                style: const TextStyle(
                                    color: kWhite, fontSize: 15),
                              ),
                            ),
                            height5,
                            Center(
                                child: TextFormFieldWidget(
                              color: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter email".tr;
                                }
                                return null;
                              },
                              controller: forgotEmailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText: "Enter Email".tr,
                            )),
                            height25,

                            //email sending to backend -- for resetting

                            Obx(
                              () => ButtonWidget(
                                ontap: () async {
                                  if (formkey.currentState!.validate()) {
                                    if (!isEmailValid(
                                        forgotEmailController.text)) {
                                      Get.snackbar("Failed",
                                          'Email Format is not correct',
                                          colorText: kWhite,
                                          backgroundColor: darkRed);
                                    } else {
                                      loading.value = true;
                                      try {
                                        final success =
                                            await controller.sendingEmail(
                                                forgotEmailController.text);
                                        if (success) {
                                          //forgotEmailController.clear();
                                          loading.value = false;
                                          Get.back();
                                          PushNotificationApi()
                                              .showResetInformationNotification();
                                        } else {
                                          Get.snackbar("Failed to send mail".tr,
                                              controller.message.value.tr,
                                              backgroundColor: darkRed,
                                              colorText: kWhite);
                                          loading.value = false;
                                        }
                                      } catch (e) {
                                        snackbar('Error', e.toString());
                                        loading.value = false;
                                      }
                                    }
                                  }
                                },
                                text: loading.value
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: kWhite,
                                        ))
                                    : Text(
                                        "Send Link".tr,
                                        style: textColorwhite,
                                      ),
                              ),
                            ),
                            //if otp not coming to the mail
                            //resend option
                            height15,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didnt get the link?".tr,
                                  style: textColorwhite,
                                ),
                                width5,
                                InkWell(
                                  onTap: () async {
                                    loading.value = true;
                                    try {
                                      final success =
                                          await controller.sendingEmail(
                                              forgotEmailController.text);
                                      if (success) {
                                        showDialog(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return Center(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                color: kWhite,
                                                child: const Padding(
                                                  padding: EdgeInsets.all(17.0),
                                                  child: SizedBox(
                                                    height: 40,
                                                    width: 10,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: darkRed,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        Get.back();
                                        PushNotificationApi()
                                            .showResetInformationNotification();
                                        loading.value = false;
                                      } else {
                                        showAnimatedSnackBar(
                                            controller.message.value, darkRed);
                                        loading.value = false;
                                      }
                                    } catch (e) {
                                      showAnimatedSnackBar(
                                          e.toString(), darkRed);

                                      loading.value = false;
                                    }
                                  },
                                  child: Text("Resend link".tr,
                                      style: const TextStyle(
                                          color: kWhite,
                                          decoration: TextDecoration.underline,
                                          decorationColor: kWhite)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
