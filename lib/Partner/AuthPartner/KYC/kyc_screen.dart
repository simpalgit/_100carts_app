import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:carts_app/Partner/AuthPartner/KYC/kyc_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/input_fields.dart';
import 'package:carts_app/Widgets/upload_images_helper.dart';
import 'package:carts_app/Widgets/watch_example_button.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final controller = Get.put(KycScreenController());
  bool colorChange = false;
  CroppedFile? aadharFront, aadharBack, vehicleFront, vehicleBack, panFront;
  @override
  void initState() {
    nb.setStatusBarColor(whiteColor);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<KycScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Personal Information",
            style: GoogleFonts.mukta(fontWeight: FontWeight.bold, fontSize: 22),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter the details below so we can get to know and serve you better.",
                style: GoogleFonts.mukta(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StepperTextField(
                isPartner: true,
                rOnly: true,
                controllerValue: controller.ctlFullName.value,
                inputType: TextInputType.name,
                validate: (val) {
                  if (val!.isEmpty) {
                    return "Full Name can't be empty.";
                  } else {
                    return null;
                  }
                },
                hintValue: "Full Name",
              ),
              const SizedBox(height: 15),
              StepperTextField(
                isPartner: true,
                rOnly: true,
                controllerValue: controller.ctlDob.value,
                inputType: TextInputType.text,
                validate: (val) {
                  if (val!.isEmpty) {
                    return "Date Of Birth can't be empty.";
                  } else {
                    return null;
                  }
                },
                onTap: () => controller.geDateOfBirth(context),
                hintValue: "Date Of Birth",
              ),
              const SizedBox(height: 15),
              StepperTextField(
                isPartner: true,
                rOnly: true,
                controllerValue: controller.ctlMobile.value,
                inputType: TextInputType.phone,
                mLength: 10,
                validate: (val) {
                  if (val!.isEmpty) {
                    return "Phone Number can't be empty.";
                  } else {
                    return null;
                  }
                },
                hintValue: "Primary Mobile Number.",
              ),
              const SizedBox(height: 15),
              StepperTextField(
                isPartner: true,
                rOnly: false,
                controllerValue: controller.ctlAltMobile.value,
                inputType: TextInputType.phone,
                mLength: 10,
                validate: (val) {
                  if (val!.isEmpty) {
                    return "Phone Number can't be empty.";
                  } else {
                    return null;
                  }
                },
                hintValue: "Alternate Mobile Number.",
              ),
              const SizedBox(height: 15),
              Obx(
                () => controller.stateLoading.value
                    ? const SizedBox()
                    : LoginTextField(
                        isPartner: true,
                        suf: const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: whiteColor,
                        ),
                        controllerValue: controller.ctlState.value,
                        rOnly: true,
                        hintText: 'State',
                        onTap: () {
                          CommonFunctions().stateCityAreaDialogue(
                              context: context,
                              title: "Select State",
                              controller: controller.ctlStateName.value,
                              onChange: (p0) => controller.searchState(p0),
                              listWidget: Obx(() => Expanded(
                                    child: NotificationListener<
                                            UserScrollNotification>(
                                        onNotification: (UserScrollNotification
                                            notification) {
                                          if (notification.direction !=
                                              ScrollDirection.idle) {
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }
                                          return false;
                                        },
                                        child: ListView.builder(
                                            itemCount: controller
                                                .filteredStateList.length,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              var data = controller
                                                  .filteredStateList[index];
                                              return InkWell(
                                                onTap: () =>
                                                    controller.onSelectState(
                                                  data,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: Text(
                                                      data.name.toString(),
                                                      style: GoogleFonts.mukta(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ),
                                              );
                                            })),
                                  )));
                        },
                        validate: (val) {
                          if (val!.isEmpty) {
                            return "Cant be Empty.";
                          } else {
                            return null;
                          }
                        },
                      ),
              ),
              Obx(
                () => controller.districtVisible.value
                    ? Column(
                        children: [
                          const SizedBox(height: 15),
                          LoginTextField(
                            isPartner: true,
                            suf: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: whiteColor,
                            ),
                            controllerValue: controller.ctlDistrict.value,
                            rOnly: true,
                            hintText: 'District',
                            onTap: () {
                              CommonFunctions().stateCityAreaDialogue(
                                  context: context,
                                  title: "Select District",
                                  controller: controller.ctlDistrictName.value,
                                  onChange: (p0) =>
                                      controller.searchDistrict(p0),
                                  listWidget: Obx(() => Expanded(
                                        child: NotificationListener<
                                                UserScrollNotification>(
                                            onNotification:
                                                (UserScrollNotification
                                                    notification) {
                                              if (notification.direction !=
                                                  ScrollDirection.idle) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              }
                                              return false;
                                            },
                                            child: ListView.builder(
                                                itemCount: controller
                                                    .filteredDistrictList
                                                    .length,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var data = controller
                                                          .filteredDistrictList[
                                                      index];
                                                  return InkWell(
                                                    onTap: () => controller
                                                        .onSelectDistrict(
                                                      data,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      child: Text(
                                                          data.name.toString(),
                                                          style:
                                                              GoogleFonts.mukta(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                    ),
                                                  );
                                                })),
                                      )));
                            },
                            validate: (val) {
                              if (val!.isEmpty) {
                                return "Cant be Empty.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
              Obx(
                () => controller.cityVisible.value
                    ? Column(
                        children: [
                          const SizedBox(height: 15),
                          LoginTextField(
                            isPartner: true,
                            suf: const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: whiteColor,
                            ),
                            controllerValue: controller.ctlCity.value,
                            rOnly: true,
                            hintText: 'City',
                            onTap: () {
                              CommonFunctions().stateCityAreaDialogue(
                                  context: context,
                                  title: "Select City",
                                  controller: controller.ctlCityName.value,
                                  onChange: (p0) => controller.searchCity(p0),
                                  listWidget: Obx(() => Expanded(
                                        child: NotificationListener<
                                                UserScrollNotification>(
                                            onNotification:
                                                (UserScrollNotification
                                                    notification) {
                                              if (notification.direction !=
                                                  ScrollDirection.idle) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              }
                                              return false;
                                            },
                                            child: ListView.builder(
                                                itemCount: controller
                                                    .filteredCityList.length,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var data = controller
                                                      .filteredCityList[index];
                                                  return InkWell(
                                                    onTap: () =>
                                                        controller.onSelectCity(
                                                      data,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      child: Text(
                                                          data.name.toString(),
                                                          style:
                                                              GoogleFonts.mukta(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                    ),
                                                  );
                                                })),
                                      )));
                            },
                            validate: (val) {
                              if (val!.isEmpty) {
                                return "Cant be Empty.";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Front side Aadhar Card\n(Required)",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mukta(
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            UploadImagesHelper(
                              uploadImage: () {
                                CommonFunctions().showPopUp(
                                    context: context,
                                    screenHeight: size.height,
                                    screenWidth: size.width,
                                    onCameraClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "camera")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            aadharFront = value;
                                          }
                                        });
                                      });
                                    },
                                    onGalleryClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "gallery")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            aadharFront = value;
                                          }
                                        });
                                      });
                                    });
                              },
                              removeImage: () {
                                aadharFront = null;
                                setState(() {});
                              },
                              passedfile: aadharFront,
                              imagePath: "",
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const WatchExampleButton(
                              image: Images.aadhaarCardFront,
                              title: "Example (Front View)",
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Back side Aadhar Card\n(Required)",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mukta(
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            UploadImagesHelper(
                              uploadImage: () {
                                CommonFunctions().showPopUp(
                                    context: context,
                                    screenHeight: size.height,
                                    screenWidth: size.width,
                                    onCameraClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "camera")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            aadharBack = value;
                                          }
                                        });
                                      });
                                    },
                                    onGalleryClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "gallery")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            aadharBack = value;
                                          }
                                        });
                                      });
                                    });
                              },
                              removeImage: () {
                                aadharBack = null;
                                setState(() {});
                              },
                              passedfile: aadharBack,
                              imagePath: "",
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const WatchExampleButton(
                              image: Images.aadhaarCardBack,
                              title: "Example (Back View)",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Vehicle Front side\n(Required)",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mukta(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            UploadImagesHelper(
                              uploadImage: () {
                                CommonFunctions().showPopUp(
                                    context: context,
                                    screenHeight: size.height,
                                    screenWidth: size.width,
                                    onCameraClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "camera")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            vehicleFront = value;
                                          }
                                        });
                                      });
                                    },
                                    onGalleryClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "gallery")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            vehicleFront = value;
                                          }
                                        });
                                      });
                                    });
                              },
                              removeImage: () {
                                vehicleFront = null;
                                setState(() {});
                              },
                              passedfile: vehicleFront,
                              imagePath: "",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const WatchExampleButton(
                              image: Images.vehicleFront,
                              title: "Example (Front View)",
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Vehicle Back side\n(Required)",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.mukta(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            UploadImagesHelper(
                              uploadImage: () {
                                CommonFunctions().showPopUp(
                                    context: context,
                                    screenHeight: size.height,
                                    screenWidth: size.width,
                                    onCameraClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "camera")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            vehicleBack = value;
                                          }
                                        });
                                      });
                                    },
                                    onGalleryClick: () async {
                                      Navigator.pop(context);
                                      setState(() {
                                        colorChange = true;
                                      });
                                      await CommonFunctions()
                                          .pickAndCropImage(from: "gallery")
                                          .then((value) {
                                        setState(() {
                                          colorChange = false;

                                          if (value != null) {
                                            vehicleBack = value;
                                          }
                                        });
                                      });
                                    });
                              },
                              removeImage: () {
                                vehicleBack = null;
                                setState(() {});
                              },
                              passedfile: vehicleBack,
                              imagePath: "",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const WatchExampleButton(
                              image: Images.vehicleBack,
                              title: "Example (Back View)",
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "Front side of Pan Card (Required)",
                        style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      UploadImagesHelper(
                        uploadImage: () {
                          CommonFunctions().showPopUp(
                              context: context,
                              screenHeight: size.height,
                              screenWidth: size.width,
                              onCameraClick: () async {
                                Navigator.pop(context);
                                setState(() {
                                  colorChange = true;
                                });
                                await CommonFunctions()
                                    .pickAndCropImage(from: "camera")
                                    .then((value) {
                                  setState(() {
                                    colorChange = false;

                                    if (value != null) {
                                      panFront = value;
                                    }
                                  });
                                });
                              },
                              onGalleryClick: () async {
                                Navigator.pop(context);
                                setState(() {
                                  colorChange = true;
                                });
                                await CommonFunctions()
                                    .pickAndCropImage(from: "gallery")
                                    .then((value) {
                                  setState(() {
                                    colorChange = false;

                                    if (value != null) {
                                      panFront = value;
                                    }
                                  });
                                });
                              });
                        },
                        removeImage: () {
                          panFront = null;
                          setState(() {});
                        },
                        passedfile: panFront,
                        imagePath: "",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryPartnerColor),
                        onPressed: () =>
                            Get.toNamed(RouteName.partnerHomeScreen),
                        child: Text("Submit",
                            style: GoogleFonts.mukta(
                              color: whiteColor,
                              fontWeight: FontWeight.w500,
                            )),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
