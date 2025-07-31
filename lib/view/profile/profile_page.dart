import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:e_concierge_tourism/constant/styles/colors.dart';
import 'package:e_concierge_tourism/constant/styles/textstyle.dart';
import 'package:e_concierge_tourism/controller/api/profile_management/profile_user_api.dart';
import 'package:e_concierge_tourism/utils/utils.dart';
import 'package:e_concierge_tourism/view/auth/login_page/login_page.dart';
import 'package:e_concierge_tourism/common/capitalized_word/capitialize_word.dart';
import 'package:e_concierge_tourism/common/cupertino_widget/appbar.dart';
import 'package:e_concierge_tourism/common/snackbar/snackbar.dart';
import 'package:e_concierge_tourism/view/profile/pages/refer_and_earn/refer_earn.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../constant/styles/sizedbox.dart';
import 'package:e_concierge_tourism/view/my_bookings/my_booking.dart';
import 'package:e_concierge_tourism/view/favouritesPage/favorites.dart';
import 'package:e_concierge_tourism/view/profile/pages/notification/notifications.dart';
import 'package:e_concierge_tourism/view/profile/pages/settings/settings.dart';
import 'package:e_concierge_tourism/view/profile/pages/wallet/wallets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../getx/remember_me.dart';
import '../../controller/service/image_picker/image_picker_controller.dart';
import '../../language/controller/categorie_name_trans.dart';
import 'pages/manage_account/manage_account.dart';
import 'pages/offer/offers.dart';

