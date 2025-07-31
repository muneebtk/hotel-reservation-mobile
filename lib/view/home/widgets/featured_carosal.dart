import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:flutter/material.dart';

class FeaturedHotel extends StatelessWidget {
  final String featuredImage;
  final double discountPercentage;
  final double oldPrice;
  final double newPrice;
  final String propertiesName;
  final String propertyplace;

  const FeaturedHotel({
    super.key,
    required this.featuredImage,
    required this.discountPercentage,
    required this.oldPrice,
    required this.newPrice,
    required this.propertiesName,
    required this.propertyplace,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black.withOpacity(0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: kWhite,
      elevation: 6,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Stack(
          // fit: StackFit.expand,
          children: [
            // Cached Network Image
            Center(
              child: CachedNetworkImage(
                imageUrl: featuredImage,
                fit: BoxFit.cover,
                imageBuilder: (context, imageProvider) => Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Image.network(
                  "https://i.sstatic.net/y9DpT.jpg",
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/property_placeholder.png',
                  fit: BoxFit.contain,
                  width: 80,
                  height: 80,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              propertiesName,
                              maxLines: 2,
                              style: const TextStyle(
                                  color: kWhite, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              propertyplace,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: kWhite),
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          children: [
                            if (discountPercentage > 0)
                              Container(
                                decoration: const BoxDecoration(
                                    color: darkRed,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "$discountPercentage % Off",
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white,
                                        fontSize: 10,
                                        decorationColor: kWhite),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (discountPercentage > 0)
                                        Text(
                                          "$oldPrice OMR",
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black,
                                              fontSize: 9),
                                        ),
                                      width5,
                                      Text(
                                        "${newPrice > 0 ? newPrice : oldPrice} OMR",
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black,
                                            fontSize: 9),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
