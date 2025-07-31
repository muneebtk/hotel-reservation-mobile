import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constant/styles/colors.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../controller/api/hotel_booking/room_details/room_details.dart';
import '../../../../common/capitalized_word/capitialize_word.dart';
import '../../../home/widgets/heading_text.dart';
import '../../hotel_detail/widgets/amenities_list.dart';

class RoomDetails extends StatelessWidget {
  final int index;
  final String roomName;
  final String sqft;
  final String bed;
  final String adults;
  const RoomDetails({
    super.key,
    required this.roomName,
    required this.sqft,
    required this.bed,
    required this.adults,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final RoomDetailController roomdetailController =
        Get.put(RoomDetailController());

    // Ensure index is within the range of the rooms list
    if (index >= roomdetailController.rooms.length) {
      return const Center(child: Text("Invalid room index"));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height5,
          HeadingText(heading: roomName),
          height15,
          LayoutBuilder(
            builder: (context, constraints) {
              final room = roomdetailController.rooms[index];

              // Ensure the amenities list is not empty
              if (room.amenities.isEmpty) {
                return Center(child: Text("No amenities available".tr));
              }

              List<AmenityS> staticAmenities =
                  List.generate(room.amenities.length, (i) {
                final data = room.amenities[i];
                return AmenityS(data.icon, data.name);
              });

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: staticAmenities.map((amenity) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        child: ElevatedButton.icon(
                          icon: CachedNetworkImage(
                            imageUrl: amenity.icon,
                            fit: BoxFit.fill,
                            height: 10,
                            width: 10,
                            color: kBlack,
                            errorWidget: (context, url, error) =>
                                const SizedBox.shrink(),
                          ),
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(kWhite),
                          ),
                          label: Text(
                            capitalizeFirstLetter(amenity.text),
                            style: const TextStyle(
                              color: kBlack,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildAmenityCard(BuildContext context, AmenityS amenity) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: kGrey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(width: 4),
            Text(
              amenity.text,
              style: TextStyle(
                fontSize: 12 * MediaQuery.of(context).size.width / 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
