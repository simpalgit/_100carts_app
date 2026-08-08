import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';

class PinnedAppBar extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
      color: homeBackColor,
      child: InkWell(
        onTap: () {
          HomeScreenController controller = Get.find();
          Get.toNamed(RouteName.searchProductField)!
              .then((value) => controller.getNearbyHomeData());
        },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 0.5),
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Search by Keyword or Product ID',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                InkWell(
                  onTap: () {
                    // TODO: Implement voice search functionality
                    _showVoiceSearchDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mic,
                      color: primaryColor,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.camera_alt_outlined,
                    color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
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
              Icon(Icons.mic, size: 64, color: primaryColor),
              SizedBox(height: 16),
              Text('Listening...'),
              SizedBox(height: 16),
              Text(
                'Speak the product name you want to search',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
