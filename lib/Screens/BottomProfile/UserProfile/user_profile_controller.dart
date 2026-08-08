import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/user_profile_model.dart';
import 'package:carts_app/Utils/common_functions.dart';

class UserProfileController extends GetxController {
  final Rx<TextEditingController> ctlName = TextEditingController().obs;
  final Rx<TextEditingController> ctlMobile = TextEditingController().obs;
  final Rx<TextEditingController> ctlEmail = TextEditingController().obs;
  final Rx<TextEditingController> ctlPassword = TextEditingController().obs;

  initData() async {
    UserProfileModel data = await CommonFunctions().getProfileData();

    ctlName.value.text = data.name ?? "";
    ctlMobile.value.text = data.mobile.toString();
    ctlEmail.value.text = data.email.toString();
  }

  @override
  void dispose() {
    ctlMobile.value.dispose();
    ctlPassword.value.dispose();
    super.dispose();
  }
}
