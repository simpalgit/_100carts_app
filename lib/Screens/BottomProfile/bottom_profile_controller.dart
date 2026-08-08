import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carts_app/Repositories/auth_repository.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/navigation_bar_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';

class BottomProfileController extends GetxController {
  Rx<TextEditingController> ctlDeleteOtp = TextEditingController().obs;
  AuthRepository authRepository = AuthRepository();

  RxBool isDeleting = false.obs, isOtpLoading = false.obs;

  isDeletingFun(bool val) => isDeleting.value = val;
  isOtpLoadingFun(bool val) => isOtpLoading.value = val;

  Future<void> getDeleteOtp(
      BuildContext context, Widget darkRoundedPinPut) async {
    isOtpLoadingFun(true);

    final result = await authRepository.sendDeleteOtp();

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(error.message);
        isOtpLoadingFun(false);
      },
      (data) {
        if (data != null) {
          //  var responseJson = json.decode(data.body);

          if (data.statusCode == 400) {
            isOtpLoadingFun(false);
          } else if (data.statusCode == 200) {
            ctlDeleteOtp.value.clear();

            Get.back();
            Get.defaultDialog(
                titlePadding:
                    const EdgeInsets.only(top: 20, left: 20, right: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                title: "Delete Account",
                titleStyle: GoogleFonts.mukta(
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                    fontSize: 16),
                content: Column(
                  children: [
                    Text(
                      "We have sent you otp on your number.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mukta(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    darkRoundedPinPut,
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.mukta(color: whiteColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      deleteAccount(context);
                    },
                    child: Text(
                      "Delete Account",
                      style: GoogleFonts.mukta(color: whiteColor),
                    ),
                  ),
                ]);
          }
        }

        isOtpLoadingFun(false);
      },
    );
  }

  deleteAccount(BuildContext context) async {
    await EasyLoading.show(
      status: 'Deleting you account...',
      maskType: EasyLoadingMaskType.black,
    );

    isDeletingFun(true);

    var passedBody = json.encode({"otp": ctlDeleteOtp.value.text});
    var result = await authRepository.deleteAccount(passedBody);

    result.fold((error) {
      EasyLoading.dismiss();
      isDeletingFun(false);
      Get.snackbar(
        "",
        "",
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        titleText: Text(
          error.message,
          style:
              GoogleFonts.mukta(color: whiteColor, fontWeight: FontWeight.bold),
        ),
        messageText: Text(
          "",
          style: GoogleFonts.mukta(color: whiteColor),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }, (data) async {
      EasyLoading.dismiss();
      if (data['response']) {
        isDeletingFun(false);
        LocalPreferences().setLoginBool(false);
        final preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        if (context.mounted) {
          LocalPreferences().setLoginBool(false);
          final preferences = await SharedPreferences.getInstance();
          await preferences.clear();

          HomeScreenController homeScreenController = Get.find();

          final homeController = BottomNavigiationController();
          homeController.navListener.sink.add(0);
          homeScreenController.onChangeIndex(0);
        }
      } else {
        isDeletingFun(false);
        Get.snackbar(
          "",
          "",
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          titleText: Text(
            data['msg'],
            style: GoogleFonts.mukta(
                color: whiteColor, fontWeight: FontWeight.bold),
          ),
          messageText: Text(
            "",
            style: GoogleFonts.mukta(color: whiteColor),
          ),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }

      isDeletingFun(false);
    });
  }
}
