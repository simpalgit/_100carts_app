import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Screens/ProductDetail/product_detail_controller.dart';

import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/page_loader.dart';

import 'Components/detail_appbar.dart';
import 'Components/product_detail_component.dart';
import 'Review/reviews_controller.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    super.key,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  ProductModel productModel = ProductModel();
  final productController = Get.put(ProductDetailController());
  final reviewController = Get.put(ReviewController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      productModel = data['product'] as ProductModel;
      productController.getProductDetail(productModel.productId.toString(),
          productModel.id.toString(), productModel);
    });

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ReviewController>();
    Get.delete<ProductDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          child: Obx(
        () => productController.isLoading.value
            ? const PageLoaderScreen()
            : Column(
                children: [
                  const DetailsAppBar(
                    title: "Details",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          productController.productDetailModel.value != null
                              ? ProductDetailComponent(
                                  product: productController
                                      .productDetailModel.value!,
                                )
                              : const SizedBox(),

                          // HorizontalListCategory(
                          //   title: "Related Product",
                          //   productList: watch.productList,
                          // ),
                        ])),
                      ],
                    ),
                  ),
                ],
              ),
      )),
    );
  }
}
