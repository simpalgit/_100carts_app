import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';

import 'common_button_loader.dart';

class PermissionWidget extends StatelessWidget {
  final String title, imageString;
  final VoidCallback? onSure, notNow;

  const PermissionWidget(
      {super.key,
      required this.title,
      required this.imageString,
      this.onSure,
      this.notNow});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imageString,
            height: 150,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(title,
              style: GoogleFonts.mukta(color: blackColor, fontSize: 18)),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: size.width * 0.7,
              height: size.height * 0.05,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: onSure,
                  child: onSure == null
                      ? const CommonButtonLoader(indicatorColor: primaryColor)
                      : Text(
                          "Sure",
                          style: GoogleFonts.mukta(
                            color: whiteColor,
                          ),
                        ))),
          TextButton(
              onPressed: notNow,
              child: Text(
                "Not now",
                style: GoogleFonts.mukta(
                  color: primaryColor,
                ),
              ))
        ],
      ),
    );
  }
}
