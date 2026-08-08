import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/images.dart';

class DetailsAppBar extends StatelessWidget {
  final String title;
  const DetailsAppBar({super.key, required this.title});

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
              width: 10,
            ),
            Text(
              title,
              style:
                  GoogleFonts.mukta(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ));
  }
}
