import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Screens/WishList/wishlist_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/mrp_widget.dart';

class WishListProduct extends StatelessWidget {
  final ProductModel product;
  const WishListProduct({super.key, required this.product});

  get _quantity => null;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final WishListController wishController = Get.find();
    final CartController cartController = Get.find();
    return InkWell(
      onTap: () =>
          Get.toNamed(RouteName.productDetail, arguments: {"product": product}),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
                image: product.latestImage == null
                    ? ""
                    : product.latestImage!.image!,
                imgHeight: size.height * 0.08,
                imgWidth: size.height * 0.08),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title!,
                    style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  MrpWidget(
                    cost: product.activePrice!.mrp!,
                    offerCost: product.activePrice!.price!,
                    offerSize: 14,
                    costSize: 13,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () => cartController.addCartData(
                              product.productId.toString(),
                              product.id.toString()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              "Add to Cart",
                              style: GoogleFonts.mukta(
                                  color: whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      InkWell(
                          onTap: () =>
                              wishController.removeProductFromWishList(product),
                          child: Text(
                            "Remove",
                            style: GoogleFonts.mukta(
                                color: const Color(0xFF4f46e5),
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
