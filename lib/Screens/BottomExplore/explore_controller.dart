import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/category_model.dart';
import 'package:carts_app/Models/explore_paginated_model.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/order_attribute_model.dart';
import 'package:carts_app/Repositories/main_home_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class ExploreController extends GetxController {
  MainHomeRepository mainHomeRepository = MainHomeRepository();

  Rxn<UserProductPaginatedModel> paginatedModel =
      Rxn<UserProductPaginatedModel>();
  final RxList<ProductModel> productList = <ProductModel>[].obs;

  RxBool isLoading = false.obs;
  RxBool applyLoading = false.obs;
  RxBool isProductsEmpty = false.obs;
  int offset = 0;
  RxInt selectedIndex = 0.obs;

  final ScrollController scrollController = ScrollController();
  RxList<OrderAttribute> attributeList = <OrderAttribute>[].obs;
  RxList<OrderAttribute> filterList = <OrderAttribute>[].obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  Map<String, List<String>> checkboxValuesMap = {};
  RxString finalFilterQuery = "".obs;

  CategoryModel selectedCat = CategoryModel();

  loadingFun(bool val) {
    isLoading.value = val;
  }

  applyLoadingFun(bool val) {
    applyLoading.value = val;
  }

  initData(String from) {
    offset = 0;

    productList.clear();
    if (from == "init") {
      checkboxValuesMap.clear();
      finalFilterQuery.value = "";
    }
  }

  Future getProductList(
    int offset,
    String from,
    String catId,
  ) async {
    if (offset == 0) {
      initData(from);
      applyLoadingFun(true);
      loadingFun(true);
    }
    var result = await mainHomeRepository.getAllProductListWithPagination(
        offset, catId, finalFilterQuery.value);

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

  Future getAttributeList(String catId) async {
    initData("init");
    filterList.clear();
    attributeList.clear();
    var result =
        await mainHomeRepository.getAttributeListCategory(int.parse(catId));

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) {
      filterList.clear();
      attributeList.value = data;
      filterList.value = data;
    });
  }

  Map<String, List<String>> returnSelectedAttribnutes(dynamic attribute) {
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

  RxBool selection = false.obs;
  changeSelection(bool val) {
    selection.value = val;
  }

  queryGenerater(FilterModel filterModel, dynamic attribute) {
    changeSelection(true);
    filterModel.isSelected = !filterModel.isSelected;
    changeSelection(false);

    var helper = returnSelectedAttribnutes(attribute);
    checkboxValuesMap.addEntries(helper.entries);
    String helprt = buildQueryStringFromCheckboxValues(checkboxValuesMap);
    finalFilterQuery.value = helprt.replaceAll("%2", ",");
  }

  Future getParentCategory() async {
    selectedCat = CategoryModel();
    selectedIndex.value = 0;
    initData("init");
    applyLoadingFun(true);
    loadingFun(true);
    var result = await mainHomeRepository.getParentCategory();

    result.fold((error) {
      applyLoadingFun(false);
      loadingFun(false);

      EasyLoading.dismiss();
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) async {
      categoryList.value = data;
      paginatedModel.value = null;
      if (categoryList.isNotEmpty) {
        selectedCat = categoryList[0];
        [
          getAttributeList(selectedCat.id.toString()),
          getProductList(0, "init", selectedCat.id.toString())
        ];
      }
    });
  }

  selectIndex(
    BuildContext context,
    int? index,
    CategoryModel? model,
  ) async {
    if (selectedIndex.value == index) {
      return;
    }
    selectedIndex.value = index ?? 0;

    selectedCat = model!;

    [
      getProductList(0, "init", selectedCat.id.toString()),
      await getAttributeList(selectedCat.id.toString())
    ];
    // getProductList(context, 0, "init", "");
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
