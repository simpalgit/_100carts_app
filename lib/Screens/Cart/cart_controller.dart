import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Repositories/product_repository.dart';
import 'package:carts_app/Screens/Cart/quantity_controller.dart';
import 'package:carts_app/Screens/ProductDetail/Components/product_detail_component.dart';
import 'package:carts_app/Utils/common_functions.dart';

class CartController extends GetxController {
  ProductRepository productRepository = ProductRepository();
  initData() {
    cartList.clear();
  }

  late final QuantityController quantityController =
      Get.find<QuantityController>();

  // final quantitymodal quantityInstance = Get.find();
  // final ProductDetailComponent dataController =
  //     Get.find<ProductDetailComponent>();

  RxList<ProductModel> cartList = <ProductModel>[].obs;

  double total = 0.0;
  double tax = 0.0;
  double grandTotal = 0.0;
  String? selectedGender;

  getCartTotal() {
    total = 0.0;
    total = cartList.fold(
        0.0,
        (total, product) =>
            total + (product.activePrice!.price! * product.quantity!));
    return total;
  }

  double getCartTaxTotal() {
    tax = 0.0;
    tax = cartList.fold(0.0, (tax, product) => tax + (product.product!.tax!));
    return tax;
  }

  double getCartShippingTotal() {
    tax = 0.0;
    tax = cartList.fold(0.0, (tax, product) => tax + (product.product!.tax!));
    return tax;
  }

  double getGrandTotal() {
    grandTotal = 0.0;
    grandTotal = total + tax;
    return grandTotal;
  }

  getAllTotal() {
    getCartTotal();
    getCartTaxTotal();
    getGrandTotal();
  }

  Future getCartList() async {
    initData();
    await EasyLoading.show(
      status: 'Loading Cart Please wait..',
      maskType: EasyLoadingMaskType.black,
    );
    var result = await productRepository.getCartData();

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      EasyLoading.dismiss();
    }, (data) async {
      cartList.value = data;
      getAllTotal();
      EasyLoading.dismiss();
    });
  }

  Future addCartData(String prodId, String variationId) async {
    await EasyLoading.show(
      status: 'Adding product inside Cart...',
      maskType: EasyLoadingMaskType.black,
    );
    int currentQuantity = quantityController.currentQuantity.value;
    print("currentQuantity$currentQuantity");
    var result = await productRepository.addCartData(
        prodId, variationId, currentQuantity);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      EasyLoading.dismiss();
    }, (data) {
      var jsonData = json.decode(data.body);

      if (jsonData["response"]) {
        getAllTotal();
        CommonFunctions.showSuccessSnackbar("Item added in cart.");
      } else {
        CommonFunctions.showWarningSnackbar(
            "Item already present in the cart.");
      }

      EasyLoading.dismiss();
    });
  }

  void removeCartData(
    ProductModel model,
  ) async {
    await EasyLoading.show(
      status: 'Removing product from Cart...',
      maskType: EasyLoadingMaskType.black,
    );
    var result = await productRepository.removeCartData(model);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      EasyLoading.dismiss();
    }, (data) {
      if (data["response"]) {
        CommonFunctions.showSuccessSnackbar(data["msg"]);
        cartList.remove(model);
      } else {
        CommonFunctions.showWarningSnackbar(data["msg"]);
      }
      getAllTotal();

      EasyLoading.dismiss();
    });
  }
}
