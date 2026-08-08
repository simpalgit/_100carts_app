import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:pinput/pinput.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';

import 'forgot_password_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _forgotformKey = GlobalKey();

  bool passwordVisible = false, confirmpasswordVisible = false;
  bool showOTPField = false, showNewpasswordFields = false;

  final controller = Get.put(ForgotPasswordController());

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

  void _resetTimer() {
    setState(() {
      _timer!.cancel();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    nb.setStatusBarColor(primaryColor.withOpacity(0.05));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                child: Form(
                  key: _forgotformKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      // SizedBox(
                      //     height: size.height * 0.2,
                      //     child: Lottie.asset('assets/gif/forgot_pass.json')),
                      const Center(
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: primaryColor),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          'Enter your registered mobile number and we shall send you a OTP. Verify it and reset your password.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: blackColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 12)),
                      Obx(() => TextFormField(
                            style: const TextStyle(fontSize: 15),
                            controller: controller.textMobileController.value,
                            key: const ValueKey('mobile'),
                            maxLength: 10,
                            onChanged: (value) {
                              if (value.length > 9) {
                                controller
                                    .showOtpFieldFun(context, true)
                                    .then((value) {
                                  if (controller.showOTPField.value) {
                                    Future.delayed(const Duration(seconds: 1),
                                        () {
                                      setState(() {
                                        _timerSeconds = 30;
                                        _buttonEnabled = false;
                                      });
                                      _startTimer();
                                    });
                                  }
                                });
                              } else {
                                controller
                                    .showOtpFieldFun(context, false)
                                    .then((value) => _resetTimer);
                              }
                            },
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = RegExp(patttern);
                              if (value!.isEmpty ||
                                  value.length < 10 ||
                                  value.length > 10) {
                                return 'Please enter mobile number';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Please enter valid mobile number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              suffix: controller.otpLoading.value
                                  ? Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      height: 15,
                                      width: 15,
                                      child: const CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    )
                                  : const SizedBox(),
                              counterText: "",
                              hintStyle: const TextStyle(fontSize: 15),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.blueGrey,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                    width: 2,
                                    color: Colors.blueGrey,
                                  )),
                              labelText: 'Mobile Number',
                              hintText: 'Enter Mobile Number',
                            ),
                          )),
                      Obx(() => controller.showOTPField.value
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  "Enter OTP",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                darkRoundedPinPut(),
                                TextButton(
                                    onPressed: _buttonEnabled
                                        ? () {
                                            controller
                                                .getOtp(context)
                                                .then((value) {
                                              Future.delayed(
                                                  const Duration(seconds: 1),
                                                  () {
                                                setState(() {
                                                  _timerSeconds = 30;
                                                  _buttonEnabled = false;
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  style: const TextStyle(fontSize: 15),
                                  controller: controller.ctlPassword.value,
                                  obscureText: !passwordVisible,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  enableSuggestions: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter password.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(fontSize: 15),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.blueGrey,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.blueGrey,
                                        )),
                                    labelText: 'New Password',
                                    hintText: 'Enter New Password.',
                                    suffixIcon: IconButton(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      icon: Icon(
                                        !passwordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      color: primaryColor,
                                      iconSize: 18.0,
                                      onPressed: () => setState(
                                        () =>
                                            passwordVisible = !passwordVisible,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 12)),
                                TextFormField(
                                  style: const TextStyle(fontSize: 15),
                                  controller: controller.ctlConfPassword.value,
                                  obscureText: !confirmpasswordVisible,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.none,
                                  enableSuggestions: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter confirm password.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(fontSize: 15),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.blueGrey,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.blueGrey,
                                        )),
                                    labelText: 'Confirm Password',
                                    hintText: 'Enter Confirm Password.',
                                    suffixIcon: IconButton(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      icon: Icon(
                                        !confirmpasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      color: primaryColor,
                                      iconSize: 18,
                                      onPressed: () => setState(
                                        () => confirmpasswordVisible =
                                            !confirmpasswordVisible,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 12)),
                                Center(
                                  child: SizedBox(
                                    width: 300,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          shape: const StadiumBorder()),
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () {
                                              final isValid = _forgotformKey
                                                  .currentState!
                                                  .validate();

                                              if (!isValid) {
                                                return;
                                              }

                                              controller
                                                  .forgotPassword(context);
                                            },
                                      child: controller.isLoading.value
                                          ? const CommonButtonLoader(
                                              indicatorColor: whiteColor)
                                          : Text(
                                              'Submit',
                                              style: GoogleFonts.mukta(
                                                  color: whiteColor),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container()),
                      const Padding(padding: EdgeInsets.only(top: 6)),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Back to login',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget darkRoundedPinPut() {
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
      controller: controller.textOTPController.value,

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
