import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';
import 'package:carts_app/Widgets/error_found_widgets.dart';
import 'package:carts_app/Widgets/input_fields.dart';

import 'sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final controller = Get.put(SignUpController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initData();
    });
    super.initState();
  }

  bool _buttonEnabled = false;
  Timer? _timer;
  int _timerSeconds = 30;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _buttonEnabled = true;
          _timer!.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                        Get.back();
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
                            "Sign Up",
                            style: GoogleFonts.mukta(
                                color: primaryColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Register yourself.",
                            style: GoogleFonts.mukta(
                                color: blackColor, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        LoginTextField(
                          pref: const Icon(
                            CupertinoIcons.person,
                            color: blackColor,
                          ),
                          controllerValue: controller.ctlUserName.value,
                          hintText: 'Username',
                          inputType: TextInputType.text,
                          validate: (val) {
                            if (val!.isEmpty) {
                              return "Cant be Empty.";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Obx(
                          () => controller.errorUserNameText.value.isEmpty
                              ? Container()
                              : ErrorText(
                                  error: controller.errorUserNameText.value,
                                  errorColor: primaryColor,
                                ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        LoginTextField(
                          pref: const Icon(
                            CupertinoIcons.phone,
                            color: blackColor,
                          ),
                          mLength: 10,
                          controllerValue: controller.ctlMobile.value,
                          hintText: 'Mobile',
                          inputType: TextInputType.phone,
                          onChange: (value) {
                            controller
                                .onChangedFun(value, context)
                                .then((value) {
                              if (controller.showOtp.value) {
                                _startTimer();
                              }
                            });
                          },
                          validate: (val) {
                            if (val!.isEmpty) {
                              return "Cant be Empty.";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Obx(
                          () => controller.errorMobileText.value.isEmpty
                              ? Container()
                              : ErrorText(
                                  error: controller.errorMobileText.value,
                                  errorColor: primaryColor,
                                ),
                        ),
                        Obx(
                          () => controller.otpLoading.value
                              ? SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'sending otp..',
                                        style: GoogleFonts.mukta(
                                            fontWeight: FontWeight.bold,
                                            color: blackColor),
                                      )
                                    ],
                                  ),
                                )
                              : controller.showOtp.value
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Otp sent on ${controller.mobileNo.value} .",
                                              style: GoogleFonts.mukta(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          darkRoundedPinPut(controller),
                                          Obx(
                                            () => controller
                                                    .errorOTPText.isEmpty
                                                ? Container()
                                                : ErrorText(
                                                    error: controller
                                                        .errorOTPText.value,
                                                    errorColor: primaryColor,
                                                  ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextButton(
                                              onPressed: _buttonEnabled
                                                  ? () {
                                                      controller
                                                          .getOtp(context)
                                                          .then((value) {
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 1),
                                                            () {
                                                          setState(() {
                                                            _timerSeconds = 30;
                                                            _buttonEnabled =
                                                                false;
                                                          });
                                                          _startTimer();
                                                        });
                                                      });
                                                    }
                                                  : null,
                                              child: Text(
                                                _buttonEnabled
                                                    ? "Resend Otp"
                                                    : 'Resend Otp in $_timerSeconds seconds',
                                                style: GoogleFonts.mukta(
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryColor),
                                              )),
                                        ],
                                      ),
                                    )
                                  : Container(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        LoginTextField(
                          pref: const Icon(
                            CupertinoIcons.mail,
                            color: blackColor,
                          ),
                          controllerValue: controller.ctlEmail.value,
                          hintText: 'Email Address',
                          inputType: TextInputType.emailAddress,
                          validate: (val) {
                            if (val!.isEmpty) {
                              return "Cant be Empty.";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Obx(
                          () => controller.errorEmailText.value.isEmpty
                              ? Container()
                              : ErrorText(
                                  error: controller.errorEmailText.value,
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
                            obsText: controller.showHidePass.value,
                            suf: InkWell(
                                onTap: () {
                                  controller.changeShowhidePass();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    controller.showHidePass.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: blackColor,
                                  ),
                                )),
                            controllerValue: controller.ctlPassword.value,
                            hintText: 'Password',
                            inputType: TextInputType.visiblePassword,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return "Cant be Empty.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Obx(() => controller.errorPasswordText.value.isEmpty
                            ? Container()
                            : ErrorText(
                                error: controller.errorPasswordText.value,
                                errorColor: primaryColor,
                              )),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => LoginTextField(
                            pref: const Icon(
                              CupertinoIcons.lock,
                              color: blackColor,
                            ),
                            obsText: controller.showHideConfPass.value,
                            suf: InkWell(
                                onTap: () {
                                  controller.changeShowhideConfPass();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    controller.showHideConfPass.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: whiteColor,
                                  ),
                                )),
                            controllerValue: controller.ctlConfPassword.value,
                            hintText: 'Confirm Password',
                            inputType: TextInputType.visiblePassword,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return "Cant be Empty.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: Obx(
                              () => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      backgroundColor: primaryColor),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          final isValid =
                                              _formKey.currentState!.validate();

                                          if (!isValid) {
                                            return;
                                          }
                                          _formKey.currentState!.save();
                                          controller.registerUser(
                                            context,
                                          );
                                        },
                                  child: controller.isLoading.value
                                      ? const CommonButtonLoader(
                                          indicatorColor: whiteColor,
                                        )
                                      : Text(
                                          "Sign Up",
                                          style: GoogleFonts.mukta(
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold),
                                        )),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ? ",
                              style: GoogleFonts.mukta(
                                fontSize: 14,
                                color: blackColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                "Sign In",
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
    );
  }

  Widget darkRoundedPinPut(SignUpController provider) {
    return Pinput(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter OTP.';
        } else {
          return null;
        }
      },

      errorTextStyle:
          GoogleFonts.mukta(color: whiteColor, fontWeight: FontWeight.bold),
      controller: provider.ctlOtp.value,

      // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
      // listenForMultipleSmsOnAndroid: true,
      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 20),

      onTap: () => FocusScope.of(context).unfocus(),
      // onClipboardFound: (value) {
      //   debugPrint('onClipboardFound: $value');
      //   pinController.setText(value);
      // },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
      },
      onChanged: (value) {
        debugPrint('onChanged: $value');
      },
      cursor: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 9),
            width: 22,
            height: 2,
            color: primaryColor,
          ),
        ],
      ),

      focusedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor),
        ),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: blackColor),
        ),
      ),
      errorPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryColor),
        ),
      ),
    );
  }
}
