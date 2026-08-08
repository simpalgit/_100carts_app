import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPartnerConrtroller extends GetxController {
  RxBool isLoggingIn = false.obs;
  Rx<TextEditingController> ctlMobile =
      TextEditingController(text: "992003058").obs;
  final Rx<TextEditingController> ctlPassword = TextEditingController().obs;
  RxBool btnEnable = false.obs;
  RxBool showHidePass = true.obs;
  RxString errorMobileText = "".obs;
  RxString errorPasswordText = "".obs;

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

  @override
  void dispose() {
    ctlMobile.value.dispose();
    ctlPassword.value.dispose();
    super.dispose();
  }
}
