import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Widgets/error_found_widgets.dart';
import 'package:carts_app/Widgets/input_fields.dart';

import 'address_controller.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final controller = Get.put(AddressController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getSavedAddress("clear");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => CommonFunctions.hideKeyboard(context),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          elevation: 2,
          iconTheme: const IconThemeData(color: blackColor),
          backgroundColor: whiteColor,
          title: Text(
            'Add Address',
            style: GoogleFonts.mukta(
                color: blackColor, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          "My Saved Addresses",
                          style: GoogleFonts.mukta(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => controller.userAddressList.isEmpty
                            ? SizedBox(
                                width: double.infinity,
                                child: Center(
                                    child: Text(
                                  "No saved Addresses found ..",
                                  style: GoogleFonts.mukta(),
                                )))
                            : ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var data = controller.userAddressList[index];

                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: VisualDensity.compact,
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data.firstName} ${data.lastName}",
                                          style: GoogleFonts.mukta(
                                              color: blackColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${data.address}",
                                          style: GoogleFonts.mukta(
                                              color: blackColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () =>
                                          controller.deleteSavedAddress(
                                              context, data.id.toString()),
                                      child: const Icon(
                                        CupertinoIcons.delete,
                                        size: 18,
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 5,
                                  );
                                },
                                itemCount: controller.userAddressList.length),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Add New Address",
                  style: GoogleFonts.mukta(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              StepperTextField(
                                controllerValue: controller.ctlFirstName.value,
                                validate: (val) {
                                  if (val!.isEmpty) {
                                    return "Field Cant be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                hintValue: 'First Name',
                                inputType: TextInputType.text,
                              ),
                              Obx(
                                () => controller.errorNameText.value.isEmpty
                                    ? Container()
                                    : ErrorText(
                                        error: controller.errorNameText.value,
                                        errorColor: primaryColor,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              StepperTextField(
                                controllerValue: controller.ctlLastName.value,
                                validate: (val) {
                                  if (val!.isEmpty) {
                                    return "Field Cant be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                hintValue: 'Last Name',
                                inputType: TextInputType.text,
                              ),
                              Obx(
                                () => controller.errorLastNameText.value.isEmpty
                                    ? Container()
                                    : ErrorText(
                                        error:
                                            controller.errorLastNameText.value,
                                        errorColor: primaryColor,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    StepperTextField(
                      controllerValue: controller.ctlMobile.value,
                      validate: (val) {
                        if (val!.isEmpty) {
                          return "Field Cant be empty";
                        } else {
                          return null;
                        }
                      },
                      mLength: 10,
                      hintValue: 'Mobile',
                      inputType: TextInputType.phone,
                    ),
                    Obx(
                      () => controller.errorMobileText.value.isEmpty
                          ? Container()
                          : ErrorText(
                              error: controller.errorMobileText.value,
                              errorColor: primaryColor,
                            ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    StepperTextField(
                      controllerValue: controller.ctlEmail.value,
                      validate: (val) {
                        if (val!.isEmpty) {
                          return "Field Cant be empty";
                        } else {
                          return null;
                        }
                      },
                      hintValue: 'Email',
                      inputType: TextInputType.emailAddress,
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
                    StepperTextField(
                      controllerValue: controller.ctlAddress.value,
                      validate: (val) {
                        if (val!.isEmpty) {
                          return "Field Cant be empty";
                        } else {
                          return null;
                        }
                      },
                      hintValue: 'Address',
                      inputType: TextInputType.streetAddress,
                    ),
                    Obx(
                      () => controller.errorAddressText.value.isEmpty
                          ? Container()
                          : ErrorText(
                              error: controller.errorAddressText.value,
                              errorColor: primaryColor,
                            ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.55,
                          child: Column(
                            children: [
                              StepperTextField(
                                controllerValue: controller.ctlLocality.value,
                                validate: (val) {
                                  if (val!.isEmpty) {
                                    return "Field Cant be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                hintValue: 'Locality',
                                inputType: TextInputType.streetAddress,
                              ),
                              Obx(
                                () => controller.errorLocalityText.value.isEmpty
                                    ? Container()
                                    : ErrorText(
                                        error:
                                            controller.errorLocalityText.value,
                                        errorColor: primaryColor,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              StepperTextField(
                                controllerValue: controller.ctlPostCode.value,
                                mLength: 6,
                                validate: (val) {
                                  if (val!.isEmpty) {
                                    return "Field Cant be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                hintValue: 'Post Code',
                                inputType: TextInputType.number,
                              ),
                              Obx(
                                () => controller.errorPostCodeText.value.isEmpty
                                    ? Container()
                                    : ErrorText(
                                        error:
                                            controller.errorPostCodeText.value,
                                        errorColor: primaryColor,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: darkBlueColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)))),
                      onPressed: controller.isaveAddressLoad.value
                          ? null
                          : () {
                              final isValid = _formKey.currentState!.validate();

                              if (!isValid) {
                                return;
                              }
                              CommonFunctions.hideKeyboard(context);
                              controller.saveAddress();
                            },
                      child: controller.isaveAddressLoad.value
                          ? const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),
                            )
                          : Text(
                              "Save Address",
                              style: GoogleFonts.mukta(color: whiteColor),
                            ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       controller.isaveAddressLoad(false);
                //     },
                //     child: const Text("")),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class AddressTypeWidget extends StatelessWidget {
  final String passedText;
  final VoidCallback onTapped;
  final IconData passedIcon;
  final Color containerColor, textColor, borderColor;

  const AddressTypeWidget(
      {super.key,
      required this.onTapped,
      required this.passedText,
      required this.passedIcon,
      required this.containerColor,
      required this.textColor,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              color: containerColor,
              borderRadius: BorderRadius.circular(25)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                passedIcon,
                color: textColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                passedText,
                style: GoogleFonts.mukta(
                    fontWeight: FontWeight.bold, color: textColor),
              )
            ],
          )),
    );
  }
}
