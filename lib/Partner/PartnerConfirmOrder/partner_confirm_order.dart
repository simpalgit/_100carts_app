import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/map_utils.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/detail_widget_helper.dart';
import 'package:carts_app/Widgets/mrp_widget.dart';

import 'partner_confim_order.dart';

class PartnerConfirmOrder extends StatefulWidget {
  const PartnerConfirmOrder({super.key});

  @override
  State<PartnerConfirmOrder> createState() => _PartnerConfirmOrderState();
}

class _PartnerConfirmOrderState extends State<PartnerConfirmOrder> {
  final controller = Get.put(PartnerConfimOrder());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            // Define your onPressed action here
          },
        ),
        title: Text(
          'Order Summary',
          style: GoogleFonts.mukta(color: Colors.black),
        ),

        elevation: 0, // Remove shadow if needed
      ),
      body: SafeArea(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: blackColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                      onPressed: () => MapUtils.openMap(19.4564, 72.7925),
                      child: Text(
                        "View Route",
                        style: GoogleFonts.mukta(color: whiteColor),
                      )),
                ),
                DetailWidgetHelper(
                  heading: "Order No",
                  value: checkNullOperatorFun(controller.order.value!.orderId),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.person_alt_circle,
                      color: blackColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        controller.order.value!.customer == null
                            ? ""
                            : checkNullOperatorFun(
                                controller.order.value!.customer!.name),
                        style: GoogleFonts.mukta(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: blackColor),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      CupertinoIcons.phone_circle_fill,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.location_solid,
                      color: blackColor,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        controller.order.value!.customer == null
                            ? ""
                            : checkNullOperatorFun(controller
                                .order.value!.customer!.address!.fullAddress),
                        style:
                            GoogleFonts.mukta(fontSize: 13, color: blackColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImage(
                                image: "https://picsum.photos/200",
                                imgHeight: size.height * 0.08,
                                imgWidth: size.height * 0.08),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "product name",
                                    style: GoogleFonts.mukta(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: MrpWidget(
                                          cost: 240,
                                          offerCost: 150,
                                          offerSize: 14,
                                          costSize: 13,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Quantity : ",
                                            style: GoogleFonts.mukta(
                                                fontWeight: FontWeight.bold,
                                                color: primaryColor),
                                          ),
                                          Text(
                                            "2",
                                            style: GoogleFonts.mukta(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total : \u{20B9} 240",
                                        style: GoogleFonts.mukta(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: 2),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPartnerColor),
                      onPressed: () {
                        Get.bottomSheet(
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Enter Otp from Customer",
                                    style: GoogleFonts.mukta(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      darkRoundedPinPut(),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                            Get.toNamed(
                                                RouteName.itemDelivered);
                                          },
                                          child: Text(
                                            "Confirm Otp",
                                            style: GoogleFonts.mukta(
                                                color: whiteColor),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12))));
                      },
                      child: Text(
                        "Item Delivred.",
                        style: GoogleFonts.mukta(color: whiteColor),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
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
      controller: controller.otpController.value,

      defaultPinTheme: defaultPinTheme,
      separatorBuilder: (index) => const SizedBox(width: 20),
      // validator: (value) {},
      onTap: () => FocusScope.of(context).unfocus(),
      // onClipboardFound: (value) {
      //   debugPrint('onClipboardFound: $value');
      //   pinController.setText(value);
      // },
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      onCompleted: (pin) {
        debugPrint('onCompleted: $pin');
        // provider.loginUser(otp: "12345", context: context);
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
            height: 1,
            // color: focusedBorderColor,
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
          border: Border.all(color: Colors.redAccent),
        ),
      ),
    );
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: GoogleFonts.mukta(
      fontSize: 20,
      color: primaryColor,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: blackColor, width: 1),
    ),
  );
}
