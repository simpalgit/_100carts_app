import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';

import 'category_products_controller.dart';

class ProductCategoryFilter extends StatefulWidget {
  const ProductCategoryFilter({super.key});

  @override
  State<ProductCategoryFilter> createState() => _ProductCategoryFilterState();
}

class _ProductCategoryFilterState extends State<ProductCategoryFilter> {
  @override
  Widget build(BuildContext context) {
    CategoryProductController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 1,
        iconTheme: const IconThemeData(color: darkBlueColor),
        title: Text(
          "Filters",
          style: GoogleFonts.mukta(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3,
              fontSize: 16,
              color: darkBlueColor),
        ),
        actions: [
          InkWell(
            onTap: () {
              controller
                  .getProductList(0, "viewmore", controller.selectedCat.value!)
                  .then((value) => Navigator.pop(context));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => controller.applyLoading.value
                      ? const CommonButtonLoader(indicatorColor: darkBlueColor)
                      : Text(
                          "Apply",
                          style: GoogleFonts.mukta(
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold),
                        ),
                )
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, mainIndex) {
                    var data = controller.filterList[mainIndex];
                    return Obx(() => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.attributeName!.toUpperCase(),
                              style: GoogleFonts.mukta(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              children: controller
                                  .filterList[mainIndex].attributeValues!
                                  .map((i) => InkWell(
                                      onTap: () {
                                        controller.queryGenerater(i, data);
                                      },
                                      child: Obx(
                                        () => Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    controller.selection.value
                                                        ? whiteColor
                                                        : i.isSelected
                                                            ? whiteColor
                                                            : blackColor),
                                            color: controller.selection.value
                                                ? whiteColor
                                                : i.isSelected
                                                    ? primaryColor
                                                    : whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Text(
                                            i.value!,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.mukta(
                                                color: i.isSelected
                                                    ? whiteColor
                                                    : blackColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ),
                                      )))
                                  .toList(),
                            ),
                          ],
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: controller.filterList.length),
            ),
          )),
    );
  }
}
