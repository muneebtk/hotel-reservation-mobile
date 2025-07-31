import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/hotel_detail/hotel_detail.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';

class CancellationPolicyPage extends StatelessWidget {
  const CancellationPolicyPage({super.key, required this.cancellationPolicy});
  final List<String> cancellationPolicy;

  @override
  Widget build(BuildContext context) {
    HotelDetailsControllerApi controller = Get.find();
    return Scaffold(
      appBar: const MyAppBar(title: "Cancellation Policy"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: cancellationPolicy.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGTuPzdWh2i-w2yysQxaTg1lS73dJGcPkNFA&s"),
                        height15,
                        //const Text("There is no cancellation Policy")
                      ],
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: cancellationPolicy.length,
                itemBuilder: (context, index) {
                  final policy = cancellationPolicy;

                  return Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "• ${policy[index][0].toUpperCase()}${policy[index].substring(1)}",
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

//------

class CancellationPolicyPageChalet extends StatelessWidget {
  const CancellationPolicyPageChalet({super.key});

  @override
  Widget build(BuildContext context) {
    final ChaletSearchApi chalestDetailController = Get.put(ChaletSearchApi());

    HotelDetailsControllerApi controller = Get.find();
    return Scaffold(
      appBar: const MyAppBar(title: "Cancellation Policy"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(
          () => controller.hotelDetails.value.cancellationPolicy.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGTuPzdWh2i-w2yysQxaTg1lS73dJGcPkNFA&s"),
                          height15,
                          //const Text("There is no cancellation Policy")
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount:
                      controller.hotelDetails.value.cancellationPolicy.length,
                  itemBuilder: (context, index) {
                    final cancellationPolicy =
                        controller.hotelDetails.value.cancellationPolicy;

                    return Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "• ${cancellationPolicy[index][0].toUpperCase()}${cancellationPolicy[index].substring(1)}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
