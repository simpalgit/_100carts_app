import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'package:carts_app/Models/review_paginated_model.dart';
import 'package:carts_app/Repositories/product_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class ReviewController extends GetxController {
  ProductRepository productRepository = ProductRepository();

  Rxn<ReviewPaginatedModel> paginatedModel = Rxn<ReviewPaginatedModel>();

  final ScrollController scrollController = ScrollController();

  final RxList<ReviewModel> reviewList = <ReviewModel>[].obs;

  RxBool isLoading = true.obs;

  loadingFun(bool val) {
    isLoading.value = val;
  }

  initData(from) {
    reviewList.clear();
    isLoading = true.obs;
  }

  Future getReviewList(
      int offset, String from, String prodId, String varId) async {
    if (offset == 0) {
      loadingFun(true);
      initData(from);
    }
    var result = await productRepository.getReviewList(
      prodId,
      varId,
      offset.toString(),
    );

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      if (offset == 0) {
        loadingFun(false);
      }
    }, (data) {
      paginatedModel.value = data;
      reviewList.addAll(data.data!);

      if (offset == 0) {
        loadingFun(false);
      }
    });
  }

  RxBool isSubmitLoading = false.obs;

  void submitLoadingFun(bool val) {
    isSubmitLoading.value = val;
  }

  clearData() {
    isSubmitLoading = false.obs;
    _ctlTitle.clear();
    _ctlReview.clear();
  }

  final TextEditingController _ctlTitle = TextEditingController();
  TextEditingController get ctlTitle => _ctlTitle;

  final TextEditingController _ctlReview = TextEditingController();
  TextEditingController get ctlReview => _ctlReview;

  Future addReview(String prodId, String varId, double rating) async {
    submitLoadingFun(true);
    var passedBody = json.encode({
      "product_id": prodId,
      "variation_id": varId,
      "review": _ctlReview.text,
      "title": _ctlTitle.text,
      "rating": rating
    });

    var result = await productRepository.addReview(passedBody);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      submitLoadingFun(false);
    }, (data) {
      submitLoadingFun(false);

      var extractedData = json.decode(data.body);

      if (extractedData['response']) {
        CommonFunctions.showSuccessSnackbar(extractedData['msg']);
//  paginatedModel// .value!// .data!.add(ReviewModel(
//           review: _ctlReview.text, title: _ctlTitle.text, rating: rating));
        Get.back();
      } else {
        CommonFunctions.showErrorSnackbar(extractedData['msg']);
      }
    });
  }
}
