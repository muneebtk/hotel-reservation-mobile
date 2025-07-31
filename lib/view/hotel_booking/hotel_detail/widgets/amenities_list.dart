// import 'package:e_concierge_tourism/constant/styles/colors.dart';
// import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
// import 'package:flutter/material.dart';

// class AmenityS {
//   final String icon;
//   final String text;

//   AmenityS(this.icon, this.text);
// }

// class AmenitiesList extends StatelessWidget {
//   final List<AmenityS> amenities;

//   const AmenitiesList({super.key, required this.amenities});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Wrap(
//           spacing: 9.0,
//           runSpacing: 7.0,
//           children: amenities.map((amenity) {
//             return SizedBox(
//               height: 32,
//               child: ElevatedButton.icon(
//                 icon: amenity.icon.isEmpty
//                     ? const Icon(Icons.add_box)
//                     : Image.network(amenity.icon),
//                 style: ButtonStyle(
//                     backgroundColor: WidgetStatePropertyAll(kGrey[200])),
//                 label: Text(
//                   capitalizeFirstLetter(
//                     amenity.text,
//                   ),
//                   style: const TextStyle(
//                       color: kBlack, fontSize: 12, fontWeight: FontWeight.bold),
//                 ),
//                 onPressed: () {},
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:flutter/material.dart';

class AmenityS {
  final String icon;
  final String text;

  AmenityS(this.icon, this.text);
}

class AmenitiesList extends StatelessWidget {
  final List<AmenityS> amenities;

  const AmenitiesList({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return amenities.isNotEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 9.0,
                runSpacing: 7.0,
                children: amenities.map((amenity) {
                  return SizedBox(
                    height: 32,
                    child: GestureDetector(
                      onTap: () {
                        // Handle tap if necessary
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: kGrey[100],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            amenity.icon.isEmpty
                                ? const Icon(Icons.add_box, size: 16)
                                : Image.network(
                                    amenity.icon,
                                    height: 16,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.add_box, size: 16),
                                  ),
                            const SizedBox(width: 4.0),
                            Text(
                              capitalizeFirstLetter(amenity.text),
                              style: const TextStyle(
                                color: kBlack,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          )
        : const SizedBox.shrink();
  }
}
