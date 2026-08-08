import 'package:flutter/material.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/discount_tag.dart';
import 'package:carts_app/Widgets/heart_widget.dart';

class ProductImageHeader extends StatelessWidget {
  final ProductDetailModel product;
  final String productThumb;
  final Animation<double> controller;
  const ProductImageHeader(
      {super.key,
      required this.product,
      required this.productThumb,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomImage(
          image: productThumb,
          imgHeight: size.height * 0.4,
          imgWidth: double.infinity,
          boxFit: BoxFit.cover,
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                shape: BoxShape.circle,
                color: Colors.grey[100]),
            child: WishListWidget(
              from: "detail",
              homeProductModel: null,
              product: product,
              controller: controller,
            ),
          ),
        ),
        Positioned(
          left: 10,
          child: DiscountTag(
            discount: product.data!.activePrice!.discount,
            discountType: "percent",
          ),
        ),
      ],
    );
  }
}
