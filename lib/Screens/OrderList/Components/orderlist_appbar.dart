import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/nav_bar.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/nav_controll.dart';
import 'package:carts_app/Utils/images.dart';

class OrderlistAppbar extends StatelessWidget {
  const OrderlistAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.find();
    return Container(
        padding: const EdgeInsets.only(
          left: 8,
          right: 12.0,
          top: 6,
        ),
        child: Row(
          children: [
            if (controller.pageIndex.value == 2)
              Container()
            else
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
            if (controller.pageIndex.value == 2)
              Text(
                'Orders',
                style: GoogleFonts.mukta(
                    fontWeight: FontWeight.bold, fontSize: 16),
              )
            else
              Text(
                'OrdersList',
                style: GoogleFonts.mukta(
                    fontWeight: FontWeight.bold, fontSize: 17),
              ),
          ],
        ));
  }
}
