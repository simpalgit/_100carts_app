import 'package:flutter/material.dart';
import 'package:carts_app/Utils/images.dart';

class HotDeals extends StatelessWidget {
  const HotDeals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DealWidget(image: Images.discountTwenty),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: DealWidget(image: Images.discountThirty),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: DealWidget(image: Images.discountFourty),
          //     ),
          //     SizedBox(
          //       width: 15,
          //     ),
          //     Expanded(
          //       child: DealWidget(image: Images.discountFifty),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}

class DealWidget extends StatelessWidget {
  final String image;
  const DealWidget({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          image,
          height: size.height * 0.14,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
