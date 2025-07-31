import 'package:flutter/material.dart';

List<Widget> buildStars(double rating) {
  List<Widget> stars = [];
  int fullStars = rating.floor();
  bool hasHalfStar = (rating - fullStars) >= 0.5;

  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(Icons.star, color: Colors.amber));
  }

  if (hasHalfStar) {
    stars.add(const Icon(Icons.star_half, color: Colors.amber));
  }

  while (stars.length < 5) {
    stars.add(const Icon(Icons.star, color: Colors.grey));
  }

  return stars;
}
