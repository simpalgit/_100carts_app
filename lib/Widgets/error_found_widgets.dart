import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorText extends StatelessWidget {
  final String error;
  final Color errorColor;
  const ErrorText({super.key, required this.error, required this.errorColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 3,
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                error,
                style: GoogleFonts.mukta(
                    color: errorColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold),
              ),
            )),
      ],
    );
  }
}
