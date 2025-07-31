import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:get/get.dart';
import '../../../constant/styles/textstyle.dart';

class LoginPageImage extends StatelessWidget {
  final IconData? icon;
  final String lang;
  final Function()? onTap;
  const LoginPageImage({
    super.key,
    required this.height,
    required this.lang,
    this.icon,
    this.onTap,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    return SizedBox(
      height: height / 3.2,
      width: double.infinity,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(lang == 'English'
              ? "assets/images/login_banner_en.png"
              : "assets/images/login_banner_ar.png"),
          fit: BoxFit.fill,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            height35,
            IconButton(
                onPressed: onTap ??
                    () {
                      Get.back();
                    },
                icon: Icon(
                  icon,
                  color: kWhite,
                )),
            // Center(
            //   child: Image.asset(
            //     "assets/images/Mask group (1).png",
            //     height: screenHeight / 8,
            //     width: screenWidth / 3,
            //   ),
            // ),
            // Center(
            //   child: Text(
            //     "planning_your_stay_simplified".tr,
            //     style: textBoldwhite.copyWith(fontSize: 20),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
