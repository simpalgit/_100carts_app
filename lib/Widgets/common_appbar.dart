import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';

class CommonAppBar extends StatelessWidget {
  final String title;
  const CommonAppBar({super.key, required this.title});

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
                  "assets/svg_images/back_icon.svg",
                  height: 13,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style:
                  GoogleFonts.mukta(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ));
  }
}

AppBar commonAppBar(
    {required BuildContext context,
    required String heading,
    String? subtitle,
    double? elv = 0,
    List<Widget>? widgetList,
    VoidCallback? onPressed}) {
  return AppBar(
    backgroundColor: whiteColor,
    elevation: elv,
    automaticallyImplyLeading: false,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onPressed ?? () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(4),
              height: 30,
              width: 40,
              decoration: BoxDecoration(
                  color: blackColor, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: whiteColor,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            heading,
            style: GoogleFonts.mukta(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ],
      ),
    ),
    actions: widgetList,
  );
}
