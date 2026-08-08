import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Screens/ProductDetail/product_detail_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/rating_star.dart';

class ProductReview extends StatelessWidget {
  final String prodId, varId;
  final ProductDetailModel model;
  const ProductReview(
      {super.key,
      required this.prodId,
      required this.varId,
      required this.model});

  @override
  Widget build(BuildContext context) {
    final ProductDetailController controller = Get.find();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GetBuilder<ProductDetailController>(
                builder: (productDetailController) {
              return Text(
                "Reviews (${productDetailController.reviewPaginatedModel.value?.total ?? "0"})",
                style: GoogleFonts.mukta(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: darkBlueColor),
              );
            }),
            FutureBuilder(
              future: CommonFunctions().loginInfo(),
              builder: (context, snapshot) {
                return snapshot.data ?? false
                    ? InkWell(
                        onTap: () =>
                            Get.toNamed(RouteName.addReviewScreen, arguments: {
                          "prodId": prodId,
                          "varId": varId,
                          "prodName": model.data!.title,
                          "prodImage": model.data!.images!.isEmpty
                              ? ""
                              : model.data!.images![0].image
                        })!
                                .then((value) => controller
                                    .getProductReviewsFirst(prodId, varId)),
                        child: Row(
                          children: [
                            Text(
                              "Add Review",
                              style: GoogleFonts.mukta(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: darkBlueColor),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Icon(Icons.add)
                          ],
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
        GetBuilder<ProductDetailController>(
          builder: (productDetailController) {
            return (productDetailController.reviewPaginatedModel.value == null ||
                    productDetailController.reviewPaginatedModel.value?.total == 0)
                ? const SizedBox()
                : Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      RatingIndicator(
                        title: "1",
                        starPercentage: productDetailController
                                .reviewPaginatedModel
                                .value!
                                .oneStarPercentage ??
                            0,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      RatingIndicator(
                        title: "2",
                        starPercentage: productDetailController
                                .reviewPaginatedModel
                                .value!
                                .twoStarPercentage ??
                            0,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      RatingIndicator(
                        title: "3",
                        starPercentage: productDetailController
                                .reviewPaginatedModel
                                .value!
                                .threeStarPercentage ??
                            0,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      RatingIndicator(
                        title: "4",
                        starPercentage: productDetailController
                                .reviewPaginatedModel
                                .value!
                                .fourStarPercentage ??
                            0,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      RatingIndicator(
                        title: "5",
                        starPercentage: productDetailController
                                .reviewPaginatedModel
                                .value!
                                .fiveStarPercentage ??
                            0,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      productDetailController
                                  .reviewPaginatedModel.value!.data ==
                              null
                          ? const SizedBox()
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: productDetailController
                                          .reviewPaginatedModel
                                          .value!
                                          .data!
                                          .length >=
                                      3
                                  ? 3
                                  : productDetailController
                                      .reviewPaginatedModel.value!.data!.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 15,
                                );
                              },
                              itemBuilder: (context, index) {
                                var data = productDetailController
                                    .reviewPaginatedModel.value!.data![index];
                                return Card(
                                  margin: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side:
                                          const BorderSide(color: borderColor)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // ProfileCustomImage(
                                            //     image: data.user!.profilePic ?? "",
                                            //     imgHeight: 25,
                                            //     imgWidth: 25),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              data.user!.name ?? "",
                                              style: GoogleFonts.mukta(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        RatingStars(
                                          numberOfStars: data.rating!,
                                          starSize: 13,
                                          fillColor: Colors.green,
                                          emptyColor: const Color.fromARGB(
                                              255, 201, 201, 201),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          data.title ?? "",
                                          style: GoogleFonts.mukta(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          data.review ?? "",
                                          style: GoogleFonts.mukta(
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      productDetailController
                                  .reviewPaginatedModel.value!.total ==
                              0
                          ? const SizedBox()
                          : InkWell(
                              onTap: () => Get.toNamed(RouteName.reviewsScreen,
                                  arguments: {"product": model}),
                              child: Text(
                                "See More",
                                style: GoogleFonts.mukta(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: blackColor),
                              ),
                            ),
                    ],
                  );
          },
        )
      ],
    );
  }
}

class RatingIndicator extends StatelessWidget {
  final int starPercentage;
  final String title;
  const RatingIndicator(
      {super.key, required this.starPercentage, required this.title});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 5,
        ),
        const Icon(
          CupertinoIcons.star_fill,
          size: 10,
          color: Colors.green,
        ),
        LinearPercentIndicator(
          animation: true,
          width: size.width * 0.6,
          lineHeight: 7.0,
          percent: starPercentage / 100,
          backgroundColor: const Color.fromARGB(255, 201, 201, 201),
          barRadius: const Radius.circular(12),
          progressColor: Colors.green,
        ),
      ],
    );
  }
}
