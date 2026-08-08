import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/create_pay_order_model.dart';
import 'package:carts_app/Models/user_address_model.dart';
import 'package:carts_app/Repositories/product_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/route_names.dart';

class CheckOutController extends GetxController {
  ProductRepository productRepository = ProductRepository();

  RxBool isLoading = true.obs;
  RxBool btnIsLoading = false.obs;

  RxBool isSaved = false.obs;

  loadingFun(bool val) {
    isLoading.value = val;
  }

  btnLoadingFun(bool val) {
    btnIsLoading.value = val;
  }

  changeSaved(bool val) {
    isSaved.value = val;
  }

  changeAddressSelection(bool val, UserAddressModel model) {
    for (var element in userAddressList) {
      element.changeSelection = false;
    }
    model.changeSelection = val;
    userAddressList.refresh();

    if (checkIfAddressSelected()) {
      changeSaved(false);
      ctlFirstName.value.text = model.firstName!;
      ctlLastName.value.text = model.lastName!;
      ctlMobile.value.text = model.mobile.toString();
      ctlEmail.value.text = model.email.toString();
      ctlAddress.value.text = model.address.toString();
      ctlLocality.value.text = model.locality.toString();
      ctlPostCode.value.text = model.postcode.toString();
    } else {
      changeSaved(false);
      ctlFirstName.value.clear();
      ctlLastName.value.clear();
      ctlMobile.value.clear();
      ctlEmail.value.clear();
      ctlAddress.value.clear();
      ctlLocality.value.clear();
      ctlPostCode.value.clear();
    }
  }

  bool checkIfAddressSelected() =>
      userAddressList.any((model) => model.selected ?? false);

  initData() {
    createPayOrderModel.value = CreatePayOrderModel();
    isLoading.value = true;
    isSaved.value = false;
    btnIsLoading.value = false;
    ctlFirstName.value.clear();
    ctlLastName.value.clear();
    ctlMobile.value.clear();
    ctlEmail.value.clear();
    ctlAddress.value.clear();
    ctlLocality.value.clear();
    ctlPostCode.value.clear();
    userAddressList.clear();
  }

  RxList<UserAddressModel> userAddressList = <UserAddressModel>[].obs;
  Rxn<CreatePayOrderModel> createPayOrderModel = Rxn<CreatePayOrderModel>();

  Future getSavedAddress() async {
    initData();
    loadingFun(true);
    var result = await productRepository.getSavedAddress();

    result.fold((error) {
      loadingFun(false);
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) {
      userAddressList.value = data;
      loadingFun(false);
    });
  }

  Future createPayOrder(String grandTotal) async {
    btnLoadingFun(true);

    var passedBody = json.encode({
      "first_name": ctlFirstName.value.text,
      "last_name": ctlLastName.value.text,
      "email": ctlEmail.value.text,
      "mobile": ctlMobile.value.text,
      "address": ctlAddress.value.text,
      "locality": ctlLocality.value.text,
      "postcode": ctlPostCode.value.text,
      "amount": grandTotal,
      "paymentType": ""
    });

    var result = await productRepository.cretePaymentOrder(passedBody);

    result.fold((error) {
      btnLoadingFun(false);
      CommonFunctions.showErrorSnackbar(error.message);
      btnLoadingFun(false);
    }, (data) async {
      createPayOrderModel.value = data;

      btnLoadingFun(false);
    });
  }

//copy
  Future<dynamic> createPayOrderAndroid(String paymentType) async {
    btnLoadingFun(true);

    var passedBody = json.encode({
      "first_name": ctlFirstName.value.text,
      "last_name": ctlLastName.value.text,
      "email": ctlEmail.value.text,
      "mobile": ctlMobile.value.text,
      "address": ctlAddress.value.text,
      "locality": ctlLocality.value.text,
      "postcode": ctlPostCode.value.text,
      "paymentType": paymentType
      // "amount": grandTotal
    });
    try {
      var result = await productRepository.cretePaymentOrderAndroid(passedBody);
      btnLoadingFun(false);

      return result;
    } catch (error) {
      CommonFunctions.showErrorSnackbar(error.toString());
      btnLoadingFun(false);
    }
    return null;
  }

  Future updateUserOrder(
    String payId,
    String orderId,
    String id,
  ) async {
    btnLoadingFun(true);

    String passedBody;

    passedBody = json.encode({
      "pay_id": payId,
      "orderId": orderId,
      "id": id,
    });

    var result = await productRepository.updateUserOrder(passedBody);

    result.fold((error) {
      EasyLoading.dismiss();
      print("error${error.message}");
      CommonFunctions.showErrorSnackbar(error.message);
      btnLoadingFun(false);
    }, (data) {
      // Get.toNamed(RouteName.paymentGatwayResponse, arguments: {
      //   "payId": payId,
      // });
      String responseBody = data.body; // Access the raw body
      Map<String, dynamic> jsonData =
          jsonDecode(responseBody); // Parse the JSON

      bool response = jsonData['response']; // Access 'response' field
      String message = jsonData['msg']; // Access 'msg' field
      if (response == true) {
        // CommonFunctions.showSuccessSnackbar("Order placed successful");
        _showOrderDetailsDialog();
        // Get.toNamed(RouteName.orderPlaceSuccessful);
      } else {
        CommonFunctions.showErrorSnackbar(message);
      }

      btnLoadingFun(false);
    });
    EasyLoading.dismiss();
  }

  void _showOrderDetailsDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Thank you for your order! Your order is now confirmed. You can expect to receive your items within 48 hours. Check the full order details and tracking information in your login panel.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteName.mainHomeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.white), // Hardcoded white text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final Rx<TextEditingController> ctlFirstName = TextEditingController().obs;
  final Rx<TextEditingController> ctlLastName = TextEditingController().obs;
  final Rx<TextEditingController> ctlMobile = TextEditingController().obs;
  final Rx<TextEditingController> ctlEmail = TextEditingController().obs;
  final Rx<TextEditingController> ctlAddress = TextEditingController().obs;
  final Rx<TextEditingController> ctlLocality = TextEditingController().obs;
  final Rx<TextEditingController> ctlPostCode = TextEditingController().obs;

  @override
  void dispose() {
    ctlFirstName.value.clear();
    ctlLastName.value.clear();
    ctlMobile.value.clear();
    ctlEmail.value.clear();
    ctlAddress.value.clear();
    ctlLocality.value.clear();
    ctlPostCode.value.clear();
    super.dispose();
  }
}
