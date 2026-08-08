import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';

class AnimatedTextWidget extends StatelessWidget {
  final String text;
  const AnimatedTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          speed: const Duration(milliseconds: 150),
          textStyle: GoogleFonts.mukta(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: blackColor,
              letterSpacing: 1.5),
        ),
      ],
      isRepeatingAnimation: true,
      repeatForever: true,
      displayFullTextOnTap: true,
      stopPauseOnTap: false,
    );
  }
}
