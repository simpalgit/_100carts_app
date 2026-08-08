import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Repositories/auth_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class ForgotPasswordController extends GetxController {
  AuthRepository authRepository = AuthRepository();
  RxBool showOTPField = false.obs;
  RxBool otpLoading = false.obs;
  RxBool isLoading = false.obs;

  final Rx<TextEditingController> textOTPController =
      TextEditingController().obs;

  final Rx<TextEditingController> textMobileController =
      TextEditingController().obs;

  final Rx<TextEditingController> ctlPassword = TextEditingController().obs;

  final Rx<TextEditingController> ctlConfPassword = TextEditingController().obs;

  RxString errorMobileText = ''.obs;

  loadingFun(bool val) {
    isLoading.value = val;
  }

  initData() {
    showOTPField.value = false;
    otpLoading.value = false;
    textOTPController.value.clear();
    textMobileController.value.clear();
    ctlPassword.value.clear();
    ctlConfPassword.value.clear();
    errorMobileText.value = "";
    isLoading.value = false;
  }

  otpLoadingFun(bool val) {
    otpLoading.value = val;
  }

  Future showOtpFieldFun(BuildContext context, bool val) async {
    if (!val) {
      textOTPController.value.clear();
      showOTPField.value = false;
    } else {
      await getOtp(context);
    }
  }

  Future<void> getOtp(
    BuildContext context,
  ) async {
    otpLoadingFun(true);
    final result = await authRepository.sendOTP(
      textMobileController.value.text,
    );

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(error.message);
        otpLoadingFun(false);
      },
      (data) {
        var responseJson = json.decode(data.body);

        if (responseJson['response'] == true) {
          errorMobileText.value = "";
          CommonFunctions.showSuccessSnackbar(responseJson['msg']);
          showOTPField.value = true;
        } else {
          responseJson["errors"].forEach((k, v) {
            if (k == "mobile") {
              errorMobileText.value = v[0];
            }
          });
          showOTPField.value = false;
          CommonFunctions.showSuccessSnackbar(errorMobileText.value);
        }

        otpLoadingFun(false);
      },
    );
  }

  Future<void> forgotPassword(BuildContext context) async {
    loadingFun(true);
    CommonFunctions.hideKeyboard(context);
    if (ctlPassword.value.text != ctlConfPassword.value.text) {
      CommonFunctions.showErrorSnackbar("Password does not match.");
      loadingFun(false);
    } else {
      var jsonBody = json.encode({
        "mobile": textMobileController.value.text.trim(),
        "otp": textOTPController.value.text.trim(),
        "password": ctlPassword.value.text.trim(),
      });
      var result = await authRepository.forgetPassword(
        jsonBody,
      );

      result.fold((error) {
        CommonFunctions.showErrorSnackbar(error.message);

        loadingFun(false);
      }, (data) {
        if (data != null) {
          var responseJson = json.decode(data.body);

          if (responseJson['response'] == true) {
            Get.back();
            CommonFunctions.showSuccessSnackbar(
                "Changed Password successfully.");
          } else {
            CommonFunctions.showErrorSnackbar(responseJson["msg"]);
          }
        }

        loadingFun(false);
      });
    }
  }

  @override
  void dispose() {
    textOTPController.value.dispose();
    textMobileController.value.dispose();
    ctlPassword.value.dispose();
    ctlConfPassword.value.dispose();
    super.dispose();
  }
}
