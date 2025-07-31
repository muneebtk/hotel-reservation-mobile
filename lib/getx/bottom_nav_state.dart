import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/my_bookings/my_booking.dart';
import '../view/favouritesPage/favorites.dart';
import '../view/home/home_page.dart';
import '../view/profile/profile_page.dart';

class BottomNavState extends GetxController {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const MyBookings(
      automaticallyImplyLeading: "BottomNav",
      selectedTye: 'Upcoming',
    ),
    const FavouritesPage(
      favoritesProfile: "1",
    ),
    const ProfilePage()
  ];

  int get selectedIndex => _selectedIndex;
  List<Widget> get widgetOptions => _widgetOptions;

  void onItemTapped(int index) {
    _selectedIndex = index;
    update();
  }
}
