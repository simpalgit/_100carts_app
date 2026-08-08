import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/images.dart';

class DiscountTag extends StatelessWidget {
  final double? discount;
  final String? discountType;

  const DiscountTag({
    super.key,
    required this.discount,
    required this.discountType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 45,
      width: 45,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Images.couponDis,
          ),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(5),
          left: Radius.circular(5),
        ),
      ),
      child: Text(
        textAlign: TextAlign.center,
        '$discount${discountType == 'percent' ? '%' : "rs"} \n${'off'}',
        style:
            GoogleFonts.mukta(color: Theme.of(context).cardColor, fontSize: 10),
      ),
    );
  }
}
