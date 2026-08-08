import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/BottomOrder/Components/orders_appbar.dart';
import 'package:carts_app/Screens/BottomOrder/order_controller.dart';
import 'package:carts_app/Screens/OrderList/Components/orderlist_list.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/page_loader.dart';
import 'package:carts_app/Widgets/paginated_list_view.dart';

class OrderScreen extends StatefulWidget {
  final bool fromNavigation;
  const OrderScreen({super.key, required this.fromNavigation});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: whiteColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                MyOrderCustomAppBar(fromBottomSheet: widget.fromNavigation),
              ],
            ),
          ),
        ));
  }
}
