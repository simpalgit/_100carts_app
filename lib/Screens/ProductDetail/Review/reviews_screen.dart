import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/common_appbar.dart';
import 'package:carts_app/Widgets/paginated_list_view.dart';
import 'package:carts_app/Widgets/rating_star.dart';

import 'reviews_controller.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    super.key,
  });

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  ReviewController controller = Get.find();
  ProductDetailModel productModel = ProductDetailModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var data = Get.arguments;
      productModel = data['product'] as ProductDetailModel;
      controller.getReviewList(0, "Home", productModel.productId.toString(),
          productModel.id.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const CommonAppBar(title: "All Reviews"),
            const SizedBox(
              height: 10,
            ),
            Obx(() => controller.isLoading.value
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: PaginatedListView(
                        scrollController: controller.scrollController,
                        enabledPagination: true,
                        offset:
                            int.parse(controller.paginatedModel.value!.offset!),
                        onPaginate: (int? offset) async =>
                            await controller.getReviewList(
                                offset!,
                                "viewmore",
                                productModel.productId.toString(),
                                productModel.id.toString()),
                        reverse: false,
                        totalSize: controller.paginatedModel.value!.total,
                        itemView: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          itemCount: controller.reviewList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var data = controller.reviewList[index];
                            return Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: borderColor)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      numberOfStars: data.rating ?? 0,
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
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
