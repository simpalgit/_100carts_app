import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/category_model.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/common_appbar.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/no_data_found.dart';

import 'sub_category_controller.dart';

class SubCategoryScreen extends StatefulWidget {
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  final controller = Get.put(SubCategoryController());
  CategoryModel categoryModel = CategoryModel();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      categoryModel = data['cateogory'] as CategoryModel;
      controller.getInit(categoryModel);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar:
              commonAppBar(context: context, heading: categoryModel.name ?? ""),
          body: controller.categoryModel.value == null
              ? const SizedBox()
              : controller.categoryModel.value!.children!.isEmpty
                  ? const NoDataFoundScreen(
                      passedData: "No Data Found.", image: Images.noDataFound)
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                              mainAxisExtent: 150),
                      itemCount:
                          controller.categoryModel.value!.children!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var cateogory =
                            controller.categoryModel.value!.children![index];
                        return InkWell(
                            onTap: () => Get.toNamed(
                                RouteName.subSubCategoryScreen,
                                arguments: {'cateogory': cateogory}),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CustomImage(
                                      image: cateogory.image ?? "",
                                      imgHeight: 80,
                                      imgWidth: 80,
                                      boxFit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    cateogory.name ?? "",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: GoogleFonts.mukta(
                                        color: blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
        ));
  }
}

class SubSubCategoryScreen extends StatefulWidget {
  const SubSubCategoryScreen({super.key});

  @override
  State<SubSubCategoryScreen> createState() => _SubSubCategoryScreenState();
}

class _SubSubCategoryScreenState extends State<SubSubCategoryScreen> {
  final controller = Get.put(SubSubCategoryController());
  CategoryModel categoryModel = CategoryModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      categoryModel = data['cateogory'] as CategoryModel;
      controller.getInit(categoryModel);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar:
              commonAppBar(context: context, heading: categoryModel.name ?? ""),
          body: controller.categoryModel.value == null
              ? const SizedBox()
              : controller.categoryModel.value!.children!.isEmpty
                  ? const NoDataFoundScreen(
                      passedData: "No Data Found.", image: Images.noDataFound)
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                              mainAxisExtent: 150),
                      itemCount:
                          controller.categoryModel.value!.children!.length,
                      itemBuilder: (BuildContext context, int index) {
                        var cateogory =
                            controller.categoryModel.value!.children![index];
                        return InkWell(
                            onTap: () => Get.toNamed(RouteName.categoryProducts,
                                arguments: {"category": cateogory}),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CustomImage(
                                      image: cateogory.image ?? "",
                                      imgHeight: 80,
                                      imgWidth: 80,
                                      boxFit: BoxFit.fill,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    cateogory.name ?? "",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: GoogleFonts.mukta(
                                        color: blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ));
                      },
                    ),
        ));
  }
}
