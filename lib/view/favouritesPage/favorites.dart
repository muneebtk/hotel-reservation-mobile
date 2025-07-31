import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_detail/chalet_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/api/hotel_booking/favourites_service/favourites.dart';
import '../hotel_booking/hotel_detail/hotel_detail.dart';

class FavouritesPage extends StatefulWidget {
  final String favoritesProfile;

  const FavouritesPage({
    super.key,
    required this.favoritesProfile,
  });

  @override
  FavouritesPageState createState() => FavouritesPageState();
}

class FavouritesPageState extends State<FavouritesPage> {
  final FavouritesApi favouritesApi = FavouritesApi();
  late Future<List<dynamic>> _favouritesFuture;

  @override
  void initState() {
    super.initState();
    _favouritesFuture = favouritesApi.fetchFavourites();
  }

  void _refreshFavourites() {
    setState(() {
      _favouritesFuture = favouritesApi.fetchFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: MyAppBar(
        title: "Favourites".tr,
        automaticallyImplyLeadingANDROID: widget.favoritesProfile == "2",
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _favouritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: darkRed,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/emptyImage/favourites.png'),
                  height20,
                  Text("No Favourites Added".tr),
                ],
              ),
            );
          } else {
            final favouritesData = snapshot.data!;
            return ListView.builder(
              itemCount: favouritesData.length,
              itemBuilder: (context, index) {
                final data = favouritesData[index];
                final bool isChalet = data.containsKey('chalet_id');

                return InkWell(
                  onTap: () {
                    isChalet
                        ? Get.to(() => ChaletsDetail(
                            cityName: data['city'],
                            // chaletPrice: data['total_price'].toString(),
                            id: data['chalet_id']))
                        : Get.to(() => HotelDetail(
                              // roomPrice: "100",
                              hotelId: data["hotelid"],
                            ));
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (isChalet
                                              ? data['chalet_images']
                                              : data['hotelimage']) !=
                                          null &&
                                      (isChalet
                                              ? data['chalet_images']
                                              : data['hotelimage'])
                                          .isNotEmpty
                                  ? Image.network(
                                      isChalet
                                          ? data['chalet_images'][0]
                                          : data['hotelimage'][0],
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                        'assets/emptyImage/placeholder_banner_image.jpg',
                                        width: screenWidth * 0.33,
                                        height: screenWidth * 0.3,
                                      ),
                                      width: screenWidth * 0.33,
                                      height: screenWidth * 0.3,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: screenWidth * 0.33,
                                      height: screenWidth * 0.3,
                                      color: Colors.grey,
                                      child:
                                          const Center(child: Text('No Image')),
                                    ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (isChalet
                                            ? data['chalet_name']
                                            : data['hotelname'])
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 12,
                                      ),
                                      Expanded(
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          isChalet
                                              ? data['city']
                                              : data['city'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenWidth * 0.06),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            'rating'.tr,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            (isChalet
                                                    ? data['avg_rating'] == 0
                                                        ? 5
                                                        : data['avg_rating']
                                                    : data['avgrating'] == 0
                                                        ? 5
                                                        : data['avgrating'])
                                                .toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final prefs = await SharedPreferences
                                              .getInstance();

                                          isChalet
                                              ? favouritesApi
                                                  .removeFavouritesCHALET(
                                                      data['chalet_id'], false)
                                              : await favouritesApi
                                                  .removeFavourites(
                                                      data['hotelid'], false);

                                          await prefs.remove(isChalet
                                              ? 'chalet_${data['chalet_id']}'
                                              : 'hotel_${data['hotelid']}');
                                          _refreshFavourites();
                                        },
                                        child: Text(
                                          'Remove'.tr,
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        ),
                                      ),
                                    ],
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
              },
            );
          }
        },
      ),
    );
  }
}
