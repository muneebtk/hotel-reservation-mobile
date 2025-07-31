import 'package:flutter/material.dart';

import '../../constant/styles/colors.dart';

class CircularProgressindicatorWidget extends StatelessWidget {
  const CircularProgressindicatorWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 3,
      backgroundColor: darkRed,
      color: kWhite,
    );
  }
}
