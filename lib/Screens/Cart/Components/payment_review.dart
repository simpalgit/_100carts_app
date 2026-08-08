import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:carts_app/Models/payment_gateway_model.dart';
import 'package:carts_app/Models/user_profile_model.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/page_loader.dart';

class PaymentGatwayResponse extends StatefulWidget {
  const PaymentGatwayResponse({
    super.key,
  });

  @override
  State<PaymentGatwayResponse> createState() => _PaymentGatwayResponseState();
}

class _PaymentGatwayResponseState extends State<PaymentGatwayResponse> {
  bool isLoading = true;

  double amount = 0.0;
  String payId = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      payId = data['payId'] as String;
      getTransactionDetails();
    });

    super.initState();
  }

  // getSaveData() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  // var paymentInstrument = json.decode(response// .data!.paymentInstrument!);

  // setState(() {
  //   amount = (response// .data!.amount! / 100).toString();
  //   if (paymentInstrument != null) {
  //     type = paymentInstrument["type"];
  //     if (type == "UPI") {
  //       transId = paymentInstrument["utr"];
  //     } else {
  //       if (type == "CARD") {
  //         isCard = true;
  //         cardType = paymentInstrument["cardType"];
  //       } else {
  //         isCard = false;
  //       }
  //       transId = paymentInstrument["pgTransactionId"];
  //     }
  //   }
  // });

  //   if (response.code == "PAYMENT_SUCCESS") {
  //     setState(() {
  //       successStatus = true;
  //     });
  //   } else {
  //     setState(() {
  //       successStatus = false;
  //     });
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  UserProfileModel userProfileModel = UserProfileModel();
  PaymentResponse paymentResponse = PaymentResponse();

  void getTransactionDetails() async {
    setState(() {
      isLoading = true;
    });
    String username = 'rzp_test_5UttsUIVH64i9v';
    String password = "LGsSbpqX406o2Ph0POgpSgmK";

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    var res = await http.get(
      Uri.parse("https://api.razorpay.com/v1/payments/$payId"),
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
        'Accept': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      var decodedData = json.decode(res.body);
      log(res.body);
      userProfileModel = await CommonFunctions().getProfileData();
      paymentResponse = PaymentResponse.fromJson(decodedData);
      amount = paymentResponse.amount! / 100;

      setState(() {
        isLoading = false;
      });
    } else {
      CommonFunctions.showErrorSnackbar("Something went wrong.");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.mainHomeScreen,
          arguments: {"initPageNumber": 0},
          (route) => false,
        )
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: isLoading
            ? const Center(
                child: PageLoaderScreen(),
              )
            : Center(child: successWidget()),
      ),
    );
  }

  Widget successWidget() {
    return Container(
      height: 500, //Add height as per requirement
      width: 500, //Add width as per requirement,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 15.0, spreadRadius: 1.0),
      ]),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ClipPath(
        clipper: DolDurmaClipper(holeRadius: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/status_success.svg',
                height: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Payment Successful!',
                style: GoogleFonts.mukta(
                    color: const Color(0xFF0fe600),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              const SizedBox(
                height: 12,
              ),
              TransactionHeaderTextHelper(
                title: "Transaction id",
                value: paymentResponse.orderId ?? "",
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    TransactionTextHelper(
                      title: 'Payment Type :',
                      value: paymentResponse.method ?? "",
                    ),
                    const SizedBox(height: 7),
                    TransactionTextHelper(
                      title: 'Mobile :',
                      value: paymentResponse.contact ?? "",
                    ),
                    const SizedBox(height: 7),
                    TransactionTextHelper(
                      title: 'Email :',
                      value: paymentResponse.email ?? "",
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount paid",
                          style: GoogleFonts.mukta(
                              fontSize: 12.5,
                              color: const Color.fromARGB(255, 122, 120, 142),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1),
                        ),
                        Text(
                          "\u{20B9} ${amount.toStringAsFixed(2)}",
                          style: GoogleFonts.mukta(
                              fontSize: 12.5,
                              color: const Color.fromARGB(255, 57, 57, 58),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () => Get.offAllNamed(
                        RouteName.mainHomeScreen,
                        arguments: {"initPageNumber": 0},
                      ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.mukta(color: whiteColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget failedWidget() {
    return Container(
      height: 500, //Add height as per requirement
      width: 500, //Add width as per requirement,
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 15.0, spreadRadius: 1.0),
      ]),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ClipPath(
        clipper: DolDurmaClipper(holeRadius: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 2)),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.red,
                    size: 45,
                  )),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Payment Failed!',
                style: GoogleFonts.mukta(
                    color: const Color(0xFFff0000),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              const SizedBox(
                height: 12,
              ),
              const TransactionHeaderTextHelper(
                title: "Transaction No",
                value: "response// .data!.transactionId!",
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    const TransactionTextHelper(
                      title: 'Mobile :',
                      value: "storedModel.phone!",
                    ),
                    const SizedBox(height: 7),
                    const TransactionTextHelper(
                      title: 'Email :',
                      value: "storedModel.email!",
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Amount :",
                          style: GoogleFonts.mukta(
                              fontSize: 12.5,
                              color: const Color.fromARGB(255, 122, 120, 142),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1),
                        ),
                        Text(
                          "\u{20B9} ${paymentResponse.amount}",
                          style: GoogleFonts.mukta(
                              fontSize: 12.5,
                              color: const Color.fromARGB(255, 57, 57, 58),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionHeaderTextHelper extends StatelessWidget {
  final String title, value;
  const TransactionHeaderTextHelper(
      {super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.mukta(
              fontSize: 11,
              color: const Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          ":",
          style: GoogleFonts.mukta(
              color: const Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: GoogleFonts.mukta(
              fontSize: 11,
              color: const Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
      ],
    );
  }
}

class TransactionTextHelper extends StatelessWidget {
  final String title, value;
  const TransactionTextHelper(
      {super.key, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.mukta(
              fontSize: 11,
              color: const Color.fromARGB(255, 122, 120, 142),
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
        Text(
          value,
          style: GoogleFonts.mukta(
              fontSize: 11,
              color: const Color.fromARGB(255, 57, 57, 58),
              fontWeight: FontWeight.bold,
              letterSpacing: 1),
        ),
      ],
    );
  }
}

class DolDurmaClipper extends CustomClipper<Path> {
  final double holeRadius;

  DolDurmaClipper({required this.holeRadius});

  @override
  Path getClip(Size size) {
    var bottom = size.height / 2;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - bottom - holeRadius)
      ..arcToPoint(
        Offset(0, size.height - bottom),
        clockwise: true,
        radius: const Radius.circular(1),
      )
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - bottom)
      ..arcToPoint(
        Offset(size.width, size.height - bottom - holeRadius),
        clockwise: true,
        radius: const Radius.circular(1),
      );

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}
