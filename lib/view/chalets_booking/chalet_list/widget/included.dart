import 'package:flutter/material.dart';

import '../../../../constant/styles/colors.dart';

class ChaletsIncludedOptions extends StatelessWidget {
  final String includedNames;
  final IconData? icon;
  const ChaletsIncludedOptions({
    super.key,
    required this.includedNames,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: kBlack),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              includedNames,
              style: const TextStyle(color: kBlack, fontSize: 12),
            ),
            Icon(
              icon,
              size: 12,
            )
          ],
        ),
      ),
    );
  }
}
