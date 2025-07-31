import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/my_bookings/upcoming/view_more_details_page.dart';
import 'package:e_concierge_tourism/view/profile/pages/wallet/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WalletPaymentScreen extends StatefulWidget {
  const WalletPaymentScreen({super.key, required this.onRefresh});
  final Function() onRefresh;

  @override
  State<WalletPaymentScreen> createState() => _WalletPaymentScreenState();
}

class _WalletPaymentScreenState extends State<WalletPaymentScreen> {
  final WalletController walletController = Get.find();
  final TextEditingController amountController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final paymentMethodname = ['O Pay', 'Apple Pay', 'Google Pay', 'Card'];

  final paymentMethodImage = [
    'opay-log.png',
    'apple_pay.png',
    'gpay.png',
    'card.png'
  ];

  int? selectedIndex;
  bool showError = false;

  @override
  void initState() {
    walletController.showError.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'My Wallet'.tr),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height20,
            Text(
              'Amount'.tr,
              style: const TextStyle(color: kBlack),
            ),
            height10,
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                forceErrorText: null,
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(signed: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount'.tr;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: '100 OMR',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor: lightGrey),
              ),
            ),
            height10,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'service_charge'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  // color: Colors.redAccent, // You can change the color to match your theme
                ),
              ),
            )
            // Text(
            //   "Select Payment Method".tr,
            //   style: const TextStyle(color: kBlack),
            // ),
            // height10,
            // GridView.count(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   childAspectRatio: 5 / 3,
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 10,
            //   mainAxisSpacing: 10,
            //   children: [
            //     ...List.generate(
            //       4,
            //       (index) => InkWell(
            //         onTap: () {
            //           if (walletController.showError.value) {
            //             walletController.showError.value = false;
            //           }
            //           setState(() {
            //             selectedIndex = index;
            //           });
            //         },
            //         child: Container(
            //           decoration: BoxDecoration(
            //               border: Border.all(
            //                   color: selectedIndex == index
            //                       ? darkRed
            //                       : Colors.transparent),
            //               borderRadius: BorderRadius.circular(10),
            //               color: lightGrey),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               height10,
            //               Flexible(
            //                 child: Image.asset(
            //                     'assets/images/${paymentMethodImage[index]}'),
            //               ),
            //               height10,
            //               Text(paymentMethodname[index]),
            //               height10,
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // height10,
            // Obx(() => walletController.showError.value
            //     ? Text(
            //         "Select Payment Method".tr,
            //         style: TextStyle(
            //             color: Theme.of(context).colorScheme.error,
            //             fontSize: 13),
            //       )
            //     : const SizedBox.shrink())
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (walletController.loading.value) {
          return const SizedBox.shrink();
        }
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: ButtonWidget(
            ontap: () async {
              if (validation()) {
                loadingDialog();
                final success = await walletController
                    .addMoneyToWallet(amountController.text);
                if (success != null) {
                  // final controller = WebViewController()
                  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  //   ..setNavigationDelegate(
                  //     NavigationDelegate(
                  //       onProgress: (int progress) {
                  //         // Update loading bar.
                  //       },
                  //       onPageStarted: (String url) {},
                  //       onPageFinished: (String url) {},
                  //       onUrlChange: (UrlChange url) async {
                  //         print(url.url);
                  //         if (url.url?.startsWith(
                  //                 '$baseUrl/common/wallet-payment-status?status=success') ??
                  //             false) {
                  //           await Future.delayed(const Duration(seconds: 3),
                  //               () {
                  //             Get.back();
                  //             widget.onRefresh();
                  //           });
                  //         } else if (url.url?.startsWith(
                  //                 '$baseUrl/common/wallet-payment-status?status=failed') ??
                  //             false) {
                  //           await Future.delayed(
                  //               const Duration(seconds: 3), () => Get.back());
                  //           // snackbar('Failed'.tr, 'Payment failed');
                  //         }
                  //       },
                  //       onHttpError: (HttpResponseError error) {},
                  //       onWebResourceError: (WebResourceError error) {},
                  //     ),
                  //   )
                  //   ..loadRequest(Uri.parse(success));
                  Get.off(() => PaymentWebView(
                        paymentUrl: success,
                        onRefresh: widget.onRefresh,
                        // controller: controller,
                        // loading: false,
                      ));
                } else {
                  Navigator.of(context).pop();
                  snackbar('Failed'.tr, walletController.message.value);
                }

                // Navigator.of(context).pop();

                // if (success) {
                //   showAnimatedSnackBar(walletController.message.value, kBlack);
                //   selectedIndex = null;
                //   amountController.clear();
                // } else {
                // }
              }
            },
            text: Text("continue".tr, style: textColorwhite),
          ),
        );
      }),
    );
  }

  validation() {
    if (_formKey.currentState!.validate()) {
      return true;
    } else if (selectedIndex == null) {
      walletController.showError.value = true;
    }
    return false;
  }
}
