import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import '../Controllers/price_comparison_controller.dart';

class ProductDetailComponent extends StatefulWidget {
  final ProductDetailModel product;
  const ProductDetailComponent({super.key, required this.product});

  @override
  State<ProductDetailComponent> createState() => _ProductDetailComponentState();
}

class _ProductDetailComponentState extends State<ProductDetailComponent> {
  late String productThumb;

  @override
  void initState() {
    super.initState();
    productThumb = widget.product.data!.images!.isEmpty
        ? ""
        : widget.product.data!.images![0].image!;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final controller = Get.put(PriceComparisonController());

    // Load price comparisons when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPriceComparisons(widget.product.data!);
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          // Product Details Section with Price Comparison Integrated
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Section (Image + Details) - Same as Price Comparison Design
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image (Small)
                    Container(
                      height: size.width * 0.35,
                      width: size.width * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: widget.product.data?.images != null &&
                              widget.product.data!.images!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CustomImage(
                                image:
                                    widget.product.data!.images!.first.image ??
                                        '',
                                imgHeight: 100,
                                imgWidth: 100,
                                boxFit: BoxFit.contain,
                              ),
                            )
                          : Icon(Icons.image,
                              size: 30, color: Colors.grey.shade400),
                    ),

                    const SizedBox(width: 20),

                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand Name
                          Text(
                            'boAt',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Product Title
                          Text(
                            widget.product.data?.title ?? 'Product Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          // Rating
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      widget.product.data?.rating
                                              ?.toStringAsFixed(1) ??
                                          '4.4',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "(12.5K reviews)",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Features
                          featureRow(
                              Icons.graphic_eq, "Active Noise Cancellation"),
                          featureRow(Icons.battery_charging_full,
                              "Up to 65H Playtime"),
                          featureRow(Icons.bluetooth, "Bluetooth 5.3"),
                          featureRow(Icons.speaker, "40mm Drivers"),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // Compare Prices Section
                Text(
                  "Compare Prices",
                  style: GoogleFonts.mukta(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Find the best price",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                // Dynamic Price Cards (Integrated Directly)
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  return Column(
                    children: controller.priceComparisons.map((comparison) {
                      final bool hasLivePrice = comparison.price > 0;
                      return priceCard(
                        title: comparison.storeName,
                        price: hasLivePrice
                            ? "₹${comparison.price.toStringAsFixed(0)}"
                            : "Check Live Price",
                        originalPrice: (hasLivePrice &&
                                comparison.originalPrice > comparison.price)
                            ? "₹${comparison.originalPrice.toStringAsFixed(0)}"
                            : null,
                        buttonColor: _getStoreColor(comparison.storeName),
                        buttonText: "Buy on ${comparison.storeName}",
                        deliveryTime: comparison.deliveryTime,
                        discountPercentage:
                            (hasLivePrice && comparison.discountPercentage > 0)
                                ? comparison.discountPercentage
                                : null,
                        onTap: () => controller.launchStoreUrl(
                          comparison.storeName,
                          comparison.storeUrl,
                        ),
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 12),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Prices may vary. Please check the final price on the partner site.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStoreColor(String storeName) {
    switch (storeName.toLowerCase()) {
      case 'amazon':
        return Colors.orange;
      case 'flipkart':
        return Colors.blue;
      case 'meesho':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget priceCard({
    required String title,
    required String price,
    String? originalPrice,
    required Color buttonColor,
    required String buttonText,

    String? deliveryTime,
    double? discountPercentage,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Store Logo Only
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/$title.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.store,
                        size: 25,
                        color: Colors.grey.shade600,
                      );
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (originalPrice != null && discountPercentage != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${discountPercentage.toStringAsFixed(0)}% OFF",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: GoogleFonts.mukta(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (originalPrice != null)
                    Text(
                      originalPrice,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  Text(
                    deliveryTime ?? "FREE delivery",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: onTap,
                child: Text(
                  buttonText,
                  style: GoogleFonts.mukta(
                    color: whiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
