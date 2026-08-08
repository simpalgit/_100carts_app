import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/category_model.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/mrp_widget.dart';
import 'package:carts_app/Widgets/no_data_found.dart';
import 'package:carts_app/Widgets/page_loader.dart';
import 'package:carts_app/Widgets/paginated_list_view.dart';
import 'package:carts_app/Widgets/shimmer_helper.dart';

import 'category_products_controller.dart';

class CategoryProducts extends StatefulWidget {
  const CategoryProducts({super.key});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  final CartController cartController = Get.find();
  final categoryProductController = Get.put(CategoryProductController());
  CategoryModel category = CategoryModel();

  get _quantity => null;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      category = data['category'] as CategoryModel;
      categoryProductController
          .getAttributeList(category.categoryId.toString())
          .then((value) =>
              categoryProductController.getProductList(0, "init", category));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 1,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: darkBlueColor),
          title: Obx(() => Text(
                categoryProductController.selectedCat.value == null
                    ? ""
                    : categoryProductController.selectedCat.value!.name ?? "",
                style: GoogleFonts.mukta(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.3,
                    fontSize: 16,
                    color: darkBlueColor),
              )),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => CommonFunctions().checkIfLogin("Cart"),
                    icon: const Icon(Icons.shopping_bag_outlined))
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () => Get.toNamed(RouteName.productCategoryFilter),
              child: const Icon(
                Icons.filter_list_outlined,
                color: darkBlueColor,
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Obx(() => categoryProductController.paginatedModel.value == null
            ? const PageLoaderScreen()
            : categoryProductController.isLoading.value
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 265,
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 10.0,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    itemBuilder: (context, index) {
                      return shimmerCard();
                    },
                    itemCount: 8)
                : categoryProductController.isProductsEmpty.value
                    ? const NoDataFoundScreen(
                        image: Images.noDataFound,
                        passedData: "No Product Found ..",
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: categoryProductController.scrollController,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: PaginatedListView(
                          scrollController:
                              categoryProductController.scrollController,
                          enabledPagination: true,
                          offset: categoryProductController
                              .paginatedModel.value?.offset,
                          onPaginate: (int? offset) async {
                            await categoryProductController.getProductList(
                                offset!,
                                "viewmore",
                                categoryProductController.selectedCat.value!);
                          },
                          reverse: false,
                          totalSize: categoryProductController
                              .paginatedModel.value?.totalSize,
                          itemView: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 265,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10.0,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            itemCount:
                                categoryProductController.productList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data =
                                  categoryProductController.productList[index];
                              return InkWell(
                                onTap: () => Get.toNamed(
                                    RouteName.productDetail,
                                    arguments: {"product": data}),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: CustomImage(
                                            image: data.latestImage == null
                                                ? ""
                                                : data.latestImage!.image!,
                                            imgHeight: 120,
                                            imgWidth: double.infinity,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          right: 0,
                                          child: data.status == "Active"
                                              ? Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4,
                                                        horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: const Color
                                                                .fromARGB(
                                                                255, 16, 125, 20)),
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 173, 246, 176),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Text(
                                                      "In Stock",
                                                      style: GoogleFonts.mukta(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 16, 125, 20),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                                  decoration: BoxDecoration(
                                                      border: Border
                                                          .all(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  234, 11, 11)),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              255,
                                                              175,
                                                              175),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    "Out of Stock",
                                                    style: GoogleFonts.mukta(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 234, 11, 11),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                        )
                                        // const Positioned(
                                        //   left: 10,
                                        //   child: DiscountTag(
                                        //     discount: 50,
                                        //     discountType: "percent",
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0, top: 10),
                                      child: Text(
                                        data.title!,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.mukta(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                        maxLines: 2,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: MrpWidget(
                                              cost: data.activePrice!.mrp!,
                                              offerCost:
                                                  data.activePrice!.price!,
                                              offerSize: 11,
                                              costSize: 10,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            alignment: Alignment.centerRight,
                                            child: InkWell(
                                              onTap: () async {
                                                var isLogin =
                                                    await CommonFunctions()
                                                        .loginInfo();

                                                if (isLogin) {
                                                  cartController.addCartData(
                                                      data.productId.toString(),
                                                      data.id.toString());
                                                } else {
                                                  Get.toNamed(
                                                      RouteName.signInScreen,
                                                      arguments: {
                                                        "fromMainBottom": false,
                                                        "from": "Explore"
                                                      });
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.blue),
                                                child: const Icon(
                                                  Icons.shopping_cart,
                                                  color: whiteColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )));
  }

  Widget shimmerCard() {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      height: size.height * 0.22,
      decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        child: Column(
          children: [
            ShimmerHelper(
              height: size.height * 0.1,
              width: size.width * 0.4,
              borderRadius: 8,
            ),
            const SizedBox(
              height: 10,
            ),
            ShimmerHelper(
              height: 12,
              width: size.width,
              borderRadius: 15,
            ),
            const SizedBox(
              height: 7,
            ),
            const Row(
              children: [
                ShimmerHelper(
                  height: 15,
                  width: 30,
                  borderRadius: 5,
                ),
                SizedBox(
                  width: 7,
                ),
                ShimmerHelper(
                  height: 15,
                  width: 30,
                  borderRadius: 5,
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ShimmerHelper(
                height: 12,
                width: size.width * 0.3,
                borderRadius: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
