import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/ProductDetail/Components/detail_appbar.dart';
import 'package:carts_app/Screens/ProductDetail/Review/reviews_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Widgets/common_button_loader.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/input_fields.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({
    super.key,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  double ratingInit = 3.0;
  final GlobalKey<FormState> _formKey = GlobalKey();
  ReviewController controller = Get.find();
  String prodId = "", varId = "", prodName = "", prodImage = "";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      prodId = data['prodId'] as String;
      varId = data['varId'] as String;
      prodName = data['prodName'] as String;
      prodImage = data['prodImage'] as String;
      controller.clearData();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const DetailsAppBar(title: "Add Review"),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomImage(image: prodImage, imgHeight: 150, imgWidth: 150),
                  Text(
                    prodName,
                    style: GoogleFonts.mukta(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Rate the product",
                    style: GoogleFonts.mukta(
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    glow: false,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        ratingInit = rating;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          StepperTextField(
                            controllerValue: controller.ctlTitle,
                            inputType: TextInputType.text,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return "Title can't be empty.";
                              } else {
                                return null;
                              }
                            },
                            hintValue: "Title",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StepperTextField(
                            controllerValue: controller.ctlReview,
                            inputType: TextInputType.text,
                            validate: (val) {
                              if (val!.isEmpty) {
                                return "Review can't be empty.";
                              } else {
                                return null;
                              }
                            },
                            hintValue: "Review",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: size.width * 0.7,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    backgroundColor: primaryColor),
                                onPressed: controller.isSubmitLoading.value
                                    ? null
                                    : () {
                                        final isValid =
                                            _formKey.currentState!.validate();

                                        if (!isValid) {
                                          return;
                                        }

                                        CommonFunctions.hideKeyboard(context);

                                        controller.addReview(
                                            prodId, varId, ratingInit);
                                      },
                                child: controller.isSubmitLoading.value
                                    ? const CommonButtonLoader(
                                        indicatorColor: whiteColor)
                                    : Text(
                                        "Add Review",
                                        style: GoogleFonts.mukta(
                                            color: whiteColor),
                                      )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      )),
    );
  }
}
