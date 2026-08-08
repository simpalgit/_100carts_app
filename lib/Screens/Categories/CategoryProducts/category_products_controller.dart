import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/category_model.dart';
import 'package:carts_app/Models/explore_paginated_model.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/order_attribute_model.dart';
import 'package:carts_app/Repositories/main_home_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class CategoryProductController extends GetxController {
  MainHomeRepository mainHomeRepository = MainHomeRepository();
  final ScrollController scrollController = ScrollController();
  int offset = 0;
  Rxn<CategoryModel> selectedCat = Rxn<CategoryModel>();
  final RxList<ProductModel> productList = <ProductModel>[].obs;
  Rxn<UserProductPaginatedModel> paginatedModel =
      Rxn<UserProductPaginatedModel>();
  Map<String, List<String>> checkboxValuesMap = {};
  RxString finalFilterQuery = "".obs;
  RxBool applyLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isProductsEmpty = false.obs;

  initData(String from) {
    offset = 0;

    productList.clear();
    if (from == "init") {
      checkboxValuesMap.clear();
      finalFilterQuery.value = "";
    }
  }

  loadingFun(bool val) {
    isLoading.value = val;
  }

  applyLoadingFun(bool val) {
    applyLoading.value = val;
  }

  Future getProductList(
    int offset,
    String from,
    CategoryModel category,
  ) async {
    selectedCat.value = category;
    if (offset == 0) {
      initData(from);
      applyLoadingFun(true);
      loadingFun(true);
    }
    var result = await mainHomeRepository.getAllProductListWithPagination(
        offset, category.id.toString(), finalFilterQuery.value);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);

      if (offset == 0) {
        loadingFun(false);
        applyLoadingFun(false);
      }
    }, (data) {
      paginatedModel.value = data;
      productList.addAll(data.data!);
      isProductsEmpty.value = productList.isEmpty;
      if (offset == 0) {
        loadingFun(false);
        applyLoadingFun(false);
      }
    });
  }

  RxList<OrderAttribute> filterList = <OrderAttribute>[].obs;
  RxList<OrderAttribute> attributeList = <OrderAttribute>[].obs;
  Future getAttributeList(String catId) async {
    initData("init");
    // filterList.clear();
    // attributeList.clear();
    var result =
        await mainHomeRepository.getAttributeListCategory(int.parse(catId));

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) {
      // filterList.clear();
      // attributeList.value = data;
      // filterList.value = data;
    });
  }

  RxBool selection = false.obs;
  changeSelection(bool val) {
    selection.value = val;
  }

  queryGenerater(FilterModel filterModel, OrderAttribute attribute) {
    changeSelection(true);
    filterModel.isSelected = !filterModel.isSelected;
    changeSelection(false);

    var helper = returnSelectedAttribnutes(attribute);
    checkboxValuesMap.addEntries(helper.entries);
    String helprt = buildQueryStringFromCheckboxValues(checkboxValuesMap);
    finalFilterQuery.value = helprt.replaceAll("%2", ",");
  }

  Map<String, List<String>> returnSelectedAttribnutes(
      OrderAttribute attribute) {
    return {
      attribute.attributeName!: attribute.attributeValues!
          .where((element) => element.isSelected == true)
          .toList()
          .map(
            (e) => e.value!,
          )
          .toList()
    };
  }

  String buildQueryStringFromCheckboxValues(
      Map<String, List<String>> checkboxValuesMap) {
    String queryString = '';
    checkboxValuesMap.forEach((groupName, values) {
      if (values.isNotEmpty) {
        queryString += '$groupName=${values.join(',')}&';
      }
    });
    return queryString.isEmpty
        ? ""
        : queryString.substring(0, queryString.length - 1);
  }
}
