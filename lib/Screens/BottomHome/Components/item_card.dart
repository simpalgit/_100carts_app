import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/product_id_model.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/discount_tag.dart';
import 'package:carts_app/Widgets/heart_widget.dart';
import 'package:carts_app/Widgets/mrp_widget.dart';

class ItemCard extends StatefulWidget {
  // final Item item;
  final ProductModel productModel;

  const ItemCard({
    super.key,
    required this.productModel,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  ProductModel product = ProductModel();

  List<ProductIdModel> prodIdList = [];
  HomeScreenController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    // CommonFunctions()
    //     .checkForProductIsWishList(widget.productModel, prodIdList);
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () => Get.toNamed(RouteName.productDetail,
              arguments: {"product": widget.productModel})!
          .then(
        (value) => controller.getNearbyHomeData(),
      ),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Product Image Section
          Expanded(
            flex: 5,
            child: Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: CustomImage(
                  image: widget.productModel.latestImage == null
                      ? ""
                      : widget.productModel.latestImage!.image ?? "",
                  boxFit: BoxFit.cover,
                  imgWidth: double.infinity,
                  imgHeight: double.infinity,
                ),
              ),
              // Discount Badge
              Positioned(
                left: 8,
                top: 8,
                child: DiscountTag(
                  discount: widget.productModel.activePrice!.discount,
                  discountType: "percent",
                ),
              ),
              // Wishlist Button
              Positioned(
                right: 8,
                top: 8,
                child: WishListWidget(
                  from: "home",
                  homeProductModel: widget.productModel,
                  product: null,
                  controller: _controller,
                ),
              ),
            ]),
          ),
          // Product Details Section
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: primaryColor.withOpacity(0.1),
                    ),
                    child: Text(
                      widget.productModel.product?.category?.name ?? "",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.mukta(
                        fontSize: 10,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Product Title
                  Text(
                    widget.productModel.title ?? "",
                    style: GoogleFonts.mukta(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        widget.productModel.rating.toString(),
                        style: GoogleFonts.mukta(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price
                  MrpWidget(
                    cost: widget.productModel.activePrice!.mrp ?? 0,
                    offerCost: widget.productModel.activePrice!.price ?? 0,
                    costSize: 11,
                    offerSize: 14,
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
