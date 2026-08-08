import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/BottomHome/bottom_home_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/navigation_bar_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';

import 'item_card.dart';

class ProductCategories extends StatefulWidget {
  final TabController tabController;
  const ProductCategories({super.key, required this.tabController});

  @override
  State<ProductCategories> createState() => _ProductCategoriesState();
}

class _ProductCategoriesState extends State<ProductCategories> {
  final HomeScreenController mainController = Get.find();
  final BottomHomeController bottomController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                dividerHeight: 0,
                tabAlignment: TabAlignment.center,
                unselectedLabelColor: secondaryColor,
                padding: const EdgeInsets.only(bottom: 5),
                indicatorColor: primaryColor,
                controller: widget.tabController,
                labelColor: primaryColor,
                isScrollable: true,
                labelStyle: GoogleFonts.mukta(fontWeight: FontWeight.bold),
                onTap: (value) {
                  widget.tabController.index = value;
                  setState(() {});
                },
                tabs: const [
                  Tab(
                    text: 'Our Products',
                  ),
                  Tab(
                    text: 'Top Rated',
                  ),
                  Tab(
                    text: 'Best Seller',
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => mainController.isNearLoading.value
                ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ))
                : GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 300),
                    itemCount: widget.tabController.index == 0
                        ? mainController.allProductList.length
                        : widget.tabController.index == 1
                            ? mainController.topRatedProductList.length
                            : mainController.bestSellerProductList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemCard(
                        productModel: widget.tabController.index == 0
                            ? mainController.allProductList[index]
                            : widget.tabController.index == 1
                                ? mainController.topRatedProductList[index]
                                : mainController.bestSellerProductList[index],
                      );
                    },
                  ),
          ),
          TextButton.icon(
            onPressed: () {
              final homeController = BottomNavigiationController();
              homeController.navListener.sink.add(1);
              mainController.onChangeIndex(1);
            },
            icon:
                const Icon(Icons.add_circle_outline_sharp, color: primaryColor),
            label: Text('View More Items',
                style: GoogleFonts.mukta(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
