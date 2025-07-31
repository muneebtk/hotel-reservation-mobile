import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/api/hotel_booking/hotel_detail/hotel_detail.dart';
import '../star_ratings/rating_widget.dart';

class RatingsPage extends StatelessWidget {
  final double avgRating;
  final String numberOfRating;
  final String numberOfReview;
  final List<int> ratings;

  final HotelDetailsControllerApi apiController = Get.find();

  RatingsPage(
      {super.key,
      required this.avgRating,
      required this.numberOfRating,
      required this.numberOfReview,
      required this.ratings});

  @override
  Widget build(BuildContext context) {
    // print(apiController.hotelDetails.value.numberRating);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${avgRating ~/ 1}/5',
                style:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RatingWidget(rating: avgRating),
                  Text('$numberOfRating ${"Rating".tr}'),
                  Text('$numberOfReview ${"Reviews".tr}'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: List.generate(5, (index) {
              // final data = apiController.hotelDetails.value;
              // final List<int> ratings = [
              //   data.total5star,
              //   data.total4star,
              //   data.total3star,
              //   data.total2star,
              //   data.total1star
              // ];

              return Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: ratings[index] / 100,
                      backgroundColor: Colors.grey[300],
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${ratings[index]}'),
                ],
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.thumb_up,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Text(
                '$avgRating ${"Average rating".tr}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
