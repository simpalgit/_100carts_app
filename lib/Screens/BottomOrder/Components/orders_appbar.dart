import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';

class MyOrderCustomAppBar extends StatelessWidget {
  final bool fromBottomSheet;
  const MyOrderCustomAppBar({super.key, required this.fromBottomSheet});

  @override
  Widget build(BuildContext context) {
    // var watch = context.watch<CartProvider>();
    // var wishWatch = context.watch<WishlistProvider>();
    return SliverAppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 35,
        pinned: false,
        floating: false,
        iconTheme: const IconThemeData(color: blackColor),
        backgroundColor: whiteColor,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    !fromBottomSheet
                        ? InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back))
                        : const SizedBox(),
                    !fromBottomSheet
                        ? const SizedBox(
                            width: 10,
                          )
                        : const SizedBox(),
                    Text(
                      'Orders',
                      style: GoogleFonts.mukta(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        HomeScreenController controller = Get.find();
                        Get.toNamed(RouteName.searchProductField)!
                            .then((value) => controller.getNearbyHomeData());
                      },
                      child: const Icon(
                        Icons.search,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
