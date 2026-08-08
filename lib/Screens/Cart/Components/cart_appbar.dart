import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/images.dart';

class CartListAppBar extends StatelessWidget {
  const CartListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 8,
          right: 12.0,
          top: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    shape: BoxShape.circle),
                child: SvgPicture.asset(
                  Images.backIcon,
                  height: 13,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              'Cart',
              style:
                  GoogleFonts.mukta(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const Spacer(),
            // InkWell(
            //           onTap: () => Get.toNamed(RouteName.cartScreen),
            //           child: SvgPicture.asset(
            //             Images.cartImage,
            //             height: 28,
            //           )),
            //       const SizedBox(
            //         width: 15,
            //       ),
            // InkWell(
            //     onTap: () => Get.toNamed(RouteName.wishListScreen),
            //     child: SvgPicture.asset(
            //       Images.wishlistImage,
            //       height: 25,
            //     )),
          ],
        ));
  }
}
