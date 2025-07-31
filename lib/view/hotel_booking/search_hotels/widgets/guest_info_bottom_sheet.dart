import 'dart:io';

import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../constant/styles/sizedbox.dart';

class GuestInfo extends StatelessWidget {
  final String text;
  final int index;
  final VoidCallback iconIncrement;
  final VoidCallback iconDecrement;
  final String counter;

  const GuestInfo({
    super.key,
    required this.text,
    required this.index,
    required this.iconIncrement,
    required this.iconDecrement,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Platform.isIOS
          ? Card(
              color: kWhite,
              child: CupertinoListTile(
                title: Text(
                  text,
                  style: const TextStyle(fontFamily: 'IBMPlexSansArabic'),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: iconDecrement),
                      ),
                      width10,
                      Text(counter),
                      width10,
                      CircleAvatar(
                        child: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: iconIncrement),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 221, 240, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        text,
                        style: textBoldblack,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            child: IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: iconDecrement),
                          ),
                          width10,
                          Text(counter),
                          width10,
                          CircleAvatar(
                            child: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: iconIncrement),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
