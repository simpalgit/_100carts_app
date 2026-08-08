import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Widgets/no_data_found.dart';

import 'cart_product.dart';

class CartListComponent extends StatelessWidget {
  const CartListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.find();
    return Obx(() => controller.cartList.isEmpty
        ? const Center(
            child: NoDataFoundScreen(
              image: Images.noDataFound,
              passedData: "Cart is Empty ..",
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            itemBuilder: (context, index) {
              return CartListProduct(
                product: controller.cartList[index],
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: blackColor,
              );
            },
            itemCount: controller.cartList.length));
  }
}
