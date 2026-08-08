import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/title_widget.dart';

class TopSellingBrands extends StatelessWidget {
  final String title;
  const TopSellingBrands({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController homeScreenController = Get.find();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TitleWidget(
              title: title,
              image: Images.topImage,
              // onTap: () {},
            ),
          ),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 8),
              itemCount: homeScreenController.topSellingBrandsList.length < 8
                  ? homeScreenController.topSellingBrandsList.length
                  : 8,
              itemBuilder: (context, index) {
                var brand = homeScreenController.topSellingBrandsList[index];
                return InkWell(
                  onTap: () => Get.toNamed(RouteName.subCategoryScreen,
                      arguments: {'cateogory': brand}),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15.0, right: 15.0, top: 5.0),
                      child: Column(
                        children: [
                          CustomImage(
                              boxFit: BoxFit.fill,
                              image: brand.image ?? "",
                              imgHeight: 100,
                              imgWidth: 100),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            brand.name ?? "",
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: GoogleFonts.mukta(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
