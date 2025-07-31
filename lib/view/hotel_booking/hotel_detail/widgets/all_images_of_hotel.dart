import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/constant/images/demo.dart';
import 'package:e_concierge_tourism/view/hotel_booking/hotel_detail/widgets/full_screen_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';

//all images of hotel ---
class AllImagesHotels extends StatelessWidget {
  final List<String> images;

  const AllImagesHotels({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'all_image'.tr),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () =>
                        Get.to(() => FullScreenImage(imageUrl: images[index])),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: images[index % images.length],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                              child: Image.network(
                                  loadingImage)), // Placeholder while loading
                          errorWidget: (context, url, error) => const Icon(Icons
                              .error), // Widget displayed if there's an error loading the image
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//------------------------------------------------------------------------------------------------

//the all images of chalet

class AllImagesChalet extends StatelessWidget {
  //final String images;
  final ChaletSearchApi chalestDetailController = Get.put(ChaletSearchApi());

  AllImagesChalet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('all_image'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: chalestDetailController
                    .chaletListDetail[0].chaletImages!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => Get.to(() => FullScreenImageChalet(
                        imageUrl: chalestDetailController
                            .chaletListDetail[0].chaletImages![index].imageUrl
                            .toString())),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          chalestDetailController
                              .chaletListDetail[0].chaletImages![index].imageUrl
                              .toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
