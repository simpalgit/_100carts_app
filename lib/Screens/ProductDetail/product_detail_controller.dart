import 'package:get/get.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Models/review_paginated_model.dart';
import 'package:carts_app/Repositories/product_repository.dart';

class ProductDetailController extends GetxController {
  ProductRepository productRepository = ProductRepository();
  RxBool isLoading = true.obs;
  Rxn<ProductDetailModel> productDetailModel = Rxn<ProductDetailModel>();
  Rxn<ReviewPaginatedModel> reviewPaginatedModel = Rxn<ReviewPaginatedModel>();

  loadingFun(bool val) {
    isLoading.value = val;
  }

  Future getProductDetail(
      String id, String varId, ProductModel productModel) async {
    loadingFun(true);
    try {
      var result =
          await productRepository.getProductDetail(varId, productModel);
      result.fold((error) {
        // Handle error
        loadingFun(false);
      }, (data) {
        productDetailModel.value = data;
        getProductReviewsFirst(id, varId);
        loadingFun(false);
      });
    } catch (e) {
      loadingFun(false);
    }
  }

  Future getProductReviewsFirst(String prodId, String varId) async {
    try {
      var result =
          await productRepository.getFirstReviewLoad(prodId, varId, "0");
      result.fold((error) {
        // Handle error
      }, (data) {
        reviewPaginatedModel.value = data;
      });
    } catch (e) {
      // Handle error
    }
  }

  reviewLoadingFun(bool val) {
    // isLoading.value = val;
  }
}
