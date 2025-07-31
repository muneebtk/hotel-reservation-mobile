import 'package:e_concierge_tourism/constant/api_service/api_key.dart';
import 'package:e_concierge_tourism/controller/api/nearby_places/nearby_places.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/styles/colors.dart';

class NearbyPlaceWidget extends StatelessWidget {
  const NearbyPlaceWidget({
    super.key,
    required this.chaletNearbyController,
    required this.latLng,
  });

  final ChaletNearbyControllerr chaletNearbyController;
  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    chaletNearbyController.fetchNearbyPlacesByCityName(latLng);

    Future<void> launchGoogle(String place) async {
      final Uri url = Uri.parse('https://www.google.com/search?q=$place');

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        // Handle the case where the URL can't be launched
      }
    }

    return SizedBox(
      child: Obx(
        () {
          if (chaletNearbyController.isLoading.value) {
            return Center(child: Text("No nearby places found".tr));
          }

          if (chaletNearbyController.nearbyPlaces.isEmpty) {
            return Center(child: Text("No nearby places found".tr));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: getLength(),
            itemBuilder: (context, index) {
              // const url = 'https://flutter.dev';

              // Future<void> launchUrl(String url) async {
              //   final Uri uri = Uri.parse(url);
              //   await launchUrl(uri.toString());
              // }

              var place = chaletNearbyController.nearbyPlaces[index];
              var imageUrl = place.photos.isNotEmpty
                  ? 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${place.photos.first}&key=$googleApiKey'
                  : place.icon;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  tileColor: kGrey.withOpacity(.1),
                  onTap: () => launchGoogle(place.name),
                  leading: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    height: 40,
                    width: 40,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Text(
                    place.distance,
                    style: const TextStyle(fontSize: 12),
                  ),
                  //trailing: const Text("1.9 km")
                ),
              );
            },
          );
        },
      ),
    );
  }

  int getLength() {
    return chaletNearbyController.nearbyPlaces.length > 4
        ? 4
        : chaletNearbyController.nearbyPlaces.length;
  }
}
