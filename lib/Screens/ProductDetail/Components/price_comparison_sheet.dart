import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import '../Controllers/price_comparison_controller.dart';

class PriceComparisonSheet extends StatelessWidget {
  final DataDetailModel product;

  const PriceComparisonSheet({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PriceComparisonController());

    // Load price comparisons when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPriceComparisons(product);
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: Colors.grey.shade600),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Product Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: product.images != null && product.images!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImage(
                            image: product.images!.first.image ?? '',
                            imgHeight: 120,
                            imgWidth: 120,
                            boxFit: BoxFit.contain,
                          ),
                        )
                      : Icon(Icons.image,
                          size: 40, color: Colors.grey.shade400),
                ),

                const SizedBox(width: 16),

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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Product Title
                      Text(
                        product.title ??
                            'boAt Nirvana 751 ANC Over-Ear Headphones',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      // Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  product.rating?.toStringAsFixed(1) ?? '4.4',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "(12.5K reviews)",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Features
                      featureRow(Icons.graphic_eq, "Active Noise Cancellation"),
                      featureRow(
                          Icons.battery_charging_full, "Up to 65H Playtime"),
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

            // Dynamic Price Cards
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
          ],
        ),
      ),
    );
  }

  Widget featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
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
      margin: const EdgeInsets.only(top: 10),
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
              Text(
                title,
                style: GoogleFonts.mukta(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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

// Helper function to show the bottom sheet
void showPriceComparisonSheet(BuildContext context, DataDetailModel product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PriceComparisonSheet(product: product),
  );
}
