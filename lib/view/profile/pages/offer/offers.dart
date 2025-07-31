import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/view/home/todays_offer_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/styles/sizedbox.dart';
import '../../../../controller/api/discout_offer/discount_offer.dart';
import '../../../home/widgets/discout_offer.dart';

class OffersProfile extends StatefulWidget {
  const OffersProfile({super.key});

  @override
  State<OffersProfile> createState() => _OffersProfileState();
}

class _OffersProfileState extends State<OffersProfile> {
  final discountController = Get.put(DiscountOfferApi());

  @override
  void initState() {
    discountController.discountOffer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: const MyAppBar(title: 'Offers & Deals'),
        body: Padding(
          padding: EdgeInsets.all(screenWidth / 25),
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => discountController.loading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : discountController.discountOfferData.isEmpty
                          ? const Center(child: Text('There is no offer today'))
                          : ListView.separated(
                              separatorBuilder: (context, index) => height10,
                              itemCount:
                                  discountController.discountOfferData.length,
                              itemBuilder: (context, index) {
                                final data =
                                    discountController.discountOfferData[index];
                                return GestureDetector(
                                  onTap: () {
                                    //offer details page
                                    Get.to(TodaysOfferDetailPage(
                                      minSpend: data.minSpend,
                                      type: data.type,
                                      code: data.promoCode ?? '',
                                      startDate: data.startDate,
                                      endDate: data.endDate,
                                      discounPercentage:
                                          data.discountPercentage,
                                      description: data.description,
                                      propertyName: data.chaletName.toString(),
                                      title: data.title,
                                    ));
                                  },
                                  child: DiscountOffer(
                                      discountPercentage:
                                          data.discountPercentage.toString(),
                                      discounPercentage2:
                                          data.discountPercentage,
                                      discountCondition: data.description),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ));
  }
}
