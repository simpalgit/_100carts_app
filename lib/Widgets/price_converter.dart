import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceConverter {
  static String convertPrice(double? price,
      {double? discount, String? discountType, bool forDM = false}) {
    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        price = price! - discount;
      } else if (discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }

    return '${toFixed(price!).toStringAsFixed(forDM ? 0 : 2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        '\u{20B9}';
  }

  static Widget convertAnimationPrice(double? price,
      {double? discount,
      String? discountType,
      bool forDM = false,
      TextStyle? textStyle}) {
    if (discount != null && discountType != null) {
      if (discountType == 'amount') {
        price = price! - discount;
      } else if (discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AnimatedFlipCounter(
        duration: const Duration(milliseconds: 500),
        value: toFixed(price!),
        textStyle: textStyle ?? GoogleFonts.mukta(),
        fractionDigits: forDM ? 0 : 2,
        prefix: "\u{20B9}",
        suffix: '\u{20B9}',
      ),
    );
  }

  static double? convertWithDiscount(
      double? price, double? discount, String? discountType) {
    if (discountType == 'amount') {
      price = price! - discount!;
    } else if (discountType == 'percent') {
      price = price! - ((discount! / 100) * price);
    }
    return price;
  }

  static double calculation(
      double amount, double? discount, String type, int quantity) {
    double calculatedAmount = 0;
    if (type == 'amount') {
      calculatedAmount = discount! * quantity;
    } else if (type == 'percent') {
      calculatedAmount = (discount! / 100) * (amount * quantity);
    }
    return calculatedAmount;
  }

  static String percentageCalculation(
      String price, String discount, String discountType) {
    return '$discount${discountType == 'percent' ? '%' : "\u{20B9}"} OFF';
  }

  static double toFixed(double val) {
    num mod = power(10, 2);
    return (((val * mod)).floor().toDouble() / mod);
  }

  static int power(int x, int n) {
    int retval = 1;
    for (int i = 0; i < n; i++) {
      retval *= x;
    }
    return retval;
  }
}
