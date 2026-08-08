import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/common_appbar.dart';
import 'package:carts_app/Widgets/input_fields.dart';

import 'user_profile_controller.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _PartnerProfileScreenState();
}

class _PartnerProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final controller = Get.put(UserProfileController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: commonAppBar(context: context, heading: "Profile"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png',
                  height: 100,
                  width: 130,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      StepperTextField(
                        rOnly: true,
                        pre: const Icon(
                          CupertinoIcons.person,
                          color: blackColor,
                        ),
                        controllerValue: controller.ctlName.value,
                        inputType: TextInputType.text,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Username can't be empty.";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                        hintValue: "Username",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      StepperTextField(
                        mLength: 10,
                        pre: const Icon(
                          CupertinoIcons.phone,
                          color: primaryColor,
                        ),
                        rOnly: true,
                        controllerValue: controller.ctlMobile.value,
                        inputType: TextInputType.phone,
                        validate: (val) {
                          return null;
                        },
                        onTap: () {},
                        hintValue: "Mobile",
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      StepperTextField(
                        pre: const Icon(
                          CupertinoIcons.mail,
                          color: primaryColor,
                        ),
                        rOnly: true,
                        controllerValue: controller.ctlEmail.value,
                        inputType: TextInputType.emailAddress,
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Email can't be empty.";
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                        hintValue: "Email",
                      ),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      // ElevatedButton(
                      //     style: ElevatedButton// .styleFrom(
                      //         backgroundColor: primaryColor),
                      //     onPressed: () {
                      //       var isValid = _formKey.currentState!.validate();

                      //       if (!isValid) {
                      //         return;
                      //       }

                      //       _formKey.currentState!.save();
                      //     },
                      //     child: Text(
                      //       'Update',
                      //       style: GoogleFonts.mukta(color: whiteColor),
                      //     ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
