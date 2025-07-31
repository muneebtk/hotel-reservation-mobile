import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/api_service/api_url.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/favourites_service/favourites.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_list_model.dart';
import 'package:e_concierge_tourism/getx/adding_favourite.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_search/search_hotel_controller.dart';
import 'package:e_concierge_tourism/common/compare_properties/compare_properties.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constant/styles/sizedbox.dart';
import '../../../controller/api/authentication/login_controller.dart';
import '../../../getx/searching_hotel_name.dart';
import '../../../controller/service/compare_hotels/favourites_list.dart';
import '../../../controller/model/hotel_bookings/hotel_booking_entire/search_hotels_model.dart';
import '../../../getx/count_of_guest.dart';
import '../../../getx/date_picker_controller.dart';
import '../components/app_bar.dart';
import '../../../common/properties_list_Card/hotel_list_card.dart';
import 'widgets/compare_button.dart';
import 'widgets/like_button_hotel.dart';
import 'widgets/sort_filter_price_widget.dart';
import 'package:http/http.dart' as http;

class HotelList extends StatefulWidget {
  final String hotelName;
  final String cityName;
  final String checkingDate;
  final String checkoutDate;
  final int members;
  final int room;
  final SearchHotelCityNameModel searchData;
  final int index;
  final LatLng? cityLatLng;
  const HotelList({
    super.key,
    required this.searchData,
    required this.index,
    required this.hotelName,
    required this.cityName,
    required this.checkingDate,
    required this.checkoutDate,
    required this.members,
    required this.room, required this.cityLatLng,
  });

  @override
  State<HotelList> createState() => _HotelListState();
}

class _HotelListState extends State<HotelList> {
  final FocusNode focus = FocusNode();

  final ss = Get.put(FavouritesApi);

  final aa = Get.put(CounterController());

  AddingCompare addingCompareController = Get.put(AddingCompare());

  CompareApiController addCompareController = Get.put(CompareApiController());

  final SearchingHotelName searchController = Get.put(SearchingHotelName());

  final SearchHotelCityNameController controller = Get.find();

  final CounterController counterControllerFind = Get.find();

  final DatePickerController datePickercontroller = Get.find();

  final FavouritesService favouriteController = Get.put(FavouritesService());

  final LoginController logincontroller = Get.put(LoginController());
  List<String> list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // FavouritesApi fetchFavourites = FavouritesApi();
    // fetchFavourites.fetchFavourites();

//!------------------------------------------------------------------------------------------
    if (searchController.apical.value) {
      searchController.updateSearchQuery('', controller.hotelList);
      searchController.apical.value = false;
    }
//!-------------------------------------------------------------------------------------------

    String rooms =
        "${counterControllerFind.counters[0]} ${"room".tr}, ${counterControllerFind.counters[1]} ${"adult".tr}${counterControllerFind.counters[2] >= 0 ? ',${counterControllerFind.counters[2]} ${"children".tr}' : ''}";

    // String address =
    //     searchController.filteredHotelsList[index]['hotel_address'];

