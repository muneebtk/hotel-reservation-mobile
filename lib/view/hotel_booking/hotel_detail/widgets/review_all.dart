import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/hotel_booking_entire/hotel_details.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/star_ratings/rating_widget.dart';
import 'package:e_concierge_tourism/common/ui_property_details_page_widget/ratings_widget.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../constant/styles/sizedbox.dart';
import '../../../../controller/api/hotel_booking/hotel_detail/hotel_detail.dart';
import '../../../home/widgets/heading_text.dart';

class ReviewAllPageDetail extends StatelessWidget {
  final String totalNumberOfReview;
  final String totalNumberOfRating;
  final double averageRating;
  final List<Review> reviews;
  final List<int> ratings;

  ReviewAllPageDetail({
    super.key,
    required this.totalNumberOfReview,
    required this.totalNumberOfRating,
    required this.averageRating,
    required this.reviews,
    required this.ratings,
  });
  final HotelDetailsControllerApi apiController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'All reviews'.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingsPage(
                  ratings: ratings,
                  avgRating: averageRating,
                  numberOfRating: totalNumberOfRating,
                  numberOfReview: totalNumberOfReview),
              height5,
              HeadingText(heading: "Top Reviews".tr),
              height15,
              Text(getRatingText(averageRating)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${"Based on".tr} ($totalNumberOfRating) ${"ratings".tr}",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),

              // if (reviews.isEmpty) {
              //   return const Text("No Reviews");
              // }
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(reviews.length, (index) {
                  DateTime dateTime = DateTime.parse(reviews[index].date);
                  DateFormat dateFormat = DateFormat('d MMMM yyyy');
                  String formattedDate = dateFormat.format(dateTime);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${reviews[index].userName} - $formattedDate',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                RatingWidget(
                                    rating: reviews[index].rating.toDouble())
                              ],
                            ),
                            height10,
                            Text(
                              capitalizeFirstLetter(reviews[index].reviewText),
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
