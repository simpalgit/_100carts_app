import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:carts_app/Screens/WishList/wishlist_controller.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Widgets/no_data_found.dart';

import 'wishlist_product.dart';

class WishListList extends StatelessWidget {
  const WishListList({super.key});

  @override
  Widget build(BuildContext context) {
    final WishListController controller = Get.find();
    return Obx(() => controller.wishListList.isEmpty
        ? const Center(
            child: NoDataFoundScreen(
              image: Images.noDataFound,
              passedData: "Wishlist is Empty ..",
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            itemBuilder: (context, index) {
              return WishListProduct(
                product: controller.wishListList[index],
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: blackColor,
              );
            },
            itemCount: controller.wishListList.length));
  }
}
