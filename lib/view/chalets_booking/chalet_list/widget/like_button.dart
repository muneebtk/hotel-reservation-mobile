// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../constant/styles/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../controller/api/hotel_booking/favourites_service/favourites.dart';

// class LikeButtonChalet extends StatelessWidget {
//   final int hotelId;
//   final int index;
//   final String chaletHotelNameController;
//   final String address;

//   LikeButtonChalet({
//     super.key,
//     required this.chaletHotelNameController,
//     required this.index,
//     required this.address,
//     required this.hotelId,
//   });

//   final FavouritesApi controllerFavourite = Get.put(FavouritesApi());
//   final RxBool isLikeList = false.obs;

//   @override
//   Widget build(BuildContext context) {
//     print(hotelId);
//     Future<void> loadState() async {
//       final prefs = await SharedPreferences.getInstance();
//       final isFavourite = prefs.getBool('hotel_$hotelId') ?? false;
//       isLikeList.value = isFavourite;
//     }

//     loadState();

//     return GestureDetector(
//       onTap: () async {
//         final prefs = await SharedPreferences.getInstance();
//         isLikeList.toggle();

//         debugPrint('$isLikeList');
//         if (isLikeList.isTrue) {
//           await controllerFavourite.addToFavouritesCHALETS(
//               hotelId.toString(), true);
//           await prefs.setBool('hotel_$hotelId', true);
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               duration: const Duration(milliseconds: 700),
//               content: Text(
//                   "${chaletHotelNameController.toUpperCase()} ${"Added to favourites".tr}")));
//         } else {
//           if (isLikeList.isFalse) {
//             await controllerFavourite.removeFavouritesCHALET(hotelId, false);
//             await prefs.remove('hotel_$hotelId');
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 duration: const Duration(milliseconds: 700),
//                 content: Text(
//                   "${chaletHotelNameController.toUpperCase()} ${"Removed from favourites".tr}",
//                 )));
//           }
//         }
//       },
//       child: Obx(
//         () {
//           return AnimatedSwitcher(
//             duration: const Duration(milliseconds: 200),
//             transitionBuilder: (Widget child, Animation<double> animation) {
//               return ScaleTransition(
//                 scale: animation,
//                 child: child,
//               );
//             },
//             child: CircleAvatar(
//                 key: ValueKey<bool>(isLikeList.value),
//                 backgroundColor: kBlack,
//                 child: Icon(
//                   isLikeList.isTrue ? Icons.favorite : Icons.favorite_border,
//                   color: isLikeList.isTrue ? Colors.red : Colors.white,
//                 )),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/bottom_nav.dart/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant/styles/colors.dart';
import '../../../../controller/api/hotel_booking/favourites_service/favourites.dart';

class LikeButtonChalet extends StatelessWidget {
  final int hotelId;
  final String chaletHotelNameController;
  final String address;
  final bool isFavorite;
  final Function(bool) onchange;

  LikeButtonChalet({
    super.key,
    required this.chaletHotelNameController,
    required this.address,
    required this.hotelId,
    required this.isFavorite,
    required this.onchange,
  });

  final FavouritesApi controllerFavourite = Get.put(FavouritesApi());
  final RxBool isLikeList = false.obs;

  Future<void> loadState() async {
    // final prefs = await SharedPreferences.getInstance();
    // final isFavourite = prefs.getBool('chalet_$hotelId') ?? false;
    isLikeList.value = isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    // Load the saved state from SharedPreferences when the widget is built
    loadState();

    return GestureDetector(
      onTap: () async {
        final isGuest = await guestCheckingBooking();
        if (isGuest) {
          loginPrompt(isBooking: false);
          return;
        }
        final prefs = await SharedPreferences.getInstance();
        isLikeList.toggle();
        if (isLikeList.isTrue) {
          onchange(true);
          await controllerFavourite.addToFavouritesCHALETS(
              hotelId.toString(), true);
          await prefs.setBool('chalet_$hotelId', true);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 700),
              content: Text(
                  "${chaletHotelNameController.toUpperCase()} ${"Added to favourites".tr}")));
        } else {
          onchange(false);
          await controllerFavourite.removeFavouritesCHALET(hotelId, false);
          await prefs.remove('chalet_$hotelId');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 700),
              content: Text(
                  "${chaletHotelNameController.toUpperCase()} ${"Removed from favourites".tr}")));
        }
      },
      child: Obx(
        () {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: CircleAvatar(
              key: ValueKey<bool>(isLikeList.value),
              backgroundColor: kBlack,
              child: Icon(
                isLikeList.isTrue ? Icons.favorite : Icons.favorite_border,
                color: isLikeList.isTrue ? Colors.red : Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
