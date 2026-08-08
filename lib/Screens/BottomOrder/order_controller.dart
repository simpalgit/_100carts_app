import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/user_order_model.dart';
import 'package:carts_app/Repositories/main_home_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class OrderController extends GetxController {
  MainHomeRepository mainHomeRepository = MainHomeRepository();
  final ScrollController scrollController = ScrollController();
  RxBool applyLoading = false.obs;
  RxBool isLoading = false.obs;
  RxInt offset = 0.obs;

  final RxList<UserOrderList> orderList = <UserOrderList>[].obs;
  Rxn<UserOrderPaginatedModel> paginatedModel = Rxn<UserOrderPaginatedModel>();

  initData() {
    offset.value = 0;
    orderList.clear();
  }

  applyLoadingFun(bool val) => applyLoading.value = val;
  loadingFun(bool val) => isLoading.value = val;

  Future getOrderList(int offset, String from) async {
    if (offset == 0) {
      initData();
      applyLoadingFun(true);
      loadingFun(true);
    }
    var result = await mainHomeRepository.getOrderList(offset);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);

      if (offset == 0) {
        loadingFun(false);
        applyLoadingFun(false);
      }
    }, (data) {
      paginatedModel.value = data;
      orderList.addAll(data.data!);
      if (offset == 0) {
        loadingFun(false);
        applyLoadingFun(false);
      }
    });
  }
}
