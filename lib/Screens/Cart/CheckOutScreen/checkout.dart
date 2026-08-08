import 'dart:convert' show base64Encode, jsonEncode, utf8;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carts_app/Models/plan_modal.dart';
import 'package:carts_app/Screens/Cart/CheckOutScreen/create_json.dart';
import 'package:carts_app/Screens/Cart/CheckOutScreen/settings_repository.dart';
import 'package:carts_app/Screens/Cart/Components/cart_product.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Screens/ProductDetail/Components/detail_appbar.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';
import 'package:carts_app/Widgets/input_fields.dart';
import 'package:carts_app/Widgets/page_loader.dart';
import 'check_out_provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final payment_type = Get.arguments['payment_type'];
  final checkOutController = Get.put(CheckOutController());
  CartController cartController = Get.find();

  final _razorpay = Razorpay();
  bool enableLogs = true;
  // String marchentId = "PGTESTPAYUAT86"; //dummy
  String marchentId = "M22JSQVIDU85E"; //live
  String salt = "c5c73abf-274e-4353-969f-e882221927c7"; //live
  // String salt = "96434309-7796-489d-8924-ab56988a6076"; //dummy
  int saltIndex = 1;
  String callbackURL = "https://varietymegastore.com/";
  String apiEndPoint = "/pg/v1/pay";

  SettingsRepository settingsRepository = SettingsRepository();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkOutController.getSavedAddress();
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  init() async {
    final response =
        await checkOutController.createPayOrderAndroid(payment_type);
    print("Response: $response");

    final orderId = response['orderId'];
    final transId =
        response['orderData']['paymentData']['merchantTransactionId'];

    // PhonePePaymentSdk.init("PRODUCTION", null, marchentId, true).then((val) {
    //   print('PhonePe SDK Initialized - $val');
    //   startTransaction(transId, orderId);
    // }).catchError((error) {
    //   print('PhonePe SDK error - $error');
    //   return <dynamic>{};
    // });
  }

  void _showOrderDetailsDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Thank you for your order! Your order is now confirmed. You can expect to receive your items within 48 hours. Check the full order details and tracking information in your login panel.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(RouteName.mainHomeScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.white), // Hardcoded white text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cod_order() async {
    print("cod_order");
    try {
      final response =
          await checkOutController.createPayOrderAndroid(payment_type);
      print("responsecheckOutController${response}");
      if (response['response'] == true) {
        _showOrderDetailsDialog();
      }
    } catch (error) {
      CommonFunctions.showErrorSnackbar(error.toString());
    }
  }

  startTransaction(dynamic transId, dynamic orderId) {
    String mt_id =
        '${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}' +
            '${DateTime.now().hour.toString().padLeft(2, '0')}${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().second.toString().padLeft(2, '0')}' +
            '${DateTime.now().millisecond.toString().padLeft(3, '0')}';
    Map body = {
      "merchantId": marchentId,
      "merchantTransactionId": transId,
      "merchantUserId": "asas", // login
      "amount": cartController.getGrandTotal().toInt() * 100, // paisa
      "callbackUrl": callbackURL,
      "mobileNumber": checkOutController.ctlMobile.value.text, // login
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    // base64
    String bodyEncoded = base64Encode(utf8.encode(jsonEncode(body)));
    var byteCodes = utf8.encode(bodyEncoded + apiEndPoint + salt);
    // sha256
    String checksum = "${sha256.convert(byteCodes)}###$saltIndex";
    // PhonePePaymentSdk.startTransaction(bodyEncoded, callbackURL, checksum, "")
    //     .then((success) {
    //   print("Payment success $success");
    //   if (success?['status'] == "SUCCESS") {
    //     checkOutController.updateUserOrder(
    //         "", orderId.toString(), orderId.toString());
    //     //
    //   } else {
    //     CommonFunctions.showErrorSnackbar(success?['error']);
    //   }
    // }).catchError((error) {
    //   CommonFunctions.showErrorSnackbar(error.toString());
    // });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await EasyLoading.show(
      status: 'Getting Payment Response',
      maskType: EasyLoadingMaskType.black,
    );

    checkOutController.updateUserOrder(
        response.paymentId!,
        checkOutController.createPayOrderModel.value!.orderId!,
        checkOutController.createPayOrderModel.value!.id!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CommonFunctions.showErrorSnackbar("Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet responses, if necessary
  }

  void openCheckout() async {
    var options = {
      'key': checkOutController.createPayOrderModel.value!.key,
      "amount": checkOutController.createPayOrderModel.value!.amount,
      'name': checkOutController.createPayOrderModel.value!.name,
      'order_id': checkOutController.createPayOrderModel.value!.orderId,
      'currency': checkOutController.createPayOrderModel.value!.currency,
      'description': 'Variety Mega Store',
      'timeout': 300,
      'prefill':
          checkOutController.createPayOrderModel.value!.prefill!.toJson(),
      "theme": checkOutController.createPayOrderModel.value!.theme!.toJson()
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => CommonFunctions.hideKeyboard(context),
      child: Scaffold(
          body: SafeArea(
        child: Column(
          children: [
            const DetailsAppBar(
              title: "Check Out",
            ),
            Obx(
              () => checkOutController.isLoading.value
                  ? const Center(child: PageLoaderScreen())
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 12.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order Summary :",
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Check your items. And select a suitable shipping method.",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: borderColor)),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return CartListProduct(
                                          viewDetail: false,
                                          product:
                                              cartController.cartList[index],
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return const Divider(
                                          color: black,
                                        );
                                      },
                                      itemCount:
                                          cartController.cartList.length),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Shipping Address :",
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Complete your order by providing your shipping address details.",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.jost(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Add New Address",
                                      style: GoogleFonts.mukta(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: StepperTextField(
                                            controllerValue: checkOutController
                                                .ctlFirstName.value,
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
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: StepperTextField(
                                            controllerValue: checkOutController
                                                .ctlLastName.value,
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
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    StepperTextField(
                                      controllerValue:
                                          checkOutController.ctlMobile.value,
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    StepperTextField(
                                      controllerValue:
                                          checkOutController.ctlEmail.value,
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    StepperTextField(
                                      controllerValue:
                                          checkOutController.ctlAddress.value,
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.55,
                                          child: StepperTextField(
                                            controllerValue: checkOutController
                                                .ctlLocality.value,
                                            validate: (val) {
                                              if (val!.isEmpty) {
                                                return "Field Cant be empty";
                                              } else {
                                                return null;
                                              }
                                            },
                                            hintValue: 'Locality',
                                            inputType:
                                                TextInputType.streetAddress,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: StepperTextField(
                                            controllerValue: checkOutController
                                                .ctlPostCode.value,
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
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    CheckboxListTile(
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: checkOutController.isSaved.value,
                                      onChanged: (value) => checkOutController
                                          .changeSaved(value!),
                                      title: Text(
                                        "Save Address",
                                        style: GoogleFonts.jost(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                checkOutController.userAddressList.isEmpty
                                    ? const SizedBox()
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: borderColor)),
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              var data = checkOutController
                                                  .userAddressList[index];

                                              return CheckboxListTile(
                                                contentPadding: EdgeInsets.zero,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                checkColor: Colors.white,
                                                checkboxShape:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                activeColor: primaryColor,
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${data.firstName} ${data.lastName}",
                                                        style:
                                                            GoogleFonts.mukta(
                                                                color: black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            data.mobile
                                                                .toString(),
                                                            style: GoogleFonts.mukta(
                                                                color: black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          Text(
                                                            data.email ?? "",
                                                            style: GoogleFonts.mukta(
                                                                color: black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        "${data.address}",
                                                        style:
                                                            GoogleFonts.mukta(
                                                                color: black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                value: data.selected,
                                                onChanged: (bool? value) {
                                                  checkOutController
                                                      .changeAddressSelection(
                                                          value!, data);
                                                },
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return const SizedBox(
                                                height: 5,
                                              );
                                            },
                                            itemCount: checkOutController
                                                .userAddressList.length),
                                      ),
                                checkOutController.userAddressList.isEmpty
                                    ? const SizedBox()
                                    : const SizedBox(
                                        height: 15,
                                      ),
                                checkOutController.isLoading.value
                                    ? Container()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "Bill Details : ",
                                            style: GoogleFonts.mukta(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CartWidget(
                                              head: 'Subtotal',
                                              detail:
                                                  '\u{20B9} ${cartController.getCartTotal()}',
                                              size: size),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          // CartWidget(
                                          //     head: 'Tax',
                                          //     detail:
                                          //         '\u{20B9} ${cartController.getCartTaxTotal()}',
                                          //     size: size),
                                          // const SizedBox(
                                          //   height: 5,
                                          // ),
                                          CartWidget(
                                              head: 'Shipping',
                                              detail: '\u{20B9} 0.0',
                                              size: size),
                                          const Divider(
                                            color: darkBlueColor,
                                            thickness: 1.5,
                                          ),
                                          CartWidget(
                                              head: 'Total (INR)',
                                              detail:
                                                  '\u{20B9} ${cartController.getGrandTotal()}',
                                              size: size),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                  backgroundColor:
                                                      darkBlueColor,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(12),
                                                              bottomRight: Radius
                                                                  .circular(
                                                                      12)))),
                                              onPressed: checkOutController
                                                      .btnIsLoading.value
                                                  ? null
                                                  : () {
                                                      final isValid = _formKey
                                                          .currentState!
                                                          .validate();

                                                      if (!isValid) {
                                                        return;
                                                      }
                                                      if (payment_type ==
                                                          'COD') {
                                                        cod_order();
                                                      } else {
                                                        init();
                                                      }
                                                    },
                                              // onPressed: () {
                                              //   init();
                                              // },
                                              child: checkOutController
                                                      .btnIsLoading.value
                                                  ? const CommonButtonLoader(
                                                      indicatorColor: white)
                                                  : Text(
                                                      "Pay & Submit",
                                                      style: GoogleFonts.mukta(
                                                          color: white),
                                                    ),
                                            ),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            )
            // checkOutController.isLoading
            //     ? Container()
            //     : CartBottomComponent(
            //         buttonName: "Pay & Submit",
            //         onTap: checkOutController.isLoading
            //             ? null
            //             : () {
            //                 checkOutController.btnLoadingFun(false);
            //               },
            //       )
          ],
        ),
      )),
    );
  }
}

class CartWidget extends StatelessWidget {
  final String head, detail;
  final Size size;
  const CartWidget(
      {super.key,
      required this.head,
      required this.detail,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          head,
          style: GoogleFonts.mukta(fontWeight: FontWeight.w500),
        ),
        Text(
          detail,
          style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

showPopUp({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  // required VoidCallback onRazorPayClick,
  required VoidCallback onPhonePayClick,
}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Select Payment method",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ColumnAssetsImageTextHelper(
                  //   imagePath: 'assets/images/razorpay.jpeg',
                  //   title: 'RazorPay',
                  //   onCLicked: onRazorPayClick,
                  //   sHeight: screenHeight,
                  // ),
                  // const SizedBox(
                  //   width: 25,
                  // ),
                  ColumnAssetsImageTextHelper(
                    imagePath: 'assets/images/no_image_error.jpg',
                    title: 'PhonePay',
                    onCLicked: onPhonePayClick,
                    sHeight: screenHeight,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      });
}
