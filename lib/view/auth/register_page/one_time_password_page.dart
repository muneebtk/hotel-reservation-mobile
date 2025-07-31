import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/authentication/register_otp.dart';
import 'package:e_concierge_tourism/controller/api/authentication/resend_otp.dart';
import 'package:e_concierge_tourism/controller/api/authentication/sign_up_controller.dart';
import 'package:e_concierge_tourism/controller/model/auth/register_otp.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/auth/login_page/login_page.dart';
import 'package:e_concierge_tourism/view/auth/register_page/register_page.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OneTimePasswordPage extends StatelessWidget {
  final String email;
  final String password;
  OneTimePasswordPage({super.key, required this.email, required this.password});

  final RegisterPage registerPage = RegisterPage();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final RegisterOtpApi registerOtpController = Get.put(RegisterOtpApi());
  final SignupApi signupApiController = Get.find<SignupApi>();
  final RxBool loading = false.obs;
  final ResendApi resendController = Get.put(ResendApi());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkRed,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              height100,
              TextFormFieldWidget(
                color: kWhite,
                controller: otpController,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter otp'.tr
                    : null,
                keyboardType: TextInputType.number,
                maxLength: 4,
                hintText: 'Enter One Time Password'.tr,
              ),
              height10,
              Obx(
                () => SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: loading.value ? null : _onSubmit,
                    child: loading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: kWhite,
                            ),
                          )
                        : Text('Submit'.tr),
                  ),
                ),
              ),
              //height10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => resendController.loading.value
                        ? Text(
                            "Resending".tr,
                            style: textColorwhite,
                          )
                        : TextButton(
                            onPressed: () async {
                              try {
                                final succes =
                                    await resendController.resend(email);
                                if (succes) {
                                  showAnimatedSnackBar('email_sent'.tr, kBlack);
                                } else {
                                  snackbar("Error".tr,
                                      resendController.message.value);
                                }
                              } catch (e) {
                                snackbar('Error'.tr, e.toString());
                              }
                            },
                            child: Text(
                              "Resend link".tr,
                              style: const TextStyle(
                                  color: kWhite,
                                  decoration: TextDecoration.underline,
                                  decorationColor: kWhite),
                            )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // User registering after succesfully entering otp that come to the mail

  Future<void> _onSubmit() async {
    loading.value = true;
    if (formKey.currentState!.validate()) {
      final model = RegisterOtpModel(
        storedOtp: int.tryParse(otpController.text),
        otp: int.tryParse(otpController.text),
        email: signupApiController.email.value,
      );
      try {
        final success = await registerOtpController.otpSuccessVerify(model);
        if (success) {
          if (await isFirstTime()) {
            await setSecondTime();
          }
          Get.to(
            () => LoginPage(
              passsword: password,
              email: email,
            ),
          );
          showAnimatedSnackBar('successfully logedIn'.tr, Colors.green);
        } else {
          showAnimatedSnackBar(registerOtpController.message.value, darkRed);
        }
      } catch (e) {
        showAnimatedSnackBar(e.toString(), darkRed);
      } finally {
        loading.value = false;
      }
    } else {
      loading.value = false;
    }
  }
}
