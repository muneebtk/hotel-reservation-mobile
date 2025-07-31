import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../getx/bottom_nav_state.dart';

class BottomNav extends StatelessWidget {
  final String? guest;
  const BottomNav({super.key, this.guest});
  static const route = '/bottomNav';

  @override
  Widget build(BuildContext context) {
    if (guest == 'guestUser') {
      clearSharedepref();
    } else {
      guestChecking2();
    }
    return GetBuilder<BottomNavState>(
      init: BottomNavState(),
      builder: (bottomNavState) => Scaffold(
        body: bottomNavState.widgetOptions
            .elementAt(bottomNavState.selectedIndex),
        bottomNavigationBar: SizedBox(
          child: BottomNavigationBar(
            backgroundColor: darkRed,
            selectedItemColor: kWhite,
            unselectedItemColor: const Color.fromARGB(255, 244, 219, 213),
            type: BottomNavigationBarType.values.first,
            items: [
              BottomNavigationBarItem(
                icon: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.home),
                ),
                label: 'home'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.date_range),
                label: 'bookings'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite),
                label: 'favourites'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.account_box),
                label: 'profile'.tr,
              ),
            ],
            currentIndex: bottomNavState.selectedIndex,
            onTap: bottomNavState.onItemTapped,
          ),
        ),
      ),
    );
  }

  void clearSharedepref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    pref.setString('guest', guest.toString());
  }
}

Future<bool> guestCheckingBooking() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey('guest')) {
    return true;
  } else {
    return false;
  }
}

Future<void> guestChecking2() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey('guest')) {
    pref.remove('guest');
  } else {}
}
