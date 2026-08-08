import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/nav_controll.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/images.dart';

class NavModel {
  final Widget page;
  final GlobalKey<NavigatorState> navKey;

  NavModel({required this.page, required this.navKey});
}

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.pageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            spreadRadius: 5,
            blurRadius: 30,
            offset: const Offset(
                0, -3), // Specify the offset to create a shadow only at the top
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          navItem(
            Images.homeUnselected,
            Images.homeSelected,
            pageIndex == 0,
            'Home',
            0,
            onTap: () {
              onTap(0); // Calling the passed `onTap` function
              controller.updatePageIndex(0); // Updating the page index
            },
          ),
          navItem(
            Images.productUnselected,
            Images.productsSelected,
            pageIndex == 1,
            'Products',
            1,
            onTap: () {
              onTap(1);
              controller.updatePageIndex(1);
            },
          ),
          navItem(
            Images.orderUnselected,
            Images.orderselected,
            pageIndex == 2,
            'My Orders',
            2,
            onTap: () {
              onTap(2);
              controller.updatePageIndex(2);
            },
          ),
          navItem(
            Images.profileUnselected,
            Images.profileselected,
            pageIndex == 3,
            'Profile',
            3,
            onTap: () {
              onTap(3);
              controller.updatePageIndex(3);
            },
          ),
        ],
      ),
    );
  }

  Widget navItem(
    String unselectedimage,
    String selctedImage,
    bool selected,
    String name,
    int pageIndex, {
    Function()? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // selected
            //     ? Container(
            //         height: 2,
            //         color: primaryColor,
            //       )
            //     : const SizedBox(),
            const SizedBox(
              height: 18,
            ),
            SvgPicture.asset(
              selected ? selctedImage : unselectedimage,
              height: 20,
            ),

            // Text(
            //   name,
            //   style: GoogleFonts.mukta(
            //     fontSize: selected ? 11.5 : 10.5,
            //     color: selected ? primaryColor : blackColor,
            //     fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            //     letterSpacing: 1,
            //   ),
            // ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
