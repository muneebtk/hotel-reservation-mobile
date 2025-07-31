import 'package:e_concierge_tourism/common/animation/snackbar.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/controller/api/hotel_booking/review_rating.dart/review_rating.dart';
import 'package:e_concierge_tourism/common/button/button.dart';
import 'package:e_concierge_tourism/controller/api/upcoming_section/success_details.dart';
import 'package:e_concierge_tourism/controller/model/chalet_bookings/chalet_upcoming_section/chalet_upcoming.dart';
import 'package:e_concierge_tourism/controller/model/hotel_bookings/upcoming_section_hotel/completed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/api/chalets_booking/review_rating/review_rating.dart';
import '../../../getx/rating_review_controller.dart';

class Rating extends StatefulWidget {
  final String? check;
  final String bookingID;
  final UserRatingReview? userRating;
  const Rating(
      {super.key,
      required this.hotelId,
      this.check,
      this.userRating,
      required this.propertyID,
      required this.bookingID});
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String hotelId;
  final String propertyID;

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  final BookingSuccessApiDetails successController = Get.find();
  final RatingController ratingController = Get.put(RatingController());

  final TextEditingController userReviewController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  final RatingReviewApi ratingReviewController = Get.put(RatingReviewApi());

  final RatingReviewChalet ratingControllerchalet =
      Get.put(RatingReviewChalet());

  @override
  void initState() {
    setUserReview();
    super.initState();
  }

  setUserReview() {
    if (widget.userRating != null) {
      ratingController.setUserReview(widget.userRating?.review ?? '');
      ratingController.rating.value = widget.userRating!.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double itemSize = constraints.maxWidth * 0.05;
        double iconPadding = constraints.maxWidth * 0.00;
        return Form(
          key: Rating.formKey,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: kWhite,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      'rate_your_experience'.tr,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          itemSize: itemSize,
                          initialRating: ratingController.rating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding:
                              EdgeInsets.symmetric(horizontal: iconPadding),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: darkRed,
                          ),
                          onRatingUpdate: (rating) {
                            if (!ratingController.isSelected.value) {
                              ratingController.isSelected.value = true;
                            }
                            ratingController.rating.value = rating;
                          },
                        ),
                        if (!ratingController.isSelected.value) ...[
                          height5,
                          Text(
                            'Please select rating'.tr,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          )
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Do you have any thoughts you’d like to share?".tr),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: widget.userRating?.review,
                    enabled: widget.userRating?.review.isEmpty,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter your reason'.tr,
                    ),
                    onChanged: (value) {
                      ratingController.setUserReview(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        // Uncomment and use if needed
                        // IconButton(
                        //   onPressed: () {
                        //     // pickImage();
                        //   },
                        //   icon: const Icon(Icons.camera),
                        // ),
                        // IconButton(
                        //   onPressed: () {
                        //     print(ratingController.rating.value);
                        //     print(ratingController.userReview.value);
                        //     userReviewController.clear();
                        //   },
                        //   icon: const Icon(Icons.send),
                        // ),
                      ],
                    ),
                  ),
                  height10,
                  ButtonWidget(
                    ontap: () async {
                      if (ratingController.rating.value <= 0) {
                        ratingController.isSelected.value = false;
                      } else {
                        if (widget.check == 'chalet') {
                          final success =
                              await ratingControllerchalet.ratingChalet(
                                  widget.propertyID,
                                  ratingController.rating.value.toString(),
                                  ratingController.userReview.value,
                                  widget.bookingID);
                          if (success) {
                            for (var element
                                in successController.mergedCompletedData) {
                              if (element is ChaletBookingUpcoming &&
                                  element.chaletId ==
                                      int.parse(widget.propertyID)) {
                                final userReview = UserRatingReview(
                                    rating:
                                        ratingReviewController.userrating.value,
                                    review:
                                        ratingReviewController.review.value);

                                element.userRating = userReview;
                              }
                            }
                          }
                          if (ratingControllerchalet.message.value.isNotEmpty) {
                            showAnimatedSnackBar(
                              ratingControllerchalet.message.value,
                              kBlack,
                            );
                          }
                        } else {
                          final success = await ratingReviewController.rating(
                              ratingController.rating.value,
                              widget.hotelId,
                              ratingController.userReview.value,
                              widget.bookingID);
                          if (success) {
                            for (var element
                                in successController.mergedCompletedData) {
                              if (element is HotelBookingCompleted &&
                                  element.hotelId ==
                                      int.parse(widget.hotelId)) {
                                final userReview = UserRatingReview(
                                    rating:
                                        ratingReviewController.userrating.value,
                                    review:
                                        ratingReviewController.review.value);

                                element.userRating = userReview;
                              }
                            }
                          }
                          if (ratingReviewController.message.value.isNotEmpty) {
                            showAnimatedSnackBar(
                              ratingReviewController.message.value,
                              kBlack,
                            );
                          }
                        }
                        Get.back();
                      }
                    },
                    text: Text(
                      'Submit'.tr,
                      style: const TextStyle(color: kWhite),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
