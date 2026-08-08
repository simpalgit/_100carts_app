import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Utils/app_network_api_services.dart';
import 'package:carts_app/Utils/remote_urls.dart';
import 'package:carts_app/Screens/WebviewScreen/webview_screen.dart';
class PriceComparisonController extends GetxController {
  final isLoading = false.obs;
  final priceComparisons = <PriceComparison>[].obs;

  static const Map<String, String> _headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.9',
  };

  Future<void> loadPriceComparisons(DataDetailModel product) async {
    isLoading.value = true;

    try {
      List<Map<String, dynamic>> storeList = [];

      final productId = product.productId ?? product.id ?? product.product?.id;
      if (productId != null) {
        try {
          final response = await NetworkAPIService()
              .getGetApiResponse('${RemoteUrl.getLivePrices}/$productId');
          if (response != null &&
              response['response'] == true &&
              response['data'] is List) {
            final List dynamicList = response['data'];
            if (dynamicList.isNotEmpty) {
              storeList = dynamicList
                  .map((item) => {
                        'storeName': item['storeName'] ?? '',
                        'storeUrl': item['storeUrl'] ?? '',
                        'logoUrl': item['logoUrl'] ?? 'assets/images/Amazon.png',
                        'deliveryTime': item['deliveryTime'] ?? '2-3 days',
                        'price': item['price'] != null
                            ? (item['price'] as num).toDouble()
                            : null,
                        'originalPrice': item['originalPrice'] != null
                            ? (item['originalPrice'] as num).toDouble()
                            : null,
                      })
                  .toList();
            }
          }
        } catch (e) {
          debugPrint('Live price API fetch failed: $e');
        }
      }

      // Ensure Amazon, Flipkart, and Meesho are always present
      final existingStores = storeList.map((s) => (s['storeName'] as String).toLowerCase()).toSet();
      final String productTitle = product.title ?? 'product';

      if (!existingStores.contains('amazon')) {
        storeList.add({
          'storeName': 'Amazon',
          'storeUrl': (product.product?.amazonLink != null && product.product!.amazonLink!.trim().isNotEmpty)
              ? product.product!.amazonLink!.trim()
              : 'https://www.amazon.in/s?k=${Uri.encodeComponent(productTitle)}',
          'logoUrl': 'assets/images/Amazon.png',
          'deliveryTime': '2-3 days',
        });
      }

      if (!existingStores.contains('flipkart')) {
        storeList.add({
          'storeName': 'Flipkart',
          'storeUrl': (product.product?.flipkartLink != null && product.product!.flipkartLink!.trim().isNotEmpty)
              ? product.product!.flipkartLink!.trim()
              : 'https://www.flipkart.com/search?q=${Uri.encodeComponent(productTitle)}',
          'logoUrl': 'assets/images/Flipkart.png',
          'deliveryTime': '3-4 days',
        });
      }

      if (!existingStores.contains('meesho')) {
        storeList.add({
          'storeName': 'Meesho',
          'storeUrl': (product.product?.meeshoLink != null && product.product!.meeshoLink!.trim().isNotEmpty)
              ? product.product!.meeshoLink!.trim()
              : 'https://www.meesho.com/search?q=${Uri.encodeComponent(productTitle)}',
          'logoUrl': 'assets/images/Meesho.png',
          'deliveryTime': '4-5 days',
        });
      }

      final double basePrice = (product.activePrice?.price ?? 0).toDouble();
      final double baseMrp = (product.activePrice?.mrp ?? basePrice).toDouble();

      // Fetch live prices directly from store links on the frontend if needed
      final List<PriceComparison> comparisons = await Future.wait(
        storeList.map((store) async {
          final String storeName = store['storeName'] ?? '';
          final String storeUrl = store['storeUrl'] ?? '';
          final String logoUrl =
              store['logoUrl'] ?? 'assets/images/$storeName.png';
          final String deliveryTime = store['deliveryTime'] ?? '2-3 days';

          double livePrice = (store['price'] as double?) ?? 0.0;
          double liveMrp = (store['originalPrice'] as double?) ?? 0.0;

          if (livePrice <= 0) {
            final liveData = await _fetchLivePrice(storeName, storeUrl);
            livePrice = liveData?['price'] ?? 0.0;
            liveMrp = liveData?['originalPrice'] ?? livePrice;
          }

          if (livePrice <= 0) {
            final double mult = storeName.toLowerCase() == 'amazon'
                ? 0.98
                : (storeName.toLowerCase() == 'flipkart' ? 0.95 : 0.92);
            livePrice = basePrice > 0
                ? (basePrice * mult).roundToDouble()
                : (storeName.toLowerCase() == 'amazon'
                    ? 499.0
                    : (storeName.toLowerCase() == 'flipkart'
                        ? 479.0
                        : 459.0));
            liveMrp = baseMrp > livePrice
                ? baseMrp
                : (livePrice * 1.2).roundToDouble();
          }

          return PriceComparison(
            storeName: storeName,
            price: livePrice,
            originalPrice: liveMrp,
            deliveryTime: deliveryTime,
            storeUrl: storeUrl,
            logoUrl: logoUrl,
            size: 20,
          );
        }),
      );

      priceComparisons.value = comparisons;
    } catch (e) {
      debugPrint('Error loading price comparisons: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, double>?> _fetchLivePrice(
      String storeName, String url) async {
    if (url.trim().isEmpty) return null;

    final nameLower = storeName.toLowerCase();
    if (nameLower == 'amazon') {
      return _fetchLivePriceFromAmazon(url);
    } else if (nameLower == 'flipkart') {
      return _fetchLivePriceFromFlipkart(url);
    } else if (nameLower == 'meesho') {
      return _fetchLivePriceFromMeesho(url);
    }
    return null;
  }

  Future<Map<String, double>?> _fetchLivePriceFromAmazon(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final html = response.body;
        double? price;
        double? originalPrice;

        final priceMatch = RegExp(r'class="a-price-whole">([0-9,]+)',
                caseSensitive: false)
            .firstMatch(html) ??
            RegExp(r'id="(?:priceblock_ourprice|priceblock_dealprice|price_inside_buybox)">\s*₹?\s*([0-9,.]+)',
                    caseSensitive: false)
                .firstMatch(html) ??
            RegExp(r'class="a-offscreen">\s*₹?\s*([0-9,.]+)',
                    caseSensitive: false)
                .firstMatch(html);

        if (priceMatch != null) {
          price = double.tryParse(priceMatch.group(1)!.replaceAll(',', ''));
        }

        final mrpMatch = RegExp(
                r'class="a-text-price"[^>]*>\s*<span class="a-offscreen">\s*₹?\s*([0-9,.]+)',
                caseSensitive: false)
            .firstMatch(html);
        if (mrpMatch != null) {
          originalPrice =
              double.tryParse(mrpMatch.group(1)!.replaceAll(',', ''));
        }

        if (price != null && price > 0) {
          return {
            'price': price,
            'originalPrice':
                (originalPrice != null && originalPrice > price)
                    ? originalPrice
                    : price,
          };
        }
      }
    } catch (e) {
      debugPrint('Error scraping Amazon URL ($url): $e');
    }
    return null;
  }

  Future<Map<String, double>?> _fetchLivePriceFromFlipkart(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final html = response.body;
        double? price;
        double? originalPrice;

        final priceMatch = RegExp(
                r'class="[^"]*(?:Nx9bqj|_30jeq3)[^"]*">\s*₹\s*([0-9,]+)',
                caseSensitive: false)
            .firstMatch(html) ??
            RegExp(r'"price":\s*"([0-9.]+)"', caseSensitive: false)
                .firstMatch(html);

        if (priceMatch != null) {
          price = double.tryParse(priceMatch.group(1)!.replaceAll(',', ''));
        }

        final mrpMatch = RegExp(
                r'class="[^"]*(?:yRaYxfa|_3I9_wc)[^"]*">\s*₹\s*([0-9,]+)',
                caseSensitive: false)
            .firstMatch(html);
        if (mrpMatch != null) {
          originalPrice =
              double.tryParse(mrpMatch.group(1)!.replaceAll(',', ''));
        }

        if (price != null && price > 0) {
          return {
            'price': price,
            'originalPrice':
                (originalPrice != null && originalPrice > price)
                    ? originalPrice
                    : price,
          };
        }
      }
    } catch (e) {
      debugPrint('Error scraping Flipkart URL ($url): $e');
    }
    return null;
  }

  Future<Map<String, double>?> _fetchLivePriceFromMeesho(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final html = response.body;
        double? price;
        double? originalPrice;

        final nextDataMatch = RegExp(
                r'<script id="__NEXT_DATA__" type="application\/json">(.*?)<\/script>',
                dotAll: true)
            .firstMatch(html);
        if (nextDataMatch != null) {
          final jsonStr = nextDataMatch.group(1);
          if (jsonStr != null) {
            final data = jsonDecode(jsonStr);
            final details = data['props']?['pageProps']?['initialState']
                ?['product']?['details'];
            if (details != null) {
              price = (details['price'] as num?)?.toDouble();
              originalPrice = (details['mrp'] as num?)?.toDouble();
            }
          }
        }

        if (price == null || price <= 0) {
          final priceMatch =
              RegExp(r'₹\s*([0-9,]+)', caseSensitive: false).firstMatch(html);
          if (priceMatch != null) {
            price = double.tryParse(priceMatch.group(1)!.replaceAll(',', ''));
          }
        }

        if (price != null && price > 0) {
          return {
            'price': price,
            'originalPrice':
                (originalPrice != null && originalPrice > price)
                    ? originalPrice
                    : price,
          };
        }
      }
    } catch (e) {
      debugPrint('Error scraping Meesho URL ($url): $e');
    }
    return null;
  }

  Future<void> launchStoreUrl(String storeName, String url) async {
    Get.snackbar(
      'Opening $storeName',
      'Generating tracked affiliate link...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );

    try {
      final response = await NetworkAPIService().getPostApiResponse(
        RemoteUrl.generateAffiliate,
        jsonEncode({
          'product_url': url,
          'marketplace': storeName.toLowerCase(),
        }),
      );

      if (response is http.Response) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['response'] == true) {
          final String affiliateUrl = data['data']['affiliate_url'];

          Get.snackbar(
            'Redirecting',
            'Opening partner store...',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 1),
          );

          Get.to(() => WebviewScreen(url: affiliateUrl, title: storeName));
        } else {
          Get.to(() => WebviewScreen(url: url, title: storeName));
        }
      } else {
        Get.to(() => WebviewScreen(url: url, title: storeName));
      }
    } catch (e) {
      Get.to(() => WebviewScreen(url: url, title: storeName));
    }
  }
}

class PriceComparison {
  final String storeName;
  final double price;
  final double originalPrice;

  final String deliveryTime;
  final String storeUrl;
  final String logoUrl;
  final double size;

  PriceComparison({
    required String storeName,
    required this.price,
    required this.originalPrice,
    required this.deliveryTime,
    required this.storeUrl,
    required this.logoUrl,
    this.size = 20.0,
  }) : storeName = storeName.toLowerCase() == 'amazon'
            ? 'Amazon'
            : (storeName.toLowerCase() == 'flipkart' ? 'Flipkart' : 'Meesho');

  double get discountPercentage =>
      (originalPrice > price && originalPrice > 0)
          ? ((originalPrice - price) / originalPrice * 100)
          : 0;

  double get finalPrice => price;
}

