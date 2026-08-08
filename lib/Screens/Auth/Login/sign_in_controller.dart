import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Repositories/auth_repository.dart';
import 'package:carts_app/Screens/BottomExplore/explore_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/navigation_bar_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';
import 'package:carts_app/Utils/route_names.dart';

class LoginController extends GetxController {
  AuthRepository authRepository = AuthRepository();
  RxBool isLoggingIn = false.obs;
  final Rx<TextEditingController> ctlMobile = TextEditingController().obs;
  final Rx<TextEditingController> ctlPassword = TextEditingController().obs;
  RxBool btnEnable = false.obs;
  RxBool showHidePass = true.obs;
  RxString errorMobileText = "".obs;
  RxString errorPasswordText = "".obs;

  isLogging(bool val) {
    isLoggingIn.value = val;
  }

  initData() {
    ctlMobile.value.clear();
    ctlPassword.value.clear();
    btnEnable = false.obs;
    showHidePass = true.obs;
  }

  void checkNumberLength(int length) {
    if (length == 10) {
      btnEnable.value = true;
    } else {
      btnEnable.value = false;
    }
  }

  void changeShowhidePass() {
    showHidePass.value = !showHidePass.value;
  }

  Future<void> login(BuildContext context, String from) async {
    isLogging(true);
    CommonFunctions.hideKeyboard(context);
    var passedData = json.encode({
      "mobile": ctlMobile.value.text,
      "password": ctlPassword.value.text,
    });
    var result = await authRepository.loginUser(
      ctlMobile.value.text,
      ctlPassword.value.text,
    );

    result.fold((error) {
      isLogging(false);
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) async {
      errorMobileText.value = "";
      errorPasswordText.value = "";

      if (data != null) {
        var responseJson = json.decode(data.body);

        if (data.statusCode == 400) {
          if (responseJson['success'] == false) {
            CommonFunctions.showErrorSnackbar(responseJson['message']);
            isLogging(false);
          } else {
            responseJson['errors'].forEach((k, v) {
              if (k == "mobile") {
                errorMobileText.value = v[0];
              }
              if (k == "password") {
                errorPasswordText.value = v[0];
              }
            });
            isLogging(false);
          }
        } else if (data.statusCode == 200) {
          if (responseJson['response'] == "true") {
            int passed = 0;
            log('Token : ${responseJson['access_token']}');
            LocalPreferences().setLoginBool(true);
            LocalPreferences().setAuthToken(responseJson['access_token']);
            CommonFunctions.showSuccessSnackbar("Login Successful.");
            final homeController = BottomNavigiationController();
            HomeScreenController mainHomeController = Get.find();

            if (from == "BottomProfile") {
              passed = 3;
            } else if (from == "BottomOrder") {
              passed = 2;
            } else {
              passed = 0;
            }
            homeController.navListener.sink.add(passed);
            mainHomeController.getProfile();
            final HomeScreenController mainHomecontroller = Get.find();
            final ExploreController exploreController = Get.find();

            await mainHomecontroller.getHomeData("72.8397", "19.3919");
            exploreController.getParentCategory();
            mainHomeController.onChangeIndex(passed);
            Get.offAllNamed(RouteName.mainHomeScreen,
                arguments: {"initPage": passed});
          } else {
            CommonFunctions.showErrorSnackbar(responseJson['msg']);
          }
          isLogging(false);
        }
      }
    });
  }

  @override
  void dispose() {
    ctlMobile.value.dispose();
    ctlPassword.value.dispose();
    super.dispose();
  }
}
