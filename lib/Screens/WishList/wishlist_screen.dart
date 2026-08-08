import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Screens/WishList/wishlist_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';

import 'Components/wishlist_appbar.dart';
import 'Components/wishlist_list.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  final WishListController wishListController = Get.find();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      wishListController.getWishList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            WishListAppBar(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: WishListList(),
            ),
          ],
        ),
      ),
    );
  }
}
