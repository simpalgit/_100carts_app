import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Repositories/auth_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class SignUpController extends GetxController {
  AuthRepository authRepository = AuthRepository();

  final Rx<TextEditingController> ctlUserName = TextEditingController().obs;
  final Rx<TextEditingController> ctlMobile = TextEditingController().obs;
  final Rx<TextEditingController> ctlEmail = TextEditingController().obs;
  final Rx<TextEditingController> ctlPassword = TextEditingController().obs;
  final Rx<TextEditingController> ctlConfPassword = TextEditingController().obs;
  final Rx<TextEditingController> ctlOtp = TextEditingController().obs;

  RxBool showHidePass = true.obs;
  RxBool showHideConfPass = true.obs;
  RxBool otpLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool showOtp = false.obs;
  RxString mobileNo = "".obs;

  RxString errorMobileText = "".obs,
      errorUserNameText = "".obs,
      errorPasswordText = "".obs,
      errorEmailText = "".obs,
      errorOTPText = "".obs;

  initData() {
    ctlUserName.value.clear();
    ctlMobile.value.clear();
    ctlEmail.value.clear();
    ctlPassword.value.clear();
    ctlConfPassword.value.clear();
    showHidePass.value = true;
    showHideConfPass.value = true;
    isLoading.value = false;
    otpLoading.value = false;
    showOtp.value = false;
    errorMobileText.value = "";
    errorUserNameText.value = "";
    errorPasswordText.value = "";
    errorEmailText.value = "";
    errorOTPText.value = "";
  }

  @override
  void dispose() {
    ctlUserName.value.dispose();
    ctlMobile.value.dispose();
    ctlEmail.value.dispose();
    ctlPassword.value.dispose();
    ctlConfPassword.value.dispose();
    ctlOtp.value.dispose();
    super.dispose();
  }

  Future onChangedFun(String mobile, BuildContext context) async {
    if (mobile.length == 10) {
      mobileNo.value = mobile;
      await getOtp(context);
    } else {
      errorMobileText.value = "";
      showOtp.value = false;
      ctlOtp.value.clear();
    }
  }

  loadingFun(bool val) {
    isLoading.value = val;
  }

  otpLoadingFun(bool val) {
    otpLoading.value = val;
  }

  void changeShowhidePass() {
    showHidePass.value = !showHidePass.value;
  }

  void changeShowhideConfPass() {
    showHideConfPass.value = !showHideConfPass.value;
  }

  Future<void> registerUser(
    BuildContext context,
  ) async {
    loadingFun(true);
    CommonFunctions.hideKeyboard(context);
    if (ctlPassword.value.text != ctlConfPassword.value.text) {
      CommonFunctions.showErrorSnackbar("Password does not match.");
      loadingFun(false);
    } else {
      var jsonBody = json.encode({
        "name": ctlUserName.value.text,
        "email": ctlEmail.value.text,
        "mobile": ctlMobile.value.text,
        "password": ctlPassword.value.text,
        "otp": ctlOtp.value.text
      });
      var result = await authRepository.registerUser(jsonBody);

      result.fold((error) {
        CommonFunctions.showErrorSnackbar(error.message);

        loadingFun(false);
      }, (data) {
        errorUserNameText.value = "";
        errorMobileText.value = "";
        errorPasswordText.value = "";
        errorEmailText.value = "";
        if (data != null) {
          var responseJson = json.decode(data.body);

          if (data.statusCode == 400) {
            responseJson['errors'].forEach((k, v) {
              if (k == "name") {
                errorUserNameText.value = v[0];
              }
              if (k == "mobile") {
                errorMobileText.value = v[0];
              }
              if (k == "password") {
                errorPasswordText.value = v[0];
              }
              if (k == "email") {
                errorEmailText.value = v[0];
              }
              if (k == "otp") {
                errorEmailText.value = v[0];
              }
            });
          } else {
            if (responseJson['response'] == true) {
              CommonFunctions.showSuccessSnackbar("Login with new credentials");
              Get.back();
            } else {
              CommonFunctions.showErrorSnackbar(responseJson['msg']);
            }
          }
        }

        loadingFun(false);
      });
    }
  }

  Future<void> getOtp(BuildContext context) async {
    otpLoadingFun(true);

    var passedData = json.encode({
      "mobile": ctlMobile.value.text,
    });
    final result = await authRepository.sendOtp(
      passedData: passedData,
    );

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(error.message);
        otpLoadingFun(false);
      },
      (data) {
        errorMobileText.value = "";

        if (data != null) {
          var responseJson = json.decode(data.body);

          if (data.statusCode == 400) {
            if (responseJson['response'] == false) {
              responseJson['errors'].forEach((k, v) {
                if (k == "mobile") {
                  errorMobileText.value = v[0];
                }
              });
            }
          } else if (data.statusCode == 200) {
            showOtp.value = true;
            CommonFunctions.showSuccessSnackbar("Otp sent Successfully");
          }
        }

        otpLoadingFun(false);
      },
    );
  }
}
