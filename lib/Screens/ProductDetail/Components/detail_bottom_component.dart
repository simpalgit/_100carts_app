import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/route_names.dart';

class ProductBottomComponent extends StatelessWidget {
  final ProductDetailModel productModel;
  const ProductBottomComponent({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          primaryColor.withOpacity(1),
          primaryColor.withOpacity(0.6),
        ]),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            offset: const Offset(-9, -1),
            blurRadius: 15,
            spreadRadius: 10,
          )
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () => CommonFunctions().checkIfLogin("Cart"),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: whiteColor),
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: primaryColor,
                size: 17,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: whiteColor),
                onPressed: () async {
                  var isLogin = await CommonFunctions().loginInfo();

                  if (isLogin) {
                    cartController.addCartData(
                        productModel.productId.toString(),
                        productModel.id.toString());
                  } else {
                    Get.toNamed(RouteName.signInScreen, arguments: {
                      "fromMainBottom": false,
                      "from": "ProductDetail"
                    });
                  }
                },
                child: Text(
                  'Add To Cart',
                  style: GoogleFonts.mukta(color: primaryColor),
                )),
          ),
        ],
      ),
    );
  }
}
