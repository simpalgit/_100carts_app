import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/user_address_model.dart';
import 'package:carts_app/Repositories/auth_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class AddressController extends GetxController {
  AuthRepository authRepository = AuthRepository();

  RxBool isLoading = true.obs;

  loadingFun(bool val) {
    isLoading.value = val;
  }

  RxBool isaveAddressLoad = false.obs;

  adddressSaveloadingFun(bool val) {
    isaveAddressLoad.value = val;
  }

  RxList<UserAddressModel> userAddressList = <UserAddressModel>[].obs;

  final Rx<TextEditingController> ctlFirstName = TextEditingController().obs;
  final Rx<TextEditingController> ctlLastName = TextEditingController().obs;
  final Rx<TextEditingController> ctlMobile = TextEditingController().obs;
  final Rx<TextEditingController> ctlEmail = TextEditingController().obs;
  final Rx<TextEditingController> ctlAddress = TextEditingController().obs;
  final Rx<TextEditingController> ctlLocality = TextEditingController().obs;
  final Rx<TextEditingController> ctlPostCode = TextEditingController().obs;

  RxString errorMobileText = "".obs,
      errorNameText = "".obs,
      errorLastNameText = "".obs,
      errorEmailText = "".obs,
      errorAddressText = "".obs,
      errorLocalityText = "".obs,
      errorPostCodeText = "".obs;

  initData() {
    isaveAddressLoad.value = false;
    isLoading.value = true;

    ctlFirstName.value.clear();
    ctlLastName.value.clear();
    ctlMobile.value.clear();
    ctlEmail.value.clear();
    ctlAddress.value.clear();
    ctlLocality.value.clear();
    ctlPostCode.value.clear();
    userAddressList.clear();
  }

  @override
  void dispose() {
    ctlFirstName.value.dispose();
    ctlLastName.value.dispose();
    ctlMobile.value.dispose();
    ctlEmail.value.dispose();
    ctlAddress.value.dispose();
    ctlLocality.value.dispose();
    ctlPostCode.value.dispose();
    super.dispose();
  }

  Future getSavedAddress(String from) async {
    if (from == "clear") {
      initData();
    }
    loadingFun(true);
    var result = await authRepository.getSavedAddress();

    result.fold((error) {
      loadingFun(false);
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) {
      userAddressList.value = data;
      if (from.isEmpty) {
        EasyLoading.dismiss();
      }

      loadingFun(false);
    });
  }

  Future saveAddress() async {
    adddressSaveloadingFun(true);

    var passedBody = json.encode({
      "first_name": ctlFirstName.value.text.trim(),
      "last_name": ctlLastName.value.text.trim(),
      "email": ctlEmail.value.text.trim(),
      "mobile": ctlMobile.value.text.trim(),
      "address": ctlAddress.value.text.trim(),
      "locality": ctlLocality.value.text.trim(),
      "postcode": ctlPostCode.value.text.trim(),
    });

    var result = await authRepository.saveAddress(passedBody);

    result.fold((error) {
      adddressSaveloadingFun(false);
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) async {
      errorMobileText.value = "";
      errorNameText.value = "";
      errorLastNameText.value = "";
      errorEmailText.value = "";
      errorAddressText.value = "";
      errorLocalityText.value = "";
      errorPostCodeText.value = "";

      if (data != null) {
        var responseJson = json.decode(data.body);

        if (data.statusCode == 400) {
          if (responseJson['success'] == false) {
            CommonFunctions.showSuccessSnackbar("msg");
            adddressSaveloadingFun(false);
          } else {
            responseJson['errors'].forEach((k, v) {
              if (k == "first_name") {
                errorNameText.value = v[0];
              }
              if (k == "last_name") {
                errorLastNameText.value = v[0];
              }
              if (k == "email") {
                errorEmailText.value = v[0];
              }
              if (k == "mobile") {
                errorMobileText.value = v[0];
              }
              if (k == "address") {
                errorAddressText.value = v[0];
              }
              if (k == "locality") {
                errorLocalityText.value = v[0];
              }
              if (k == "postcode") {
                errorPostCodeText.value = v[0];
              }
            });
            adddressSaveloadingFun(false);
          }
        } else if (data.statusCode == 200) {
          if (responseJson['response'] == true) {
            CommonFunctions.showSuccessSnackbar("Address Saved.");
            await getSavedAddress("");
            ctlFirstName.value.clear();
            ctlLastName.value.clear();
            ctlMobile.value.clear();
            ctlEmail.value.clear();
            ctlAddress.value.clear();
            ctlLocality.value.clear();
            ctlPostCode.value.clear();
          } else {
            CommonFunctions.showErrorSnackbar(responseJson['msg']);
          }
          adddressSaveloadingFun(false);
        }
      }
    });
  }

  Future deleteSavedAddress(BuildContext context, String id) async {
    await EasyLoading.show(
      status: 'Deleing saved Address',
      maskType: EasyLoadingMaskType.black,
    );

    var result = await authRepository.deleteAddress(id);

    result.fold((error) {
      EasyLoading.dismiss();
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) {
      getSavedAddress("");
    });
  }
}
