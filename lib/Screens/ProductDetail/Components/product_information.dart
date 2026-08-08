import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Utils/appcolors.dart';

class ProductInformation extends StatelessWidget {
  final ProductDetailModel product;
  const ProductInformation({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: blackColor,
          height: 40,
        ),
        Text(
          "Product Information : ",
          style: GoogleFonts.mukta(
              fontWeight: FontWeight.bold, fontSize: 15, color: blackColor),
        ),
        const SizedBox(
          height: 10,
        ),
        product.data!.product!.description == null
            ? const SizedBox()
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: darkBlueColor.withOpacity(0.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description : ",
                      style: GoogleFonts.mukta(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: darkBlueColor),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      product.data!.product!.description!,
                      style: GoogleFonts.mukta(),
                    ),
                  ],
                ),
              ),
        product.data!.product!.features!.isEmpty
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Features : ",
                    style: GoogleFonts.mukta(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: darkBlueColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final data = product.data!.product!.features![index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${(index + 1).toString()})",
                              style: GoogleFonts.mukta(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                data.feature ?? "",
                                style: GoogleFonts.mukta(fontSize: 12),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 5,
                        );
                      },
                      itemCount: product.data!.product!.features!.length),
                ],
              ),
        product.data!.product!.info!.isEmpty
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "About Product :",
                    style: GoogleFonts.mukta(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: darkBlueColor),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: whiteColor, width: 2)),
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 1,
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: product.data!.product!.info!.length,
                      itemBuilder: (context, index) {
                        final data = product.data!.product!.info![index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "${data.attribute} : ",
                                style: GoogleFonts.mukta(
                                    fontWeight: FontWeight.bold),
                              )),
                              Expanded(
                                  child: Text(
                                data.value ?? "",
                                style: GoogleFonts.mukta(
                                    fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(
                    color: blackColor,
                    height: 40,
                  ),
                ],
              ),
      ],
    );
  }
}
