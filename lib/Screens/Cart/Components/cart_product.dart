import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/mrp_widget.dart';

class CartListProduct extends StatelessWidget {
  final ProductModel product;
  final bool? viewDetail;
  const CartListProduct({super.key, required this.product, this.viewDetail});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
                    : product.latestImage!.image ?? "",
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
                    product.title ?? "",
                    style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MrpWidget(
                          cost: product.activePrice!.mrp ?? 0,
                          offerCost: product.activePrice!.price ?? 0,
                          offerSize: 14,
                          costSize: 13,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Quantity : ",
                            style: GoogleFonts.mukta(
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          Text(
                            product.quantity.toString(),
                            style:
                                GoogleFonts.mukta(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total : \u{20B9} ${product.activePrice!.price! * product.quantity!}",
                        style: GoogleFonts.mukta(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      viewDetail == false
                          ? const SizedBox()
                          : InkWell(
                              onTap: () =>
                                  cartController.removeCartData(product),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF4f46e5),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  "Remove",
                                  style: GoogleFonts.mukta(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
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
