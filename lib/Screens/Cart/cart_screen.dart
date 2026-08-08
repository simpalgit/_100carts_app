import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/detail_widget_helper.dart';
import 'package:carts_app/Widgets/price_converter.dart';

import 'Components/cart_appbar.dart';
import 'Components/cart_list.dart';
import 'cart_controller.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.getCartList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const CartListAppBar(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CartListComponent(),
                    const Divider(
                      thickness: 1,
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextButton.icon(
                        onPressed: () {
                          Get.offNamedUntil(
                              RouteName.mainHomeScreen,
                              (route) =>
                                  Get.currentRoute == RouteName.mainHomeScreen,
                              arguments: {"initPage": 1});
                        },
                        icon: const Icon(Icons.add_circle_outline_sharp,
                            color: blackColor),
                        label: Obx(() => Text(
                            controller.cartList.isNotEmpty
                                ? 'Add More Items'
                                : 'Add Items',
                            style: GoogleFonts.mukta(
                                color: blackColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => controller.cartList.isNotEmpty
                ? pricingView2()
                : const SizedBox())
          ],
        ),
      ),
    );
  }

  Widget pricingView2() {
    return Stack(children: [
      Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              //image: const DecorationImage(image: AssetImage(Images.zippitDeliveryBannerBg)),
              gradient: LinearGradient(colors: [
                primaryColor.withOpacity(0.6),
                primaryColor.withOpacity(1),
              ]),
              // borderRadius: BorderRadius.circular(ResponsiveHelper.isDesktop(context)
              //     ?12
              //     :12),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4), topRight: Radius.circular(4))),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal',
                            style: GoogleFonts.mukta(
                                color: Theme.of(context).canvasColor,
                                fontWeight: FontWeight.w600)),
                        PriceConverter.convertAnimationPrice(
                          controller.getCartTotal(),
                          textStyle: GoogleFonts.mukta(
                              color: Theme.of(context).canvasColor,
                              fontWeight: FontWeight.w600),
                        )
                      ]),
                  // const SizedBox(height: 20),
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text('Tax',
                  //           style: GoogleFonts.mukta(
                  //               color: Theme.of(context).canvasColor,
                  //               fontWeight: FontWeight.w600)),
                  //       // storeController.store != null ?
                  //       Row(children: [
                  //         Text('(+)   ',
                  //             style: GoogleFonts.mukta(
                  //                 color: Theme.of(context).canvasColor,
                  //                 fontWeight: FontWeight.w600)),
                  //         PriceConverter.convertAnimationPrice(
                  //             controller.getCartTaxTotal(),
                  //             textStyle: GoogleFonts.mukta(
                  //                 color: Theme.of(context).canvasColor,
                  //                 fontWeight: FontWeight.w600)),
                  //       ]),
                  //       // : Text('calculating',
                  //       //     style: robotoRegular.copyWith()),
                  //     ]),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping',
                            style: GoogleFonts.mukta(
                                color: Theme.of(context).canvasColor,
                                fontWeight: FontWeight.w600)),
                        // storeController.store != null ?
                        Row(children: [
                          Text('(+)   ',
                              style: GoogleFonts.mukta(
                                  color: Theme.of(context).canvasColor,
                                  fontWeight: FontWeight.w600)),
                          PriceConverter.convertAnimationPrice(0.0,
                              textStyle: GoogleFonts.mukta(
                                  color: Theme.of(context).canvasColor,
                                  fontWeight: FontWeight.w600)),
                        ]),
                        // : Text('calculating',
                        //     style: robotoRegular.copyWith()),
                      ]),
                  const SizedBox(height: 20),
                ]),
                Divider(color: Theme.of(context).canvasColor, thickness: 2),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Grand Total',
                          style: GoogleFonts.mukta(
                              color: Theme.of(context).canvasColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      PriceConverter.convertAnimationPrice(
                          controller.getGrandTotal(),
                          textStyle: GoogleFonts.mukta(
                              color: Theme.of(context).canvasColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ]),
                const SizedBox(height: 10),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: borderColor),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Payment Mode",
                          style: GoogleFonts.poppins(
                              color: primaryColor, fontWeight: FontWeight.w500),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        ListTile(
                          leading: Radio<String>(
                            value: 'COD',
                            groupValue: controller.selectedGender,
                            onChanged: (value) {
                              setState(() {
                                controller.selectedGender = value;
                              });
                            },
                          ),
                          title: Text(
                            'Cash on delivery',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Radio<String>(
                            value: 'PhonePe',
                            groupValue: controller.selectedGender,
                            onChanged: (value) {
                              setState(() {
                                controller.selectedGender = value;
                              });
                            },
                          ),
                          title: Text(
                            'Online payment',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: (controller.selectedGender == null ||
                              controller.selectedGender!.trim().isEmpty)
                          ? whiteColor.withOpacity(
                              0.5) // Lighter background when disabled
                          : whiteColor,
                    ),
                    onPressed: (controller.selectedGender == null ||
                            controller.selectedGender!.trim().isEmpty)
                        ? null // Disable the button
                        : () => Get.toNamed(
                              RouteName.checkOutScreen,
                              arguments: {
                                'payment_type': controller.selectedGender
                              },
                            ),
                    child: Text(
                      'Checkout',
                      style: GoogleFonts.mukta(
                        color: (controller.selectedGender == null ||
                                controller.selectedGender!.trim().isEmpty)
                            ? Colors.grey // Grey text when disabled
                            : primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                // SafeArea(
                //   child: CustomButton(
                //       color: Theme.of(context).canvasColor,
                //       buttonText: 'Place My Order'.tr,
                //       textColor: Theme.of(context).primaryColor,
                //       fontSize: ResponsiveHelper.isDesktop(context)
                //           ? Dimensions.fontSizeSmall
                //           : Dimensions.fontSizeLarge,
                //       isBold:
                //           ResponsiveHelper.isDesktop(context) ? false : true,
                //       radius: ResponsiveHelper.isDesktop(context)
                //           ? Dimensions.radiusSmall
                //           : Dimensions.radiusDefault,
                //       onPressed: () {
                //         if (!cartController
                //                 .cartList.first.item!.scheduleOrder! &&
                //             cartController.availableList.contains(false)) {
                //           showCustomSnackBar(
                //               'one_or_more_product_unavailable'.tr);
                //         } else {
                //           if (Get.find<SplashController>().module == null) {
                //             int i = 0;
                //             for (i = 0;
                //                 i <
                //                     Get.find<SplashController>()
                //                         .moduleList!
                //                         .length;
                //                 i++) {
                //               if (cartController.cartList[0].item!.moduleId ==
                //                   Get.find<SplashController>()
                //                       .moduleList![i]
                //                       .id) {
                //                 break;
                //               }
                //             }
                //             Get.find<SplashController>().setModule(
                //                 Get.find<SplashController>().moduleList![i]);
                //             HomeScreen.loadData(true);
                //           }
                //           Get.find<CouponController>().removeCouponData(false);

                //           Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                //         }
                //       }),
                // ),
              ])),
      // Padding(
      //   padding:
      //       EdgeInsets.only(left: MediaQuery.of(context).size.width / 2 - 50),
      //   child: SizedBox(
      //       height: 100,
      //       width: 100,
      //       child: Image.asset(Images.zippitDeliveryBannerBg,
      //           color: Colors.white.withOpacity(0.5))),
      // ),
    ]);
  }
}
