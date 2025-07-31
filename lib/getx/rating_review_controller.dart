import 'package:get/get.dart';
import 'dart:io';

class RatingController extends GetxController {
  var isSelected = true.obs;
  var rating = 0.0.obs;
  var userReview = "".obs;
  var images = <File>[].obs;

  void setUserReview(String review) {
    userReview.value = review;
  }

  void addImage(File image) {
    images.add(image);
  }

  void clearData() {
    rating.value = 0.0;
    userReview.value = "";
    images.clear();
  }
}
