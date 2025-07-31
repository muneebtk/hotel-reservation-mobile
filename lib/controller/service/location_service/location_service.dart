import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

bool isgrantedLocation = false;

//getting customers current location

class LocationService extends GetxController {
  final Rx<LatLng?> _currentPosition = Rx<LatLng?>(null);
  final RxString _currentAddress = RxString('');
  var loading = false.obs;

  LatLng? get currentPosition => _currentPosition.value;
  String get currentAddress => _currentAddress.value;

  var lati = 0.0.obs;
  var longi = 0.0.obs;

  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

//add requesting to enable the location on device

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (Platform.isAndroid &&
          permission == LocationPermission.deniedForever) {
        openLoactionSettings();
      }
    } else if (permission == LocationPermission.deniedForever) {
      openLoactionSettings();
      // await Geolocator.openAppSettings();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  //get location

  Future<void> getLocation() async {
    try {
      loading.value = true;
      bool permissionGranted = await _requestLocationPermission();
      if (permissionGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        double lat = position.latitude;
        double long = position.longitude;
        _currentPosition.value = LatLng(lat, long);
        lati.value = lat;
        longi.value = long;
        updateCurrentAddress();
      } else {
        isgrantedLocation = true;
        _currentAddress.value = '';
      }
      update();
    } catch (_) {
    } finally {
      loading.value = false;
    }
  }

  //updation method of location

  Future<void> updateCurrentAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.value!.latitude,
        _currentPosition.value!.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        _currentAddress.value =
            "${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
      } else {
        _currentAddress.value = "Address not found";
      }
    } catch (e) {
      _currentAddress.value = "location..";
    } finally {
      loading.value = false;
    }
  }

  Future<String?> getCurrentCity() async {
    await getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.value!.latitude,
      _currentPosition.value!.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      return placemark.locality;
    }
    return '';
  }

  openLoactionSettings() {
    return Get.dialog(
      SimpleDialog(
        title: const Text('Location permission'),
        contentPadding: const EdgeInsets.all(20),
        children: [
          const Text(
              'We use your location to show nearby hotels. You can enable this in Settings.'),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              children: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Get.back(),
                ),
                TextButton(
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                      Get.back();
                    },
                    child: const Text('Go to settings')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