    //*------------------------------------------------------------------------------------------------------------------------------

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Obx(
          () => Appbar(
              peopleIcon: Icons.people,
              onTap: () {},
              titleOnTap: () {
                Get.back();
              },
              adults: rooms,
              subtitle:
                  "${datePickercontroller.getFormattedDate(datePickercontroller.selectedStartDate.value)} - ${datePickercontroller.getFormattedDate(datePickercontroller.selectedEndDate.value)}",
              trailingTitle: "".tr,
              icon: Icons.more_vert,
              onTapCompare: PopupMenuButton(
                color: kWhite,
                onSelected: (value) {
                  if (value == 'compare') {
                    Get.to(
                      () => ComparePageScreeenHotel(
                        type: 'hotel',
                        update: (id) {
                          for (var element
                              in searchController.filteredHotelsList) {
                            if (element.hotelId == id) {
                              element.isAdded = !element.isAdded;
                              setState(() {});
                              break;
                            }
                          }
                        },
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'compare',
                    child: Text('Compare Hotels'.tr),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
              title: '${widget.cityName} ${'Hotels'.tr}'),
        ),
      ),
      //! search hotel---------------------------------------------------------
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            GetPlatform.isIOS
                ? SizedBox(
                    height: 40,
                    child: CupertinoSearchTextField(
                      style: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
                      onChanged: (value) {
                        searchController.updateSearchQuery(
                            value, controller.hotelList);
                      },
                      focusNode: focus,
                      placeholder: "search_hotels".tr,
                      autocorrect: true,
                    ),
                  )
                : SizedBox(
                    height: 50,
                    child: SearchBar(
                      onChanged: (value) {
                        searchController.updateSearchQuery(
                            value, controller.hotelList);
                      },
                      backgroundColor:
                          const WidgetStatePropertyAll(Color(0xFFEDF0F9)),
                      elevation: const WidgetStatePropertyAll(0),
                      shape: const WidgetStatePropertyAll(
                          ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                      hintText: "search_hotels".tr,
                      hintStyle:
                          const WidgetStatePropertyAll(TextStyle(fontSize: 15)),
                      leading: const Icon(Icons.search),
                    ),
                  ),
            height10,
            //! sort filter price ------------------------
            SortFilterPriceWidget(
              latLng: widget.cityLatLng,
                hotelName: widget.hotelName,
                cityName: widget.cityName,
                checkingDate: widget.checkingDate,
                checkoutDate: widget.checkoutDate,
                members: widget.members,
                room: widget.room),

            height15,
            Obx(
              () => Text(
                widget.cityName.isEmpty
                    ? "${searchController.filteredHotelsList.length} ${'properties found'.tr}"
                    : "${searchController.filteredHotelsList.length} ${'properties found in '.tr} ${widget.cityName}"
                        .tr,
                style:
                    const TextStyle(color: Color.fromARGB(255, 158, 156, 156)),
              ),
            ),
            height15,
            //! Hotel list -----------------------------------------------------
            Expanded(child: Obx(
              () {
                if (searchController.loading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: darkRed,
                    ),
                  );
                } else if (searchController.filteredHotelsList.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/emptyImage/No-Hotel.png"),
                          height15,
                          Text("There is no Hotel in your search".tr),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.separated(
                    separatorBuilder: (context, index) => height10,
                    itemCount: searchController.filteredHotelsList.length,
                    itemBuilder: (context, index) {
                      var hotel = searchController.filteredHotelsList[index];
                      log(hotel.toString());
                      final id = hotel.hotelId ?? 0;
                      final image = (hotel.hotelImage?.isNotEmpty ?? false)
                          ? hotel.hotelImage?.first ?? ''
                          : '';
                      return PropertiesListCard(
                        propertyType: hotel.hoteltype,
                        avgRating: hotel.avguserrating ?? 0,
                        //! deeplinking - hotel sharing to social media
                        sharteButton: () {
                          shareButton(id.toString(), hotel.hotelImage ?? []);
                        },
                        hotelRating2: hotel.avguserrating.toString(),
                        hotelRating: hotel.hotelRating ?? '',
                        offerContainerWidget: OfferContainerWidget(
                            discountPrice:
                                hotel.bestOffersCommon?.discountedPrice ?? 0,
                            discountPercentage:
                                hotel.bestOffersCommon?.discountPercentage ??
                                    '',
                            roomPrice: hotel.pricePerNight ?? 0),
                        //! compare button-----------------
                        labelName: Obx(() => CompareButton(
                              icon: hotel.isAdded
                                  ? const Icon(Icons.done)
                                  : const Icon(Icons.add),
                              text: hotel.isAdded
                                  ? Text(
                                      "Added".tr,
                                      style:
                                          textColorblack.copyWith(fontSize: 12),
                                    )
                                  : Text(
                                      "Compare".tr,
                                      style:
                                          textColorblack.copyWith(fontSize: 12),
                                    ),
                              //adding comapre------
                              ontap: addCompareController.loading.value
                                  ? null
                                  : () async {
                                      final isGuest =
                                          await guestCheckingBooking();
                                      if (isGuest) {
                                        loginPrompt(isBooking: false);
                                        return;
                                      }
                                      if (hotel.isAdded) {
                                        hotel.isAdded = false;
                                        final success =
                                            await addCompareController
                                                .removeFromList(id, 'hotel');
                                        if (!success) {
                                          hotel.isAdded = true;
                                        }
                                        // list.remove(id.toString());

                                        // addingCompareController
                                        //     .toggle(id.toString());
                                      } else {
                                        hotel.isAdded = true;
                                        // addingCompareController
                                        //     .toggle(id.toString());
                                        final success =
                                            await addCompareController
                                                .addProperty(id, 'hotel');
                                        if (!success) {
                                          hotel.isAdded = false;
                                        }
                                        // list.add(id.toString());
                                      }

                                      // prefs.setStringList('CMHotels', list);

                                      // if (addCompareController
                                      //     .successOrNot.value) {
                                      //   //   showAnimatedSnackBar(
                                      //   //       "${hotel['hotel_name']} Removed",
                                      //   //       kBlack);
                                      //   // } else
                                      //   // {
                                      //   showAnimatedSnackBar(
                                      //       "${hotel['hotel_name']} Added",
                                      //       kBlack);
                                      // } else {
                                      //   print(
                                      //     addCompareController.message.value,
                                      //   );
                                      //   showAnimatedSnackBar(
                                      //       addCompareController.message.value,
                                      //       kBlack);
                                      // }
                                      // final pref =
                                      // await SharedPreferences.getInstance();
                                      // final idOfUser = pref.getInt('user_id');
                                      // FavouritesChaletsModel data =
                                      //     FavouritesChaletsModel(
                                      //   userId: idOfUser.toString(),
                                      //   id: hotel['hotel_id'],
                                      //   rating:
                                      //       '${hotel['hotel_rating']} ${"Excellent".tr}',
                                      //   rating2:
                                      //       '("${hotel['hotel_rating']}" ${"ratings".tr})',
                                      //   price:
                                      //       hotel['price_per_night'].toString(),
                                      //   tax: '+${"tax".tr}',
                                      //   offer: '${"Save".tr} 31% ${"Today".tr}',
                                      //   chaletImage: hotel['hotel_image'][0],
                                      //   chalatName: hotel["hotel_name"],
                                      //   address: hotel['hotel_address'],
                                      // );
                                      // bool isAlreadyInFavorites =
                                      //     await favouriteController
                                      //         .isItemInFavorites(data);
                                      // if (addingCompareController
                                      //     .compareStates[index]) {
                                      //   if (!isAlreadyInFavorites) {
                                      //     await favouriteController
                                      //         .addedToFavourites(data);
                                      //   }
                                      // } else {
                                      //   if (isAlreadyInFavorites) {
                                      //     FavouritesChaletsModel? itemToRemove;
                                      //     for (var item in favouriteController
                                      //         .favouriteChaletList) {
                                      //       if (item.chalatName ==
                                      //           data.chalatName) {
                                      //         itemToRemove = item;
                                      //         break;
                                      //       }
                                      //     }
                                      //     if (itemToRemove != null) {
                                      //       await favouriteController
                                      //           .deleteFavouritesItem(
                                      //               itemToRemove);
                                      //     }
                                      //   }
                                      // }
                                    },
                            )),
                        address: hotel.city ??'',
                        hotelName: hotel.hotelName ?? "",
                        hotelImage: CachedNetworkImage(
                          width: double.infinity,
                          height: 200,
                          imageUrl: image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: Image.network(loadingImage),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/property_placeholder.png",
                            fit: BoxFit.contain,
                            width: 80,
                            height: 80,
                          ),
                        ),

                        ontap: () {
                          focus.unfocus();
                          Get.to(() => HotelDetail(
                                favouriteStatusChange: (newValue) {
                                  hotel.isFavorite = newValue;
                                  searchController.filteredHotelsList[index] =
                                      hotel;
                                },

                                hotelId: hotel.hotelId ?? 0,
                                // roomPrice: hotel.pricePerNight.toString(),
                                promoId: hotel.bestOffersCommon?.id,
                              ));
                        },

                        //*  Favourites section (Adding hotels to favourites)

                        likeButton: LikeButton(
                            onchange: (newValue) {
                              hotel.isFavorite = newValue;
                            },
                            isFavorite: hotel.isFavorite,
                            hotelId: hotel.hotelId ?? 0,
                            chaletHotelNameController: hotel.hotelName ?? "",
                            address: hotel.hotelAddress ?? ""),
                      );
                    });
              },
            ))
          ],
        ),
      ),
    );
  }
}

void shareButton(String id, List<String> images) async {
  final link = "$baseUrl/hotel/details/$id";

  try {
    String? imageUrl;
    if (images.isNotEmpty) {
      imageUrl = images[0];
    }

    if (imageUrl != null) {
      // Download the image and save it to a temporary directory
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final imagePath = '${tempDir.path}/hotel_image.jpg';
        final file = File(imagePath);
        await file.writeAsBytes(response.bodyBytes);

        // Create an XFile from the file path
        final xFileImage = XFile(imagePath);

        // Share the image and link text
        await Share.shareXFiles(
          [XFile(xFileImage.path)],
          text: "Check out this awesome property on 1929 Way: $link",
        );
      } else {
        await Share.share('Check out this awesome property on 1929 Way: $link');
      }
    } else {
      await Share.share('Check out this awesome property on 1929 Way: $link');
    }
  } catch (e) {
    await Share.share('Check out this awesome property on 1929 Way: $link');
  }
}
