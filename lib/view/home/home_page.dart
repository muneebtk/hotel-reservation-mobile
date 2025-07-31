import 'dart:async';
import 'package:e_concierge_tourism/common/google_search_api/google_search_api.dart';
import 'package:e_concierge_tourism/controller/api/daily_deals/daily_deals.dart';
import 'package:e_concierge_tourism/controller/api/discout_offer/discount_offer.dart';
import 'package:e_concierge_tourism/controller/api/featured_hotel/featured_hotel.dart';
import 'package:e_concierge_tourism/getx/dropdown_chalet_property.dart';
import 'package:e_concierge_tourism/getx/count_of_guest.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_detail/chalet_detail.dart';
import 'package:e_concierge_tourism/view/home/todays_offer_detail_page.dart';
import 'package:e_concierge_tourism/view/home/widgets/discout_offer.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:e_concierge_tourism/view/profile/pages/notification/notifications.dart';
import 'package:e_concierge_tourism/view/profile/pages/wallet/wallets.dart';
import 'package:e_concierge_tourism/view/hotel_booking/search_hotels/search_hotels.dart';
import 'package:e_concierge_tourism/view/home/widgets/heading_text.dart';
import 'package:e_concierge_tourism/controller/service/location_service/location_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constant/images/categories.dart';
import '../../constant/styles/sizedbox.dart';
import '../../language/controller/categorie_name_trans.dart';
import '../chalets_booking/search_page/search_chalets.dart';
import '../profile/profile_page.dart';
import 'widgets/categories_card.dart';
import 'widgets/featured_carosal.dart';
import 'widgets/search_city.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode focus = FocusNode();

  final CategoryNameController categoryController =
      Get.put(CategoryNameController());

  final discountController = Get.put(DiscountOfferApi());
  final dailyDealsController = Get.put(DailyDealsOfferApi());
  final featuredHotelController = Get.put(FeaturedHotelApi());
  // internet connection -------------
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  //-----------------------------------------------

  @override
  void initState() {
    dailyDealsController.dailyDealseOffer();
    discountController.discountOffer();
    featuredHotelController.getFeaturedHotels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    loadingOnce = true;
    // print(
    //     "===========================${dailyDealsController.dailyDealsData[2].image}");

    //---

    //when user quitting application it will show this message

    Future<bool?> showBackDialog() {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('exit_app_title'.tr),
            content: Text(
              'exit_app_content'.tr,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text('No'.tr),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text('Leave'.tr),
                onPressed: () {
                  Navigator.pop(context, true);
                  // SystemNavigator.pop();
                },
              ),
            ],
          );
        },
      );
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    //*--------------------------------------------------------------------
    Get.put(CounterController());
    var size = MediaQuery.of(context).size;
    double screenWidth = size.width;
    Get.put(LocationService());
    LocationService locationController = Get.find();
    Get.put(SearchLocationControllerHome());
    Get.put(SearchLocationController());
    Get.put(SearchCityControllerHome());
    Get.put(PropertyTypeController());
    categoryController.initialize();

    //*---------------------------------------------------------------------

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          // Navigator.of(context).pop();
          SystemNavigator.pop();
          // Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: screenWidth * 0.12, right: screenWidth * 0.05),
                    ),
                    IconButton(
                      onPressed: () {
                        locationController.getLocation();
                      },
                      icon: Icon(
                        Icons.location_on,
                        size: screenWidth / 12,
                        color: Colors.red,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                            onTap: () =>
                                Get.to(() => NotificationPageProfile()),
                            child: const Icon(Icons.notifications)),
                        width10,
                        InkWell(
                            onTap: () => Get.to(() => const WalletsPage()),
                            child: const Icon(Icons.wallet)),
                        width20,
                      ],
                    ),
                  ],
                ),
                Obx(() => Center(
                        child: InkWell(
                      onTap: () {
                        locationController.getLocation();
                      },
                      child: Text(
                        locationController.currentAddress.isEmpty
                            ? "loading".tr
                            : locationController.currentAddress,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ))),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! Search widget-------------------------------------------
                      GetPlatform.isIOS
                          ? SizedBox(
                              height: 40,
                              child: CupertinoSearchTextField(
                                style: const TextStyle(
                                    fontFamily: 'IBMPlexSansArabic'),
                                onTap: () async {
                                  FocusScopeNode currentfocus =
                                      FocusScope.of(context);
                                  if (!currentfocus.hasPrimaryFocus) {
                                    currentfocus.unfocus();
                                  }
                                  await showSearch<String>(
                                    context: context,
                                    delegate: CitySearchDelegateHome(),
                                  );
                                },
                                focusNode: focus,
                                placeholder: "where_would_you_like_to_go".tr,
                                autocorrect: true,
                              ),
                            )
                          : SizedBox(
                              height: 48,
                              child: SearchBar(
                                onTap: () async {
                                  FocusScopeNode currentfocus =
                                      FocusScope.of(context);
                                  if (!currentfocus.hasPrimaryFocus) {
                                    currentfocus.unfocus();
                                  }
                                  await showSearch<String>(
                                    context: context,
                                    delegate: CitySearchDelegateHome(),
                                  );
                                },
                                focusNode: focus,
                                leading: const Icon(
                                  Icons.search,
                                  size: 20,
                                ),
                                hintText: "where_would_you_like_to_go".tr,
                                hintStyle: const WidgetStatePropertyAll(
                                    TextStyle(fontSize: 14)),
                                shape: const WidgetStatePropertyAll(
                                    ContinuousRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)))),
                                elevation: const WidgetStatePropertyAll(0),
                                backgroundColor: const WidgetStatePropertyAll(
                                    Color(0xFFEDF0F9)),
                              ),
                            ),
                      const SizedBox(height: 15),
                      Text(
                        "categories".tr,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      const SizedBox(height: 10),

                      //! categories----------------------------------------------
                      ListView.separated(
                        separatorBuilder: (context, index) => height5,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return CategoriesCard(
                            moreInfoButton: () {
                              focus.unfocus();
                              if (index == 0) {
                                Get.to(() => SearchHotel(index: index));
                              } else if (index == 1) {
                                Get.to(() => ChaletSearchPage());
                              }
                            },
                            categorieNmae:
                                categoryController.categorieName[index],
                            image: categoriesImage[index],
                            ontap: () {
                              if (index == 0) {
                                Get.to(() => SearchHotel(index: index));
                              } else {
                                Get.to(() => ChaletSearchPage());
                              }
                            },
                          );
                        },
                      ),

                      //! featured Hotel------------------------------------------

                      Obx(
                        () {
                          final filteredDeals =
                              featuredHotelController.featuredHotels;

                          // Check if there are any filtered deals
                          if (filteredDeals.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              // if (discountController.discountOfferData.isNotEmpty)
                              HeadingText(heading: "featured_hotel".tr),
                              // if (discountController.discountOfferData.isNotEmpty)
                              const SizedBox(height: 10),
                              // if (discountController.discountOfferData.isNotEmpty)
                              AspectRatio(
                                aspectRatio: 2 / 1.2,
                                child: PageView.builder(
                                    controller: PageController(
                                        viewportFraction:
                                            (filteredDeals.length) > 1
                                                ? .8 / .9
                                                : 1),
                                    itemCount: filteredDeals.length,
                                    pageSnapping: false,
                                    padEnds: false,
                                    itemBuilder: (conext, index) {
                                      final data = filteredDeals[index];
                                      return GestureDetector(
                                        onTap: () {
                                          if (data.type == 'hotel') {
                                            Get.to(HotelDetail(
                                              // roomPrice: data.price.toString(),
                                              hotelId: data.id!,
                                            ));
                                          } else {
                                            Get.to(ChaletsDetail(
                                              id: data.id!,
                                              cityName: data.locality ?? '',
                                              // chaletPrice:
                                              //     data.price.toString(),
                                            ));
                                          }
                                        },
                                        child: FeaturedHotel(
                                          propertiesName:
                                              data.name?.toUpperCase() ?? '',
                                          propertyplace: data.location ?? '',
                                          discountPercentage:
                                              data.discounPercentage!,
                                          newPrice: data.discountedPrice!,
                                          oldPrice: data.price!,
                                          featuredImage: data.mainImage ?? '',
                                        ),
                                      );
                                    }),
                              ),
                              // ConstrainedBox(
                              //     constraints:
                              //         const BoxConstraints(maxHeight: 200),
                              //     child: SizedBox(
                              //       height:
                              //           270, // Match height to desired carousel area
                              //       child: ListView.builder(
                              //         scrollDirection: Axis.horizontal,
                              //         itemCount: filteredDeals.length,
                              //         itemBuilder: (context, index) {
                              //           final data = filteredDeals[index];
                              //           return Padding(
                              //             padding: const EdgeInsets.symmetric(
                              //                 horizontal: 8.0),
                              //             child: InkWell(
                              //               onTap: () {
                              //                 if (data.type == 'hotel') {
                              //                   Get.to(HotelDetail(
                              //                     index: index,
                              //                     roomPrice:
                              //                         data.price.toString(),
                              //                     hotelId: data.id!,
                              //                     favouriteCode: 2,
                              //                   ));
                              //                 } else {
                              //                   Get.to(ChaletsDetail(
                              //                     id: data.id!,
                              //                     index: index,
                              //                     chaletPrice:
                              //                         data.price.toString(),
                              //                   ));
                              //                 }
                              //               },
                              //               child: SizedBox(
                              //                 width: 330,
                              //                 child: FeaturedHotel(
                              //                   propertiesName:
                              //                       data.name?.toUpperCase() ??
                              //                           '',
                              //                   propertyplace:
                              //                       data.location ?? '',
                              //                   discountPercentage:
                              //                       data.discounPercentage!,
                              //                   newPrice: data.discountedPrice!,
                              //                   oldPrice: data.price!,
                              //                   featuredImage:
                              //                       data.mainImage ?? '',
                              //                 ),
                              //               ),
                              //             ),
                              //           );
                              //         },
                              //       ),
                              //     ))
                            ],
                          );
                        },
                      ),

                      //! daily Deals---------------------------------------------

                      Obx(() {
                        return dailyDealsController.dailyDealsData.isEmpty
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  HeadingText(heading: "daily_deals".tr),
                                  Text("lowest_ever_prices_on_top_rated_hotels"
                                      .tr),
                                  const SizedBox(height: 10),
                                  AspectRatio(
                                    aspectRatio: 2 / 1.2,
                                    child: PageView.builder(
                                        controller: PageController(
                                            viewportFraction:
                                                (dailyDealsController
                                                            .dailyDealsData
                                                            .length) >
                                                        1
                                                    ? .8 / .9
                                                    : 1),
                                        itemCount: dailyDealsController
                                            .dailyDealsData.length,
                                        pageSnapping: false,
                                        padEnds: false,
                                        itemBuilder: (conext, index) {
                                          final data = dailyDealsController
                                              .dailyDealsData[index];
                                          return InkWell(
                                            onTap: () {
                                              if (data.categorie == 'hotel') {
                                                Get.to(HotelDetail(
                                                  // roomPrice:
                                                  //     data.price.toString(),
                                                  hotelId: data.id,

                                                  promoId: data.promotionId,
                                                ));
                                              } else {
                                                Get.to(ChaletsDetail(
                                                  id: data.id,
                                                  cityName: data.cityName,
                                                  // chaletPrice:
                                                  //     data.price.toString(),
                                                ));
                                              }
                                            },
                                            child: FeaturedHotel(
                                              propertiesName:
                                                  data.chaletName.toUpperCase(),
                                              propertyplace: data.cityName,
                                              discountPercentage:
                                                  data.discountPercentage!,
                                              newPrice: data.discountedPrice,
                                              oldPrice: data.price,
                                              featuredImage:
                                                  data.image.toString(),
                                            ),
                                          );
                                        }),
                                  ),
                                  // ConstrainedBox(
                                  //   constraints:
                                  //       const BoxConstraints(maxHeight: 200),
                                  //   child: dailyDealsController.loading.value
                                  //       ? Image.network(
                                  //           "https://i.sstatic.net/y9DpT.jpg",
                                  //           width: double.infinity,
                                  //         )
                                  //       : SizedBox(
                                  //           height:
                                  //               270, // Set the height of the carousel
                                  //           child: ListView.builder(
                                  //             scrollDirection: Axis.horizontal,
                                  //             itemCount: dailyDealsController
                                  //                 .dailyDealsData.length,
                                  //             itemBuilder: (context, index) {
                                  //               final data =
                                  //                   dailyDealsController
                                  //                       .dailyDealsData[index];
                                  //               return SizedBox(
                                  //                 width: 330,
                                  //                 child: InkWell(
                                  //                   onTap: () {
                                  //                     if (data.categorie ==
                                  //                         'hotel') {
                                  //                       Get.to(HotelDetail(
                                  //                         index: index,
                                  //                         roomPrice: data.price
                                  //                             .toString(),
                                  //                         hotelId: data.id,
                                  //                         favouriteCode: 2,
                                  //                         promoId:
                                  //                             data.promotionId,
                                  //                       ));
                                  //                     } else {
                                  //                       Get.to(ChaletsDetail(
                                  //                         id: data.id,
                                  //                         index: index,
                                  //                         chaletPrice: data
                                  //                             .price
                                  //                             .toString(),
                                  //                       ));
                                  //                     }
                                  //                   },
                                  //                   child: FeaturedHotel(
                                  //                     propertiesName: data
                                  //                         .chaletName
                                  //                         .toUpperCase(),
                                  //                     propertyplace:
                                  //                         data.cityName,
                                  //                     discountPercentage: data
                                  //                         .discountPercentage!,
                                  //                     newPrice:
                                  //                         data.discountedPrice,
                                  //                     oldPrice: data.price,
                                  //                     featuredImage:
                                  //                         data.image.toString(),
                                  //                   ),
                                  //                 ),
                                  //               );
                                  //             },
                                  //           ),
                                  //         ),
                                  // ),
                                  // if (discountController.discountOfferData.isNotEmpty)
                                  const SizedBox(height: 10),
                                ],
                              );
                      }),

                      //! todays offer--------------------------------------------
                      //  if (discountController.discountOfferData.isNotEmpty)
                      Obx(() => discountController.discountOfferData.isNotEmpty
                          ? HeadingText(heading: "todays_offer".tr)
                          : const SizedBox()),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(
                          () => Row(
                              children: List.generate(
                            discountController.discountOfferData.length,
                            (index) {
                              final data =
                                  discountController.discountOfferData[index];

                              return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () {
                                      //offer details page
                                      Get.to(TodaysOfferDetailPage(
                                        type: data.type,
                                        minSpend: data.minSpend,
                                        code: data.promoCode ?? '',
                                        startDate: data.startDate,
                                        endDate: data.endDate,
                                        discounPercentage:
                                            data.discountPercentage,
                                        description: data.description,
                                        propertyName:
                                            data.chaletName.toString(),
                                        title: data.title,
                                      ));
                                    },
                                    //discount offer widget
                                    child: DiscountOffer(
                                        discountPercentage: discountController
                                            .discountOfferData[index]
                                            .discountPercentage
                                            .toString(),
                                        discounPercentage2: discountController
                                            .discountOfferData[index]
                                            .discountPercentage,
                                        discountCondition: discountController
                                            .discountOfferData[index]
                                            .description),
                                  ));
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
