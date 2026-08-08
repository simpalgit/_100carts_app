import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/home_model.dart';

import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Screens/WishList/wishlist_controller.dart';
import 'package:carts_app/Utils/common_functions.dart';

class WishListWidget extends StatelessWidget {
  final String from;
  final ProductDetailModel? product;
  final ProductModel? homeProductModel;
  final Animation<double> controller;
  const WishListWidget(
      {super.key,
      required this.product,
      required this.controller,
      required this.homeProductModel,
      required this.from});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () => CommonFunctions().addRemoveCheckCart(
            from,
            from == "detail" ? product : null,
            from == "home" ? homeProductModel : null),
        child: GetBuilder<WishListController>(builder: (_) {
          bool isFav = false;
          bool isLoading = false;

          if (from == "detail") {
            isLoading = product!.isLoading!;
          } else {
            isLoading = homeProductModel!.isLoading!;
          }

          if (from == "detail") {
            isFav = product!.data!.isFavourite == true;
          } else {
            isFav = homeProductModel!.isFavorite == true;
          }
          return ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeOut)),
            child: isLoading
                ? Container(
                    padding: const EdgeInsets.all(4),
                    height: 20,
                    width: 20,
                    child: const CircularProgressIndicator())
                : isFav
                    ? const Icon(
                        Icons.favorite,
                        size: 25,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        size: 25,
                      ),
          );
        }),
      ),
    );
  }
}
