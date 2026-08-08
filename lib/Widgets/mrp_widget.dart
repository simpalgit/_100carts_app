import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MrpWidget extends StatelessWidget {
  final int offerCost, cost;
  final double offerSize, costSize;
  const MrpWidget(
      {super.key,
      required this.cost,
      required this.offerCost,
      required this.costSize,
      required this.offerSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "\u{20B9}$offerCost",
          style: GoogleFonts.mukta(
              fontWeight: FontWeight.bold,
              fontSize: offerSize,
              color: Colors.black),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "\u{20B9}$cost",
          style: GoogleFonts.mukta(
              decoration: TextDecoration.lineThrough,
              decorationColor: Colors.grey,
              decorationThickness: 2.0,
              fontSize: costSize,
              color: Colors.grey),
        ),
      ],
    );
  }
}
