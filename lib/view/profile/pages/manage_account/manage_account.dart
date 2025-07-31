import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/controller/api/profile_management/profile_user_api.dart';
import 'package:e_concierge_tourism/controller/model/profile_user/profile_user_model.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/common/textform/textform_field.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/language/controller/transalate_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../constant/styles/sizedbox.dart';
import 'widget/personal_info.dart';

class ManageAcoount extends StatefulWidget {
  const ManageAcoount({super.key});

  @override
  State<ManageAcoount> createState() => _ManageAcoountState();
}

class _ManageAcoountState extends State<ManageAcoount> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final formkey = GlobalKey<FormState>();

  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final mobileNumber = TextEditingController();
  final countryCodeController = TextEditingController(text: '+968');
  final LanguageController languageController = Get.find();
  ProfileUserApi profileUserController = Get.find();
  String isoCountryCode = 'OM';
  final PersonalInfoController controller = Get.put(PersonalInfoController());

  @override
  void initState() {
    final data = profileUserController.userData.value;
    print(data.toJson());
    isoCountryCode = data.countryCode ?? isoCountryCode;
    print(isoCountryCode);
    if (data.dialCode != null) countryCodeController.text = data.dialCode!;

    firstname.text = data.firstname;
    lastname.text = data.lastname;
    mobileNumber.text = data.contactNumber ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Account".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height10,
                Container(
                  padding: EdgeInsets.only(left: screenWidth / 20),
                  child: Text("Account Details".tr, style: textBoldblack),
                ),
                ListTile(
                  title: Text("Email address".tr),
                  leading: const Icon(Icons.email),
                  subtitle: Obx(() =>
                      profileUserController.userData.value.email.isEmpty
                          ? Text("Guest..".tr)
                          : Text(profileUserController.userData.value.email)),
                ),
                if (profileUserController
                        .userData.value.contactNumber?.isNotEmpty ??
                    false)
                  ListTile(
                    title: Text("Mobile Number".tr),
                    leading: const Icon(Icons.mobile_friendly),
                    subtitle: Text(
                        '${profileUserController.userData.value.dialCode} ${profileUserController.userData.value.contactNumber}'),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Personal Information".tr, style: textBoldblack),
                      height10,
                      Text("First Name".tr, style: textBoldblack),
                      height10,
                      TextFormFieldWidget(
                        controller: firstname,
                        hintText: "Enter First Name".tr,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your first name'.tr;
                          }
                          return null;
                        },
                      ),
                      height10,
                      Text("Last Name".tr, style: textBoldblack),
                      height10,
                      TextFormFieldWidget(
                        controller: lastname,
                        hintText: "Enter Last Name".tr,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your last name'.tr;
                          }
                          return null;
                        },
                      ),
                      height10,
                      Text("Mobile Number".tr, style: textBoldblack),
                      height10,
                      IntlPhoneField(
                        keyboardType: TextInputType.text,
                        initialCountryCode: isoCountryCode,
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
                        controller: mobileNumber,
                        pickerDialogStyle: PickerDialogStyle(
                          searchFieldInputDecoration:
                              InputDecoration(labelText: 'Search country'.tr),
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18.0, horizontal: 10),
                          fillColor: kWhite,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          countryCodeController.text = '+${country.dialCode}';
                          isoCountryCode = country.code;
                        },
                      ),
                      // TextFormFieldWidget(
                      //   controller: mobileNumber,
                      //   hintText: "enter_contact_no".tr,
                      //   validator: (value) {
                      //     if (value?.isEmpty ?? true) {
                      //       return 'please_enter_contact_number'.tr;
                      //     }
                      //     return null;
                      //   },
                      // ),
                      // height10,
                      PersonalInfoForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ButtonWidget(
          ontap: () async {
            if (formkey.currentState!.validate()) {
              final data = ProfileUserModel2(
                  firstname: firstname.text,
                  lastname: lastname.text,
                  dateofbirth: controller.selectedDOB.toString() == ""
                      ? ""
                      : controller.selectedDOB.toString(),
                  gender: controller.selectedGender.toString(),
                  email: profileUserController.userData.value.email,
                  contactNumber: mobileNumber.text,
                  dialCode: countryCodeController.text,
                  countryCode: isoCountryCode);

              try {
                final success =
                    await profileUserController.putUserProfileData(data);
                if (success) {
                  profileUserController.getUserProfileData();
                  Get.back();
                } else {
                  snackbar("Failed", profileUserController.message.value);
                }
              } catch (e) {
                snackbar("Failed", e.toString());
              }
            }
          },
          text: Text(
            "Proceed".tr,
            style: const TextStyle(color: kWhite),
          ),
        ),
      ),
    );
  }
}
