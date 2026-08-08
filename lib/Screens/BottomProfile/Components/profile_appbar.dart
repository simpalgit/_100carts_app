import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';

class ProfileCustomAppBar extends StatelessWidget {
  const ProfileCustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 35,
        pinned: true,
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
                    Text(
                      'Profile',
                      style: GoogleFonts.mukta(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Get.toNamed(RouteName.searchProductField),
                      child: const Icon(
                        Icons.search,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
