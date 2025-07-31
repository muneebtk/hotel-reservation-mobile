import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../common/cupertino_widget/appbar.dart';

class CategoriesCard extends StatelessWidget {
  final String image;
  final VoidCallback ontap;
  final String categorieNmae;
  final VoidCallback moreInfoButton;
  const CategoriesCard(
      {super.key,
      required this.ontap,
      required this.image,
      required this.categorieNmae,
      required this.moreInfoButton});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      color: kWhite,
      elevation: 10,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 30 / 9,
            child: Material(
              borderRadius: BorderRadius.circular(40),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Ink.image(
                image: AssetImage(image),
                fit: BoxFit.cover,
                // colorFilter: ColorFilter.mode(
                //   Colors.black.withOpacity(0.3),
                //   BlendMode.colorBurn,
                // ),
                child: InkWell(
                  onTap: ontap,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                height25,
                Text(
                  categorieNmae.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                GetPlatform.isIOS
                    ? SizedBox(
                        height: 40,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          color: kWhite,
                          elevation: 2,
                          child: CupertinoButtonWidget(
                            ontap: moreInfoButton,
                            text: "more_info".tr,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 40,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          color: kWhite,
                          elevation: 2,
                          child: ElevatedButton(
                            onPressed: moreInfoButton,
                            child: Text(
                              "more_info".tr,
                              style: const TextStyle(fontSize: 10),
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
