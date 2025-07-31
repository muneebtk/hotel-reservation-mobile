import 'package:e_concierge_tourism/common/star_ratings/star_rating.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;

  const RatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return rating > 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: buildStars(rating),
          )
        : const SizedBox.shrink();
  }
}
