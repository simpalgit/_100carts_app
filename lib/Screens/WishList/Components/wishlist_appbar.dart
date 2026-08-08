import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/images.dart';

class WishListAppBar extends StatelessWidget {
  const WishListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
          left: 8,
          right: 12.0,
          top: 6,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
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
              'WishList',
              style:
                  GoogleFonts.mukta(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ));
  }
}
