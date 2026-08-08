import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';

class DetailWidgetHelper extends StatelessWidget {
  final String heading, value;
  final Color? valueColor;

  const DetailWidgetHelper({
    super.key,
    required this.heading,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: GoogleFonts.mukta(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor ?? blackColor),
        ),
        Text(
          " :",
          style: GoogleFonts.mukta(
              fontWeight: FontWeight.bold, color: valueColor ?? blackColor),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.mukta(
                fontSize: 12.5,
                fontWeight: FontWeight.normal,
                color: valueColor ?? blackColor),
          ),
        ),
      ],
    );
  }
}

class MultiDetailHelper extends StatelessWidget {
  final String heading, value;
  final Color? valueColor;

  const MultiDetailHelper({
    super.key,
    required this.heading,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
          style: GoogleFonts.mukta(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor ?? blackColor),
        ),
        Text(
          ":",
          style:
              GoogleFonts.mukta(fontWeight: FontWeight.bold, color: blackColor),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: GoogleFonts.mukta(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: valueColor ?? blackColor),
        ),
      ],
    );
  }
}
