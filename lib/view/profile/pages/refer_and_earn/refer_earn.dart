import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/profile/pages/refer_and_earn/controller/refer_and_earn_controller.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../constant/styles/sizedbox.dart';
import 'package:flutter/material.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({super.key});

  @override
  State<ReferEarn> createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
  final ReferAndEarnController referAndEarnController =
      Get.put(ReferAndEarnController());
  @override
  void initState() {
    referAndEarnController.getReferalCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (referAndEarnController.loading.value) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
          return Column(
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 180,
                      child: Image.asset(
                        'assets/images/refer_earn.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.7,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () async {
                                    await Share.share(
                                        'Join 1929 Way App today by clicking the link below to get started. $baseUrl/refer?${referAndEarnController.token.value}');
                                  },
                                  icon: const Icon(Icons.share),
                                  color: kWhite,
                                ),
                              ),
                              Text(
                                'Refer friends, earn rewards! Start sharing today!'
                                    .tr,
                                style: const TextStyle(
                                    color: kWhite, fontWeight: FontWeight.w600),
                              ),
                              height10,
                              Text(
                                'Referral Code'.tr,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: kWhite,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  copyToClipBoard('EARN');
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: darkRed,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'EARN',
                                        style: TextStyle(
                                            letterSpacing: 2,
                                            color: kWhite,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.copy,
                                        color: kWhite,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              height40,
              SizedBox(
                height: 60,
                child: ButtonWidget(
                    ontap: () {
                      urlLauncher(
                          'https://wa.me/?text=Join 1929 Way App today by clicking the link below to get started. $baseUrl/refer?${referAndEarnController.token.value}');
                    },
                    text: Padding(
                      padding: const EdgeInsets.all(.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/5/5e/WhatsApp_icon.png"),
                          width15,
                          Text(
                            "Refer Via Whatsapp".tr,
                            style: const TextStyle(
                              color: kWhite,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              height20,
              InkWell(
                onTap: () {
                  // print(referAndEarnController.token.value);
                  urlLauncher(
                      'sms:&body=Join 1929 Way App today by clicking the link below to get started. $baseUrl/refer?${referAndEarnController.token.value}');
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: darkRed),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                      child: Text(
                        "Refer people from your contact".tr,
                        style: const TextStyle(
                          color: darkRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
