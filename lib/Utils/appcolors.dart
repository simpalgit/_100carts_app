import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

const primaryColor = Color(0xFF1F5FD6); // Blue from logo
const primaryPartnerColor = Color(0xFF67C52E); // Green from logo
const lightPartnerColor = Color(0xFFD1C3FF);
const secondaryColor = Color(0xFF67C52E); // Green from logo
const blackColor = Color(0xFF1A1A1A); // Black from logo
const whiteColor = Color(0xFFFFFFFF);
const borderColor = Color(0xFFD6D6D6);
const lightGrayColor = Color(0xFFF2F2F2); // Light gray from logo
Color greyColor = const Color(0xFFEEEEEE);
const Color backGroundColor = Color(0xFFF2F2F2); // Light gray from logo
const iconColor = Color(0xFF444444); // Dark gray from logo
const darkBlueColor = Color(0xFF1F5FD6); // Blue from logo
const homeBackColor = Color(0xFFF2F2F2); // Light gray from logo

Card settingsCommonCard({required Widget child}) {
  return Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: borderColor)),
    child: child,
  );
}

Text settingsTitle(String title) {
  return Text(
    title,
    style: GoogleFonts.mukta(
      color: blackColor,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    ),
  );
}

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: GoogleFonts.mukta(
    fontSize: 22,
    color: blackColor,
  ),
  decoration: BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: blackColor, width: 2),
  ),
);

String checkNullOperatorFun(dynamic val) {
  if (val == null) {
    return "";
  } else if (val.isEmpty) {
    return "-";
  } else {
    return val;
  }
}
