import 'package:e_concierge_tourism/common/ui_property_details_page_widget/propert_rules_details.dart';
import 'package:e_concierge_tourism/controller/api/chalets_booking/chalet_list_and_detail/chalet_search_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import '../../constant/styles/colors.dart';
import '../../controller/api/hotel_booking/hotel_detail/hotel_detail.dart';

class PropertyRulesCard extends StatelessWidget {
  PropertyRulesCard({super.key, required this.hotelId});
  final String hotelId;
  final HotelDetailsControllerApi apiController =
      Get.put(HotelDetailsControllerApi());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          child: Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final hotelDetails = apiController.hotelDetails.value;
                final hotelPolicies = hotelDetails.policies;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Rules & Info'.tr,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    if (hotelPolicies.isNotEmpty) ...[
                      for (var entry in hotelPolicies.entries.take(1)) ...[
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        if (entry.value.isNotEmpty)
                          Text(
                            "• ${entry.value.first}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        if (entry.value.length > 1 ||
                            (hotelDetails.hotelPolicies.trim().isNotEmpty ??
                                false)) ...[
                          const SizedBox(height: 10.0),
                          InkWell(
                            onTap: () {
                              Get.to(PropertyRulesDetails(
                                propertyPolicies:
                                    hotelDetails.hotelPolicies ?? '',
                                policies:
                                    apiController.hotelDetails.value.policies,
                              ));
                            },
                            child: Text(
                              'View All'.tr,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 15.0),
                      ],
                    ] else if (hotelDetails.hotelPolicies?.trim().isNotEmpty ??
                        false) ...[
                      Text(
                        hotelDetails.hotelPolicies!,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {
                          Get.to(PropertyRulesDetails(
                            propertyPolicies: hotelDetails.hotelPolicies!,
                            policies: apiController.hotelDetails.value.policies,
                          ));
                        },
                        child: Text(
                          'View All'.tr,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                    ] else ...[
                      Text(
                        'No property rules information available.'.tr,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

//*==============================================================================

class PropertyRulesCardChalet extends StatefulWidget {
  PropertyRulesCardChalet({super.key, required this.chaletId});
  final String chaletId;

  @override
  State<PropertyRulesCardChalet> createState() =>
      _PropertyRulesCardChaletState();
}

class _PropertyRulesCardChaletState extends State<PropertyRulesCardChalet> {
  final ChaletSearchApi apiController = Get.put(ChaletSearchApi());

  final translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: double.infinity,
          child: Card(
            color: kWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final chaletDetails = apiController.chaletListDetail;
                // Ensure `chaletDetails` is not empty and `chaletPolicies` exists.
                final chaletPolicies = chaletDetails.isNotEmpty
                    ? chaletDetails[0].chaletPolicies
                    : null;
                print(chaletPolicies);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Rules & Info'.tr,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    if (chaletPolicies != null &&
                        chaletPolicies.isNotEmpty) ...[
                      for (var entry in chaletPolicies.entries.take(1)) ...[
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        if (entry.value.isNotEmpty)
                          Text(
                            "• ${entry.value.first}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        if (entry.value.length > 1 ||
                            chaletDetails.first.about_policies != null) ...[
                          const SizedBox(height: 10.0),
                          InkWell(
                            onTap: () {
                              Get.to(PropertyRulesDetails(
                                propertyPolicies:
                                    chaletDetails.first.about_policies ?? '',
                                policies: chaletPolicies,
                              ));
                            },
                            child: Text(
                              'View All'.tr,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 15.0),
                      ],
                    ] else if (chaletDetails.first.about_policies != null &&
                        chaletDetails.first.about_policies!
                            .trim()
                            .isNotEmpty) ...[
                      Text(
                        chaletDetails.first.about_policies!,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {
                          Get.to(PropertyRulesDetails(
                            propertyPolicies:
                                chaletDetails.first.about_policies!,
                            policies: chaletPolicies ?? {},
                          ));
                        },
                        child: Text(
                          'View All'.tr,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                    ] else ...[
                      Text(
                        'No property rules information available.'.tr,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }

  void translateText(String text) async {
    var translation = await translator.translate(text,
        from: 'en', to: 'ar'); // English to Spanish
    print(translation);
    // setState(() {
    //   translatedText = translation.text;
    // });
    ;
  }
}

// class PropertyRulesCardChalet extends StatelessWidget {
//   PropertyRulesCardChalet({super.key, required this.chaletId});
//   final String chaletId;

//   final ChaletSearchApi apiController = Get.put(ChaletSearchApi());

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SizedBox(
//           width: double.infinity,
//           child: Card(
//             color: kWhite,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             elevation: 4.0,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Obx(() {
//                 final chaletDetails = apiController.chaletListDetail;
//                 final chaletPolicies = chaletDetails[0].chaletPolicies;

//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Property Rules & Info'.tr,
//                       style: const TextStyle(
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 10.0),
//                     if (chaletPolicies!.isNotEmpty) ...[
//                       for (var entry in chaletPolicies.entries.take(1)) ...[
//                         Text(
//                           entry.key,
//                           style: const TextStyle(
//                             fontSize: 15.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 5.0),
//                         ...entry.value.take(1).map((data) => Text(
//                               "• $data",
//                               style: const TextStyle(fontSize: 14.0),
//                             )),
//                         if (entry.value.isNotEmpty) ...[
//                           const SizedBox(height: 10.0),
//                           InkWell(
//                             onTap: () {
//                               Get.to(PropertyRulesDetails(
//                                 hotelPolicies: apiController
//                                     .chaletListDetail[0].chaletPolicies[0],
//                               ));
//                             },
//                             child: const Text(
//                               'View All',
//                               style: TextStyle(
//                                 fontSize: 14.0,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                         ],
//                         const SizedBox(height: 15.0),
//                       ],
//                     ] else ...[
//                       Text(
//                         'No property rules information available.'.tr,
//                         style: const TextStyle(fontSize: 14.0),
//                       ),
//                     ],
//                   ],
//                 );
//               }),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class PropertyRulesCardChalet extends StatelessWidget {
//   PropertyRulesCardChalet({super.key, required this.chaletId});
//   final String chaletId;
//   final ChaletSearchApi apiController = Get.put(ChaletSearchApi());

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SizedBox(
//           width: double.infinity,
//           child: Card(
//             color: kWhite,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             elevation: 4.0,
//           ),
//         );
//       },
//     );
//   }
// }
