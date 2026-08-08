import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';

class BottomFooter extends StatelessWidget {
  const BottomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: IconImage(
              imageString: Images.contact,
              onTap: () {},
              title: "Contact Us",
            )),
            Expanded(
                child: IconImage(
              imageString: Images.instagram,
              onTap: () => CommonFunctions().launchURL(""),
              title: "Instagram",
            )),
            Expanded(
                child: IconImage(
              imageString: Images.youtube,
              onTap: () => CommonFunctions().launchURL(""),
              title: "Youtube",
            )),
            Expanded(
                child: IconImage(
              imageString: Images.whatsapp,
              onTap: () {},
              title: "Whatsapp",
            ))
          ],
        )
      ],
    );
  }
}

class IconImage extends StatelessWidget {
  final String imageString, title;
  final VoidCallback onTap;

  const IconImage(
      {super.key,
      required this.imageString,
      required this.onTap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            imageString,
            height: 30,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
