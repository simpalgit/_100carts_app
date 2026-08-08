import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Repositories/product_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class OrderlistController extends GetxController {
  ProductRepository productRepository = ProductRepository();

  RxList<OrderListModel> orderListList = <OrderListModel>[].obs;
  RxBool isWishLoading = false.obs;

  get paginatedModel => null;

  get scrollController => null;

  get orderList => null;

  get isLoading => null;

  initData() {
    isWishLoading = false.obs;
    orderListList.clear();
  }

  isLoadingWishlistFun(bool val) {
    isWishLoading.value = val;

    log("state : ${isWishLoading.value.toString()}");
  }

  Future getWishList() async {
    initData();
    await EasyLoading.show(
      status: 'Loading Orderlist...',
      maskType: EasyLoadingMaskType.black,
    );
    //  isLoadingFun(true);
    var result = await productRepository.getOrderListData();

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      //   isLoadingFun(false);
      EasyLoading.dismiss();
    }, (data) async {
      orderListList.value = data;
      EasyLoading.dismiss();
    });
  }

  Future addWishList(
    String from,
    dynamic model,
  ) async {
    model.isLoading = true;
    isLoadingWishlistFun(true);
    update();
    var result = await productRepository.addWishListData(from, model);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      model.isLoading = false;
      isLoadingWishlistFun(false);
      update();
    }, (data) {
      if (from == "home") {
        model.isFavorite = true;
      } else {
        model.data!.isFavourite = true;
      }

      model.isLoading = false;
      isLoadingWishlistFun(false);

      update();
    });
  }

  void removeWishList(
    String from,
    dynamic model,
  ) async {
    isLoadingWishlistFun(true);
    model.isLoading = true;
    update();
    var result = await productRepository.removeWishListData(
      model,
      from,
    );

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      model.isLoading = false;
      isLoadingWishlistFun(false);
      update();
    }, (data) {
      if (from == "home") {
        model.isFavorite = false;
      } else {
        model.data!.isFavourite = false;
      }
      model.isLoading = false;
      isLoadingWishlistFun(false);
      update();
    });
  }

  void removeProductFromWishList(
    dynamic model,
  ) async {
    await EasyLoading.show(
      status: 'Removing Product From Wishlist...',
      maskType: EasyLoadingMaskType.black,
    );
    var result = await productRepository.removeWishListData(
      model,
      "wishList",
    );

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      EasyLoading.dismiss();
    }, (data) {
      orderListList.remove(model);
      EasyLoading.dismiss();
    });
  }
}
