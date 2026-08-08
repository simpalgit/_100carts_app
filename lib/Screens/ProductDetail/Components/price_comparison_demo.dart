/*import 'package:flutter/material.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Screens/ProductDetail/Components/price_comparison_sheet.dart';

/// Demo widget to showcase the Price Comparison Sheet
/// You can integrate this into your existing product detail screen
class PriceComparisonDemo extends StatelessWidget {
  const PriceComparisonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Comparison Demo'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Create sample product data
            final sampleProduct = DataDetailModel(
              title: 'boAt Nirvana 751 ANC Over-Ear Headphones',
              rating: 4.4,
              activePrice: ActivePrice(
                price: 2499,
                mrp: 2999,
              ),
              images: [
                SingleImageModel(
                  image:
                      'https://m.media-amazon.com/images/I/61u1VALn6JL._SL1500_.jpg',
                ),
              ],
              values: [
                ValueElement(
                  value: ValueValue(
                    attributeValue: 'Active Noise Cancellation',
                  ),
                ),
                ValueElement(
                  value: ValueValue(
                    attributeValue: 'Up to 65H Playtime',
                  ),
                ),
                ValueElement(
                  value: ValueValue(
                    attributeValue: 'Bluetooth 5.3',
                  ),
                ),
                ValueElement(
                  value: ValueValue(
                    attributeValue: '40mm Drivers',
                  ),
                ),
              ],
            );

            // Show the price comparison sheet
            showPriceComparisonSheet(context, sampleProduct);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text(
            'Show Price Comparison',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Usage Instructions:
/// 
/// 1. In your existing ProductDetailComponent, replace the Amazon button with:
/// ```dart
/// ElevatedButton(
///   onPressed: () {
///     showPriceComparisonSheet(context, widget.product.data!);
///   },
///   child: Text('Compare Prices'),
/// )
/// ```
/// 
/// 2. The sheet will automatically load price comparisons from the controller
/// 3. Users can tap on any store button to be redirected (currently shows snackbar)
/// 
/// Features:
/// - Dynamic price loading with loading state
/// - Discount percentage display

/// - Delivery time estimates
/// - Store-specific branding
/// - Responsive design
/// - Smooth animations
*/
