import 'package:e_concierge_tourism/constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/view/home/widgets/heading_text.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyRulesDetails extends StatelessWidget {
  final Map<String, dynamic> policies;
  final String propertyPolicies;

  const PropertyRulesDetails(
      {super.key, required this.policies, required this.propertyPolicies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Policies'.tr),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(children: [
          ...policies.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(heading: entry.key),
                const SizedBox(height: 10),
                ...entry.value.map((policy) => Text("• $policy")),
                height10,
              ],
            );
          }).toList(),
          if (propertyPolicies.isNotEmpty) Text(propertyPolicies),
          const SizedBox(height: 15),
        ]),
      ),
    );
  }
}
