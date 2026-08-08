import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController homeScreenController = Get.find();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor)),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeScreenController.categoryList.length,
          itemBuilder: (BuildContext context, int index) {
            var cateogory = homeScreenController.categoryList[index];
            return InkWell(
                onTap: () => Get.toNamed(RouteName.subCategoryScreen,
                    arguments: {'cateogory': cateogory}),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: CustomImage(
                          image: cateogory.image ?? "",
                          imgHeight: 60,
                          imgWidth: 60,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        cateogory.name ?? "",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.mukta(
                            color: blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
