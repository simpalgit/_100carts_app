import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/BottomExplore/explore_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/shimmer_helper.dart';

class ExploreHorizontalCategory extends StatelessWidget {
  const ExploreHorizontalCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ExploreController controller = Get.find();
    return Obx(() => controller.isLoading.value
        ? SizedBox(
            height: 30,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 10,
                );
              },
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return shimmerCard(context);
              },
            ),
          )
        : controller.categoryList.isEmpty
            ? const SizedBox()
            : SizedBox(
                height: 50,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: ListView.separated(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            controller.selectIndex(
                              context,
                              index,
                              controller.categoryList[index],
                            );
                          },
                          child: Obx(() => Card(
                                elevation: 3,
                                margin: const EdgeInsets.only(bottom: 5),
                                color: controller.selectedIndex.value == index
                                    ? primaryColor
                                    : whiteColor,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: controller.selectedIndex.value ==
                                                index
                                            ? 1.5
                                            : 0.7,
                                        color: controller.selectedIndex.value ==
                                                index
                                            ? primaryColor
                                            : borderColor),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 6.0),
                                  child: Text(
                                    controller.categoryList[index].name!,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.mukta(
                                      fontWeight: FontWeight.bold,
                                      color: controller.selectedIndex.value ==
                                              index
                                          ? whiteColor
                                          : blackColor,
                                    ),
                                  ),
                                ),
                              )),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                      itemCount: controller.categoryList.length),
                ),
              ));
  }

  Widget shimmerCard(BuildContext context) {
    return const ShimmerHelper(
      height: 30,
      width: 80,
      borderRadius: 10,
    );
  }
}
