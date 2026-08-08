import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/MainHomeScreen/Component/navigation_bar_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';
import 'package:carts_app/Widgets/error_found_widgets.dart';
import 'package:carts_app/Widgets/input_fields.dart';

import 'sign_in_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _homeController = BottomNavigiationController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  HomeScreenController mainHomeController = Get.find();
  final loginController = Get.put(LoginController());
  String from = "";
  bool fromMainBottom = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      if (data != null) {
        from = data['from'] as String? ?? "";
        fromMainBottom = data['fromMainBottom'] as bool? ?? false;
        setState(() {});
      }
    });
    super.initState();
  }

  checkFromBottom(bool didPop) {
    if (didPop) return;
    if (fromMainBottom) {
      mainHomeController.onChangeIndex(0);
      _homeController.navListener.sink.add(0);
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => checkFromBottom(didPop),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          backgroundColor: whiteColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          checkFromBottom(false);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: blackColor,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // App Logo
                          Center(
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              height: 150,
                              width: 150,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.mukta(
                                  color: primaryColor,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              "Welcome to 100CARTS",
                              style: GoogleFonts.mukta(
                                  color: blackColor, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          LoginTextField(
                            onChange: (value) {
                              loginController.checkNumberLength(value.length);
                            },
                            pref: const Icon(
                              CupertinoIcons.phone,
                              color: blackColor,
                            ),
                            controllerValue: loginController.ctlMobile.value,
                            hintText: 'Mobile',
                            mLength: 10,
                            inputType: TextInputType.phone,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return "Cant be Empty.";
                              } else {
                                return null;
                              }
                            },
                          ),
                          Obx(
                            () => loginController.errorMobileText.value.isEmpty
                                ? Container()
                                : ErrorText(
                                    error:
                                        loginController.errorMobileText.value,
                                    errorColor: primaryColor,
                                  ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Obx(
                            () => LoginTextField(
                              pref: const Icon(
                                CupertinoIcons.lock,
                                color: blackColor,
                              ),
                              obsText: loginController.showHidePass.value,
                              suf: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        loginController.changeShowhidePass();
                                      },
                                      child: Icon(
                                        loginController.showHidePass.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: primaryColor,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                              controllerValue:
                                  loginController.ctlPassword.value,
                              hintText: 'Password',
                              inputType: TextInputType.visiblePassword,
                              validate: (val) {
                                if (val!.isEmpty) {
                                  return "Cant be Empty.";
                                } else if (val.length < 8) {
                                  return "Password length should be 8 digit.";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Obx(
                            () =>
                                loginController.errorPasswordText.value.isEmpty
                                    ? Container()
                                    : ErrorText(
                                        error: loginController
                                            .errorPasswordText.value,
                                        errorColor: primaryColor,
                                      ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () =>
                                  Get.toNamed(RouteName.forgotPasswordScreen),
                              child: Text(
                                "Forgot your password ?",
                                style: GoogleFonts.mukta(
                                    color: blackColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      backgroundColor: primaryColor),
                                  onPressed: loginController.btnEnable.value
                                      ? loginController.isLoggingIn.value
                                          ? null
                                          : () {
                                              final isValid = _formKey
                                                  .currentState!
                                                  .validate();

                                              if (!isValid) {
                                                return;
                                              }
                                              _formKey.currentState!.save();
                                              loginController.login(
                                                  context, from);
                                            }
                                      : null,
                                  child: loginController.isLoggingIn.value
                                      ? const CommonButtonLoader(
                                          indicatorColor: whiteColor,
                                        )
                                      : Text(
                                          "Sign In",
                                          style: GoogleFonts.mukta(
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account ? ",
                                style: GoogleFonts.mukta(
                                  fontSize: 14,
                                  color: blackColor,
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    Get.toNamed(RouteName.signUpScreen),
                                child: Text(
                                  "Sign Up",
                                  style: GoogleFonts.mukta(
                                      fontSize: 13,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
