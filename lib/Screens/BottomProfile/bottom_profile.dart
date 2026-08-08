import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carts_app/Models/user_profile_model.dart';
import 'package:carts_app/Screens/BottomExplore/explore_controller.dart';
import 'package:carts_app/Screens/BottomProfile/bottom_profile_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/navigation_bar_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';

import 'Components/profile_appbar.dart';

class BottomProfileScreen extends StatefulWidget {
  final bool fromBottomSheet;
  const BottomProfileScreen({super.key, required this.fromBottomSheet});

  @override
  State<BottomProfileScreen> createState() => _BottomProfileScreenState();
}

class _BottomProfileScreenState extends State<BottomProfileScreen> {
  final controller = Get.put(BottomProfileController());
  UserProfileModel userProfileModel = UserProfileModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
            child: CustomScrollView(
          slivers: [
            const ProfileCustomAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: settingsCommonCard(
                                child: IconTextScreen(
                              iconText: "Orders",
                              passedIcon: Icons.receipt_outlined,
                              onTapped: () =>
                                  CommonFunctions().checkIfLogin("OrderList"),
                            )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: settingsCommonCard(
                                child: IconTextScreen(
                              iconText: "Wishlist",
                              passedIcon: Icons.favorite_border,
                              onTapped: () =>
                                  CommonFunctions().checkIfLogin("WishList"),
                            )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: settingsCommonCard(
                                child: IconTextScreen(
                              iconText: "Cart",
                              passedIcon: Icons.shopping_bag_outlined,
                              onTapped: () =>
                                  CommonFunctions().checkIfLogin("Cart"),
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      settingsTitle("Account"),
                      const SizedBox(
                        height: 5,
                      ),
                      settingsCommonCard(
                        child: StreamBuilder<UserProfileModel>(
                            stream: Stream.periodic(const Duration(seconds: 1))
                                .asyncMap(
                                    (_) => CommonFunctions().getProfileData()),
                            builder: (context, snapshot) {
                              return ListTile(
                                onTap: () =>
                                    Get.toNamed(RouteName.userProfileScreen),
                                leading: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: darkBlueColor,
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? ""
                                      : snapshot.data == null
                                          ? ""
                                          : snapshot.data!.email ?? "",
                                  style: GoogleFonts.mukta(),
                                ),
                                title: Text(
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? ""
                                      : snapshot.data == null
                                          ? ""
                                          : snapshot.data!.name ?? "",
                                  style: GoogleFonts.mukta(
                                      color: darkBlueColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing:
                                    const Icon(Icons.chevron_right_rounded),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      settingsTitle("My Settings"),
                      const SizedBox(
                        height: 5,
                      ),
                      settingsCommonCard(
                        child: Column(
                          children: [
                            SubTileProfile(
                              iconPassed: Icons.location_on_outlined,
                              subTileString: "My Address",
                              onTapped: () =>
                                  Get.toNamed(RouteName.addAddressScreen),
                            ),
                            const Divider(height: 1, indent: 15, endIndent: 15),
                            SubTileProfile(
                              iconPassed: Icons.account_balance_wallet_outlined,
                              subTileString: "Wallet & Cashback",
                              onTapped: () =>
                                  CommonFunctions().checkIfLogin(RouteName.walletScreen),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      // settingsTitle("Get Help"),
                      // const SizedBox(
                      //   height: 5,
                      // ),
                      // settingsCommonCard(
                      //     child: Column(
                      //   children: [
                      //     SubTileProfile(
                      //       iconPassed: Icons.contact_support_rounded,
                      //       subTileString: "Frequently asked questions",
                      //       onTapped: () {},
                      //     ),
                      //     SubTileProfile(
                      //       iconPassed: Icons.phone_in_talk_outlined,
                      //       subTileString: "Contact us",
                      //       onTapped: () {},
                      //     ),
                      //   ],
                      // )),
                      const SizedBox(
                        height: 10,
                      ),
                      settingsTitle("Others"),
                      const SizedBox(
                        height: 5,
                      ),
                      settingsCommonCard(
                          child: Column(
                        children: [
                          // SubTileProfile(
                          //   iconPassed: Icons.info,
                          //   subTileString: "About us",
                          //   onTapped: () {},
                          // ),
                          // SubTileProfile(
                          //   iconPassed: Icons.star_sharp,
                          //   subTileString: "Rate us",
                          //   onTapped: () {},
                          // ),
                          SubTileProfile(
                            iconPassed: Icons.location_on_outlined,
                            subTileString: "Delete Account",
                            onTapped: () {
                              Get.defaultDialog(
                                  titlePadding: const EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  title: "Delete Account",
                                  titleStyle: GoogleFonts.mukta(
                                      fontWeight: FontWeight.w500,
                                      color: primaryColor,
                                      fontSize: 16),
                                  content: Text(
                                    "This will erase all your data and you cannot create your account again with this mobile number. \n\n Are you sure you want to delete your account ??",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mukta(),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        "Cancel",
                                        style: GoogleFonts.mukta(
                                            color: whiteColor),
                                      ),
                                    ),
                                    Obx(
                                      () => ElevatedButton(
                                        onPressed: controller.isOtpLoading.value
                                            ? null
                                            : () {
                                                controller.getDeleteOtp(
                                                    context,
                                                    darkRoundedPinPut(
                                                        controller, context));
                                              },
                                        child: controller.isOtpLoading.value
                                            ? const CommonButtonLoader(
                                                indicatorColor: whiteColor)
                                            : Text(
                                                "Yes .. Sure!",
                                                style: GoogleFonts.mukta(
                                                    color: whiteColor),
                                              ),
                                      ),
                                    )
                                  ]);
                            },
                          ),
                          SubTileProfile(
                            iconPassed: Icons.logout_rounded,
                            subTileString: "Logout",
                            onTapped: () async {
                              await EasyLoading.show(
                                status: 'Signing Out...',
                                maskType: EasyLoadingMaskType.black,
                              );
                              LocalPreferences().setLoginBool(false);
                              final preferences =
                                  await SharedPreferences.getInstance();
                              await preferences.clear();

                              HomeScreenController mainHomecontroller =
                                  Get.find();

                              final ExploreController exploreController =
                                  Get.find();

                              await mainHomecontroller.getHomeData(
                                  "72.8397", "19.3919");
                              await exploreController.getParentCategory();
                              EasyLoading.dismiss();
                              final homeController =
                                  BottomNavigiationController();

                              homeController.navListener.sink.add(0);
                              mainHomecontroller.onChangeIndex(0);
                              //    CommonFunctions().logOut();
                            },
                          ),
                        ],
                      )),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ]),
            )
          ],
        )),
      ),
    );
  }

  Widget darkRoundedPinPut(
      BottomProfileController provider, BuildContext context) {
    return Pinput(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter OTP.';
        } else {
          return null;
        }
      },
      controller: provider.ctlDeleteOtp.value,

      // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      // listenForMultipleSmsOnAndroid: true,
      defaultPinTheme: PinTheme(
        width: 56,
        height: 56,
        textStyle: GoogleFonts.mukta(
          fontSize: 22,
          color: blackColor,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor, width: 2),
        ),
      ),
      separatorBuilder: (index) => const SizedBox(width: 20),
      // validator: (value) {},
      onTap: () => FocusScope.of(context).unfocus(),

      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
      },
      onChanged: (value) {
        debugPrint('onChanged: $value');
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 1,
            color: whiteColor,
          ),
        ],
      ),
      errorTextStyle:
          GoogleFonts.mukta(color: whiteColor, fontWeight: FontWeight.bold),
      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.pink[300],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.pink[300],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.pink[300],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red),
        ),
      ),
    );
  }
}

class IconTextScreen extends StatelessWidget {
  final String iconText;
  final IconData passedIcon;
  final VoidCallback onTapped;
  const IconTextScreen(
      {super.key,
      required this.iconText,
      required this.passedIcon,
      required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Icon(passedIcon),
            const SizedBox(
              height: 5,
            ),
            Text(
              iconText,
              style: GoogleFonts.mukta(
                  color: darkBlueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

class SubTileProfile extends StatelessWidget {
  final String subTileString;
  final IconData iconPassed;
  final VoidCallback onTapped;
  const SubTileProfile(
      {super.key,
      required this.subTileString,
      required this.iconPassed,
      required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTapped,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconPassed,
              color: darkBlueColor,
            ),
          ],
        ),
        title: Text(
          subTileString,
          style: GoogleFonts.mukta(
              color: darkBlueColor, fontWeight: FontWeight.w500, fontSize: 13),
        ));
  }
}
