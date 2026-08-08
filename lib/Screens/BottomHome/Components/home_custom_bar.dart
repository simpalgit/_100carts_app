import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';

class HomeCustomAppBar extends StatelessWidget {
  final Widget passedWidget;
  const HomeCustomAppBar({super.key, required this.passedWidget});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        pinned: false,
        floating: false,
        iconTheme: const IconThemeData(color: blackColor),
        backgroundColor: whiteColor,
        flexibleSpace: Container(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          decoration: const BoxDecoration(
              // color: backGroundColor,
              ),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    passedWidget,
                    const Spacer(),
                    InkWell(
                        onTap: () => CommonFunctions().checkIfLogin("Cart"),
                        child: SvgPicture.asset(
                          Images.cartImage,
                          height: 28,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                        onTap: () => CommonFunctions().checkIfLogin("WishList"),
                        child: SvgPicture.asset(
                          Images.wishlistImage,
                          height: 25,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
