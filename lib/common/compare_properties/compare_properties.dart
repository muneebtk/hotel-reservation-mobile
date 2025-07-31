import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/service/compare_hotels/comparison_response.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/getx/adding_favourite.dart';
import 'package:e_concierge_tourism/view/chalets_booking/chalet_detail/chalet_detail.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComparePageScreeenHotel extends StatefulWidget {
  final String type;
  final Function(int) update;
  const ComparePageScreeenHotel(
      {super.key, required this.type, required this.update});

  @override
  State<ComparePageScreeenHotel> createState() =>
      _ComparePageScreeenHotelState();
}

class _ComparePageScreeenHotelState extends State<ComparePageScreeenHotel> {
  final CompareApiController addCompareController =
      Get.put(CompareApiController(), tag: '1');
  AddingCompare addingCompareController = Get.find();
  @override
  void initState() {
    super.initState();
    addCompareController.getCompareList(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Compare Hotels'.tr),
      body: Obx(
        () {
          if (addCompareController.loading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (addCompareController.comparisonList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/emptyImage/Group 1000001750.png'),
                  height20,
                  if (widget.type == 'hotel')
                    Text('No Hotels you added'.tr)
                  else
                    Text('No Chalets you added'.tr)
                ],
              ),
            );
          }
          final filteredList = addCompareController.comparisonList;

          return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final data = filteredList[index];
              return ComparePageScreenWidget(
                type: widget.type,
                data: data,
                controller: addCompareController,
                update: widget.update,
              );
            },
          );
        },
      ),
    );
  }
}

class ComparePageScreenWidget extends StatelessWidget {
  final ComparisonData data;
  final String type;
  final CompareApiController controller;
  final Function(int) update;
  const ComparePageScreenWidget(
      {super.key,
      required this.data,
      required this.type,
      required this.controller,
      required this.update});
  @override
  Widget build(BuildContext context) {
    //List<String> roomTypes = ['Single Room', 'Deluxe Room', 'Family Room'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (type == 'hotel') {
            Get.to(() => HotelDetail(
                  hotelId: data.id ?? 0,
                  // roomPrice: data.price.toString(),
                ));
          } else if (type == 'chalet') {
            Get.to(() => ChaletsDetail(
                  id: data.id ?? 0,
                  cityName: data.location ?? '',
                  // roomPrice: data.price.toString(),
                ));
          }
        },
        child: Card(
          color: kWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //!IMAGE-----------------------------------
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: data.mainImage != null
                          ? Image.network(
                              data.mainImage!,
                              height: MediaQuery.of(context).size.height / 6,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.network(loadingImage),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(loadingImage),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 15,
                  //   left: 15,
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(7),
                  //       ),
                  //       color: Colors.green,
                  //     ),
                  //     padding: const EdgeInsets.all(5),
                  //     child: Text(
                  //       '10% Offer Going on'.tr,
                  //       style: const TextStyle(color: Colors.white, fontSize: 12),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.name ?? '',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        if (data.location != null &&
                            data.location!.isNotEmpty) ...[
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data.location!,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        if ((data.rating ?? 0) > 0 && data.rating != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 5,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all()),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 13,
                                ),
                                width5,
                                Text(
                                  data.rating!.toStringAsFixed(1),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    // const SizedBox(height: 5),
                    if (data.roomType != null && data.roomType!.isNotEmpty)
                      Wrap(
                        children: [
                          ...List.generate(
                            data.roomType!.length,
                            (index) => Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 5,
                              ),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all()),
                              child: Text(
                                data.roomType?[index] ?? '',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${data.price} OMR + ${"Tax".tr}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                if (data.id != null) {
                                  controller.removeFromList(data.id!, type);
                                  controller.comparisonList.remove(data);
                                  // removecompareHotelFromLocal(
                                  //     data.id!.toString());
                                  if (data.id != null) update(data.id!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              child: Text(
                                'Remove'.tr,
                                style: const TextStyle(color: kWhite),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomType extends StatelessWidget {
  final String roomTypeText;
  const RoomType({super.key, required this.roomTypeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          roomTypeText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}

class UserId extends GetxController {
  var userId = 0.obs;
  void user() async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getInt("user_id");
    userId.value = value!;
  }
}
