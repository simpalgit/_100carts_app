import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Screens/OrderList/orderlist_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';

import 'Components/orderlist_appbar.dart';
import 'Components/orderlist_list.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late final OrderlistController orderListController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    orderListController = Get.put(OrderlistController());

    // Now you can safely call methods on the controller
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      orderListController.getWishList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            OrderlistAppbar(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: OrderlistList(),
            ),
          ],
        ),
      ),
    );
  }
}
