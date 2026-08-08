import 'package:carts_app/Screens/Auth/Login/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Screens/WebviewScreen/webview_screen.dart';

import 'Components/banner_slider.dart';
import 'Components/category_section.dart';
import 'Components/deals_section.dart';
import 'Components/footer_section.dart';
import 'Components/home_custom_bar.dart';
import 'Components/pinnedappbar.dart';
import 'Components/product_categories.dart';
import 'Components/product_horizontal_list.dart';

class BottomHomeScreen extends StatefulWidget {
  const BottomHomeScreen({super.key});

  @override
  State<BottomHomeScreen> createState() => _BottomHomeScreenState();
}

class _BottomHomeScreenState extends State<BottomHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            /// 🔥 CUSTOM APP BAR WITH BIG LOGO
            SliverToBoxAdapter(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// 🔥 LOGO (FIXED SIZE)
                    InkWell(
                      onTap: () => Get.toNamed(RouteName.signInScreen),
                      child: Image.asset(
                        Images.appLogo,
                        height: 85, // ✅ Increased logo size
                        fit: BoxFit.contain,
                      ),
                    ),

                    /// 🔥 RIGHT SIDE ICONS
                    Row(
                      children: [
                        // Removed Meesho and Flipkart directly from AppBar
                        InkWell(
                          onTap: () => Get.toNamed(RouteName.signInScreen),
                          child: const Icon(Icons.shopping_cart_outlined,
                              size: 26),
                        ),
                        const SizedBox(width: 14),
                        InkWell(
                          onTap: () => Get.toNamed(RouteName.signInScreen),
                          child: const Icon(Icons.favorite_border, size: 26),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            /// 🔥 PINNED SEARCH BAR
            SliverPersistentHeader(
              pinned: true,
              delegate: PinnedAppBar(),
            ),

            /// 🔥 MAIN CONTENT
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),

                const OfferBannerSlider(),

                const SizedBox(height: 10),

                const CategorySection(),

                const SizedBox(height: 10),

                ProductCategories(
                  tabController: tabController,
                ),

                const SizedBox(height: 10),

                const TopSellingBrands(
                  title: "Top Selling Brands",
                ),

                const SizedBox(height: 10),

                const HotDeals(),

                const SizedBox(height: 15),

                /// 🔥 FOOTER (NOW PROPERLY VISIBLE)
                const BottomFooter(),

                const SizedBox(
                    height: 80), // Extra space to move mic button lower
              ]),
            ),
          ],
        ),
      ),

      /// 🔥 FLOATING MICROPHONE BUTTON (MOVED LOWER)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Only open voice search dialog - NO WhatsApp
          _showVoiceSearchDialog(context);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.mic, color: Colors.white, size: 24),
        mini: false,
        elevation: 8,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _showVoiceSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Voice Search'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mic, size: 64, color: primaryColor),
              const SizedBox(height: 16),
              const Text('Listening...'),
              const SizedBox(height: 16),
              const Text(
                'Speak the product name you want to search',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
