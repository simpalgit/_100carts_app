import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Screens/OrderList/orderlist_controller.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Widgets/no_data_found.dart';

import 'orderlist_product.dart';

class OrderlistList extends StatelessWidget {
  const OrderlistList({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderlistController controller = Get.find();
    Future<void> refreshOrderList() async {
      await controller.getWishList();
    }

    return Obx(() => controller.orderListList.isEmpty
        ? const Center(
            child: NoDataFoundScreen(
              image: Images.noDataFound,
              passedData: "Orderlist is Empty ..",
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10),
            itemBuilder: (context, index) {
              return OrderListProduct(
                  product: controller.orderListList[index],
                  refreshOrderList: refreshOrderList);
            },
            separatorBuilder: (context, index) {
              return Container();
            },
            itemCount: controller.orderListList.length));
  }
}
