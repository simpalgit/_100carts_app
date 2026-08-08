import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:carts_app/Utils/local_shared_preferences.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';
import 'package:carts_app/Widgets/error_found_widgets.dart';
import 'package:carts_app/Widgets/input_fields.dart';

import 'sign_in_partner_controller.dart';

class SignInPartner extends StatefulWidget {
  const SignInPartner({super.key});

  @override
  State<SignInPartner> createState() => _SignInPartnerState();
}

class _SignInPartnerState extends State<SignInPartner> {
  final controller = Get.put(SignInPartnerConrtroller());
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    nb.setStatusBarColor(lightPartnerColor);
    super.initState();
  }

  @override
  void dispose() {
    nb.setStatusBarColor(whiteColor);
    Get.delete<SignInPartnerConrtroller>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFD1C3FF),
                      border: Border(
                          bottom: BorderSide(
                              color: primaryPartnerColor, width: 10)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(80, 30),
                          bottomRight: Radius.elliptical(355, 250))),
                  width: double.infinity,
                  height: size.height * 0.6,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image.asset(
                        Images.deliveryImage,
                        height: size.height * 0.5,
                      ),
                      Positioned(
                          top: 15,
                          left: 20,
                          child: SafeArea(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "100CARTS",
                                style: GoogleFonts.mukta(
                                    color: primaryPartnerColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28),
                              ),
                              Text(
                                "Partner",
                                style: GoogleFonts.mukta(
                                    color: primaryPartnerColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21),
                              ),
                            ],
                          )))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Enter Mobile Number :",
                            style:
                                GoogleFonts.mukta(fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      LoginTextField(
                        isPartner: true,
                        onChange: (value) =>
                            controller.checkNumberLength(value.length),
                        pref: const Icon(
                          CupertinoIcons.phone,
                          color: primaryPartnerColor,
                        ),
                        controllerValue: controller.ctlMobile.value,
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
                        () => controller.errorMobileText.value.isEmpty
                            ? Container()
                            : ErrorText(
                                error: controller.errorMobileText.value,
                                errorColor: Colors.red,
                              ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Obx(
                        () => LoginTextField(
                          isPartner: true,
                          pref: const Icon(
                            CupertinoIcons.lock,
                            color: primaryPartnerColor,
                          ),
                          obsText: controller.showHidePass.value,
                          suf: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                  onTap: () => controller.changeShowhidePass(),
                                  child: Icon(
                                    controller.showHidePass.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryPartnerColor,
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          controllerValue: controller.ctlPassword.value,
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
                        () => controller.errorPasswordText.value.isEmpty
                            ? Container()
                            : ErrorText(
                                error: controller.errorPasswordText.value,
                                errorColor: Colors.red,
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          //   onTap: () => Get.toNamed(RouteName.forgotPasswordScreen),
                          child: Text(
                            "Forgot your password ?",
                            style: GoogleFonts.mukta(
                                color: blackColor, fontWeight: FontWeight.bold),
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
                                  backgroundColor: primaryPartnerColor),
                              onPressed: controller.btnEnable.value
                                  ? controller.isLoggingIn.value
                                      ? null
                                      : () {
                                          final isValid =
                                              _formKey.currentState!.validate();

                                          if (!isValid) {
                                            return;
                                          }
                                          LocalPreferences()
                                              .setPartnerLoginBool(true);
                                          Get.toNamed(RouteName.kycScreen);
                                          // _formKey.currentState!.save();
                                          // loginController.login(context, from);
                                        }
                                  : null,
                              child: controller.isLoggingIn.value
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
                            onTap: () => Get.toNamed(RouteName.signUpPartner),
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.mukta(
                                  fontSize: 13,
                                  color: primaryPartnerColor,
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
    );
  }
}
