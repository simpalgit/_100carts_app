import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String passedData, image;
  const NoDataFoundScreen(
      {super.key, required this.passedData, required this.image});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Image.asset(
          image,
          width: size.height * 0.7,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          passedData,
          style: GoogleFonts.mukta(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 14,
              letterSpacing: 1.5),
        ),
      ],
    );
  }
}
