import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String? image;

  const TitleWidget({
    super.key,
    required this.title,
    this.onTap,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Text(title,
              style: GoogleFonts.mukta(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor)),
          const SizedBox(width: 10),
          image != null
              ? SvgPicture.asset(image!, height: 15, width: 15)
              : const SizedBox(),
        ],
      ),
      (onTap != null)
          ? InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  'see all',
                  style: GoogleFonts.mukta(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            )
          : const SizedBox(),
    ]);
  }
}
