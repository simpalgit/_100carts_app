import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';

class OfferBannerSlider extends StatefulWidget {
  const OfferBannerSlider({
    super.key,
  });

  @override
  State<OfferBannerSlider> createState() => _OfferBannerSliderState();
}

class _OfferBannerSliderState extends State<OfferBannerSlider> {
  final int initialPage = 0;
  int _currentIndex = 0;
  final HomeScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // Show default offer banner when slider list is empty
    if (controller.sliderList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleOfferBanner(image: ""),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1,
            initialPage: initialPage,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 1500),
            autoPlayCurve: Curves.ease,
            enlargeCenterPage: false,
            onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: controller.sliderList
              .map((i) => SingleOfferBanner(
                    image: i.banner ?? "",
                  ))
              .toList(),
        ),
        Positioned(
          child: DotsIndicator(
            dotsCount: controller.sliderList.length,
            key: UniqueKey(),
            decorator: DotsDecorator(
              activeColor: primaryColor,
              color: Colors.white,
              activeSize: const Size(8.0, 8.0),
              size: const Size(5.0, 5.0),
              activeShape: RoundedRectangleBorder(
                  side: const BorderSide(color: whiteColor),
                  borderRadius: BorderRadius.circular(5.0)),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black54),
                  borderRadius: BorderRadius.circular(5.0)),
            ),
            position: _currentIndex,
          ),
        )
      ],
    );
  }

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class SingleOfferBanner extends StatelessWidget {
  final String image;
  const SingleOfferBanner({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.8),
              primaryColor.withOpacity(0.6)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            // Background pattern or image if available
            if (image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(); // Fallback to gradient if image fails
                  },
                ),
              ),

            // Offer text overlay
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const SizedBox(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  Icon(
                    Icons.local_offer,
                    size: 60,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