bool loadingOnce = true;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileUserApi profileUserApiController = Get.put(ProfileUserApi());
  File? image;
  final EmailForProfile emailController = Get.put(EmailForProfile());
  final SettingsNameController settingsController =
      Get.put(SettingsNameController());
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  Future<void> pickImage() async {
    try {
      // print(await permissionStatus.isGranted);
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      await profileUserApiController.updateProfileImage(imageTemp);
      profileUserApiController.getUserProfileData();
    } catch (e) {
      snackbar("Error", e.toString());
    }
  }

  // final bool = false;
  // final fetchBool = true;
  @override
  void initState() {
    profileUserApiController.getUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'My Profile'.tr,
        automaticallyImplyLeadingANDROID: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (profileUserApiController.loading.value && loadingOnce) {
            return const Center(child: CircularProgressIndicator());
          }
          loadingOnce = false;
          try {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height20,
                profileUserApiController.userData.value.firstname.isEmpty
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: kBlack),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Login Required'.tr,
                                style: textBoldblack,
                              ),
                              height15,
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: WidgetStateProperty.all(
                                          const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)))),
                                      backgroundColor:
                                          WidgetStateProperty.all(darkRed),
                                    ),
                                    onPressed: () {
                                      Get.offAll(const LoginPage());
                                    },
                                    child: Text(
                                      'login'.tr,
                                      style: textBoldwhite,
                                    )),
                              )
                            ],
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Card(
                            elevation: 2,
                            color: kWhite,
                            child: Container(
                              color: kWhite,
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Obx(() {
                                        return CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.blue[100],
                                          backgroundImage:
                                              profileUserApiController
                                                      .userData
                                                      .value
                                                      .profilepic!
                                                      .isNotEmpty
                                                  ? CachedNetworkImageProvider(
                                                      profileUserApiController
                                                          .userData
                                                          .value
                                                          .profilepic!,
                                                    )
                                                  : null,
                                          child: profileUserApiController
                                                  .userData
                                                  .value
                                                  .profilepic!
                                                  .isEmpty
                                              ? Obx(
                                                  () => emailController
                                                          .userNameFirstLetter
                                                          .isNotEmpty
                                                      ? Text(
                                                          emailController
                                                              .userNameFirstLetter
                                                              .value
                                                              .toUpperCase(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 60,
                                                            color: kBlack,
                                                          ),
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              "https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                )
                                              : null,
                                        );
                                      }),
                                      Positioned(
                                        bottom: 7,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.bottomSheet(
                                              Container(
                                                height: 150,
                                                width: double.infinity,
                                                padding: const EdgeInsets.only(
                                                    left: 30),
                                                color: darkRed,
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.image),
                                                        onPressed: () async {
                                                          Get.back();
                                                          handleStoragePermissions();
                                                          // Permission
                                                          //     permissionStatus =
                                                          //     Platform.isIOS
                                                          //         ? Permission
                                                          //             .photos
                                                          //         : Permission
                                                          //             .storage;
                                                          // print(
                                                          //     await permissionStatus
                                                          //         .status);
                                                          // bool result = false;
                                                          // // final
                                                          // if (await permissionStatus
                                                          //         .isGranted ||
                                                          //     await permissionStatus
                                                          //         .isLimited) {
                                                          //   pickImage();
                                                          // } else {
                                                          //   var status =
                                                          //       await permissionStatus
                                                          //           .status;
                                                          //   print(status);
                                                          //   if (status
                                                          //       .isPermanentlyDenied) {
                                                          //     //Open app settings to manually enabling the permisisons
                                                          //     await openAppSettings();
                                                          //   } else {
                                                          //     //request for permissions
                                                          //     result = Platform
                                                          //             .isIOS
                                                          //         ? await Permission
                                                          //             .photos
                                                          //             .request()
                                                          //             .isGranted
                                                          //         : await Permission
                                                          //             .storage
                                                          //             .request()
                                                          //             .isGranted;
                                                          //   }
                                                          //   if (result ==
                                                          //       true) {
                                                          //     pickImage();
                                                          //   }
                                                          // }
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    if (profileUserApiController
                                                        .userData
                                                        .value
                                                        .profilepic!
                                                        .isNotEmpty)
                                                      CircleAvatar(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            Get.back();
                                                            if (GetPlatform
                                                                .isIOS) {
                                                              // iOS dialog
                                                              Get.dialog(
                                                                CupertinoAlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    'Remove Profile',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'IBMPlexSansArabic'),
                                                                  ),
                                                                  content:
                                                                      const Text(
                                                                    'Are you sure you want to remove?',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'IBMPlexSansArabic'),
                                                                  ),
                                                                  actions: <Widget>[
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child: const Text(
                                                                          'Cancel',
                                                                          style:
                                                                              TextStyle(fontFamily: 'IBMPlexSansArabic')),
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        try {
                                                                          final success =
                                                                              await profileUserApiController.imageDelete();
                                                                          if (success) {
                                                                            profileUserApiController.getUserProfileData();
                                                                            Get.back();
                                                                          } else {
                                                                            snackbar("Failed",
                                                                                profileUserApiController.message.value);
                                                                          }
                                                                        } catch (e) {
                                                                          snackbar(
                                                                              'Error',
                                                                              e.toString());
                                                                        }
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        'Remove',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'IBMPlexSansArabic'),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                barrierDismissible:
                                                                    true,
                                                              );
                                                            } else {
                                                              Get.dialog(
                                                                AlertDialog(
                                                                  title: const Text(
                                                                      'Remove Profile'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure you want to remove?'),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child: const Text(
                                                                          'Cancel'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await profileUserApiController
                                                                            .imageDelete();
                                                                        profileUserApiController
                                                                            .getUserProfileData();
                                                                        Get.back();
                                                                      },
                                                                      child: const Text(
                                                                          'Remove'),
                                                                    ),
                                                                  ],
                                                                ),
                                                                barrierDismissible:
                                                                    true,
                                                              );
                                                            }
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              isScrollControlled: true,
                                              enableDrag: true,
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(() {
                                          // if (profileUserApiController
                                          //     .loading.value) {
                                          //   return const SizedBox(
                                          //       height: 20,
                                          //       width: 20,
                                          //       child:
                                          //           CircularProgressIndicator());
                                          //}
                                          return profileUserApiController
                                                  .userData
                                                  .value
                                                  .firstname
                                                  .isNotEmpty
                                              ? Text(
                                                  capitalizeFirstLetter(
                                                      profileUserApiController
                                                          .userData
                                                          .value
                                                          .firstname),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: kBlack,
                                                  ),
                                                )
                                              : const Text(
                                                  'Guest',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                );
                                        }),
                                        Obx(() => (profileUserApiController
                                                    .userData
                                                    .value
                                                    .contactNumber
                                                    ?.isNotEmpty ??
                                                false)
                                            ? Text(
                                                '${profileUserApiController.userData.value.dialCode} ${profileUserApiController.userData.value.contactNumber}',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: kBlack),
                                              )
                                            : const SizedBox()),
                                        const SizedBox(height: 8.0),
                                        Obx(() => profileUserApiController
                                                .userData.value.email.isNotEmpty
                                            ? Text(
                                                profileUserApiController
                                                    .userData.value.email,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: kBlack),
                                              )
                                            : const Text('')),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.rate_review,
                                    color: kBlack),
                                onPressed: () {
                                  Get.to(() => const ManageAcoount());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                height10,
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: settingsController.profilePageText.length - 1,
                      itemBuilder: (context, index) => ListTile(
                        leading: GetPlatform.isIOS
                            ? Icon(cupertinoProfilePageIcons[index])
                            : Icon(profilePageIcon[index]),
                        title:
                            Text(settingsController.profilePageText[index].tr),
                        onTap: () async {
                          if (index == 0) {
                            Get.to(() => const MyBookings(
                                  selectedTye: 'Upcoming',
                                  automaticallyImplyLeading: "ProfilePage",
                                ));
                          }
                          if (index == 1) {
                            Get.to(const OffersProfile());
                          }
                          if (index == 2) {
                            Get.to(() => const FavouritesPage(
                                  favoritesProfile: "2",
                                ));
                          }
                          if (index == 3) {
                            Get.to(() => const WalletsPage());
                          }
                          if (index == 4) {
                            Get.to(() => NotificationPageProfile());
                          }

                          if (index == 5) {
                            if (!await isGuestUser()) {
                              Get.to(() => const ReferEarn());
                            }
                          }
                          if (index == 6) {
                            Get.to(() => SettingsPage());
                          }
                          // if (index == 6) {
                          //   Get.to(() => ManageAcoount());
                          // }
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          } catch (e) {
            snackbar('Failed', e.toString());
          }
          return const SizedBox();
        }),
      ),
    );
  }

  Future<void> handleStoragePermissions() async {
    if (Platform.isAndroid) {
      if (await _isAndroid13OrAbove()) {
        // For Android 13+ (Granular Permissions)
        bool isGranted = await Permission.photos.isGranted;
        if (isGranted) {
          pickImage();
        } else {
          await requestMediaPermissionsAndroid13();
        }
      } else {
        // For below Android 13
        if (await Permission.storage.isGranted) {
          pickImage();
        } else if (await Permission.storage.isPermanentlyDenied) {
          await openAppSettings();
        } else {
          final result = await Permission.storage.request();
          if (result.isGranted) {
            pickImage();
          }
        }
      }
    } else if (Platform.isIOS) {
      // For iOS
      if (await Permission.photos.isGranted ||
          await Permission.photos.isLimited) {
        pickImage();
      } else if (await Permission.photos.isPermanentlyDenied) {
        openAppSettings();
      } else {
        final result = await Permission.photos.request();
        if (result.isGranted) {
          pickImage();
        }
      }
    } else {
      // print("Platform not supported!");
    }
  }

  Future<bool> _isAndroid13OrAbove() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    final versionNumber = int.parse(androidDeviceInfo.version.release);
    // print(versionNumber);
    return versionNumber > 13;
  }

  Future<void> requestMediaPermissionsAndroid13() async {
    if (await Permission.photos.isGranted) {
      pickImage();
    } else if (await Permission.photos.isPermanentlyDenied) {
      openAppSettings();
    } else {
      final result = await Permission.photos.request();
      if (result.isGranted) {
        pickImage();
      }
    }
  }
}

List<String> profilePageText = [
  "bookings".tr,
  "offers".tr,
  "favourites".tr,
  "wallets".tr,
  "notifications".tr,
  "Refer_and_Earn".tr,
  "settings".tr,
  "manage_account".tr
];
List<IconData> profilePageIcon = [
  Icons.calendar_month,
  Icons.local_offer,
  Icons.favorite_border_rounded,
  Icons.credit_card,
  Icons.notifications_none,
  Icons.person_add_alt_1_outlined,
  Icons.settings,
  Icons.account_circle
];
List<IconData> cupertinoProfilePageIcons = [
  CupertinoIcons.calendar,
  CupertinoIcons.tag,
  CupertinoIcons.heart,
  CupertinoIcons.creditcard,
  CupertinoIcons.bell,
  CupertinoIcons.person_add,
  CupertinoIcons.settings,
  CupertinoIcons.person_circle,
];
