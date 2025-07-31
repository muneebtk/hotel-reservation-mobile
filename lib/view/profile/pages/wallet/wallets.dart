import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/view/auth/login_page/login_page.dart';
import 'package:e_concierge_tourism/view/profile/pages/wallet/controller/wallet_controller.dart';
import 'package:e_concierge_tourism/view/profile/pages/wallet/wallet_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({super.key});

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  final WalletController walletController = Get.put(WalletController());
  @override
  void initState() {
    walletController.getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: MyAppBar(title: 'My Wallet'.tr),
      body: Obx(() {
        if (walletController.loading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          );
        }
        if (walletController.isGuest.value) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Login Required'.tr,
                  style: textBoldblack,
                ),
                height15,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        backgroundColor: WidgetStateProperty.all(darkRed),
                      ),
                      onPressed: () {
                        Get.offAll(const LoginPage());
                      },
                      child: Text(
                        'login'.tr,
                        style: textBoldwhite,
                      )),
                )
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color.fromRGBO(255, 115, 119, 1),
              height: screenHeight / 6,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${'Balance'.tr}*",
                      style: textColorwhite.copyWith(fontSize: 22),
                    ),
                    Text(
                      "OMR ${walletController.balance.value}",
                      style: textBoldwhite.copyWith(fontSize: 27),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        return walletController.isGuest.value || walletController.loading.value
            ? const SizedBox.shrink()
            : Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: ButtonWidget(
                    ontap: () {
                      Get.to(() => WalletPaymentScreen(
                            onRefresh: () {
                              Get.back();
                              showAnimatedSnackBar(
                                  'Fund added successfully', kBlack);
                              walletController.getBalance();
                            },
                          ));
                    },
                    text: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ImageIcon(
                          AssetImage('assets/images/add_money.png'),
                          color: kWhite,
                        ),
                        width10,
                        Text(
                          "Add Money".tr,
                          style: textColorwhite,
                        ),
                      ],
                    )),
              );
      }),
    );
  }
}
