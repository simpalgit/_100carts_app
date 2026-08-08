import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Widgets/permission_widget.dart';

import 'permission_controller.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final PermissionController controller = Get.find();

  @override
  void initState() {
    controller.checkNotificationStatus();
    super.initState();
  }

  @override
  void dispose() {
    //  Get.delete<PermissionController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.onPageChanged(index);
        },
        itemCount: 3,
        itemBuilder: (context, index) {
          return Obx(() => _buildPage(controller.page.value, size));
        },
      ),
    );
  }

  Widget _buildPage(int index, Size size) {
    switch (index) {
      case 0:
        return PermissionWidget(
          title: "Allow camera access.",
          imageString: Images.cameraImage,
          onSure: controller.isCameraLoading.value
              ? null
              : () => controller.requestCameraPermission(),
          notNow: controller.isCameraLoading.value
              ? null
              : () => controller.animateTo(1),
        );

      case 1:
        return PermissionWidget(
          title: "Allow storage access.",
          imageString: Images.storageImage,
          onSure: controller.isStorageLoading.value
              ? null
              : () => controller.requestStoragePermission(),
          notNow: controller.isStorageLoading.value
              ? null
              : () => controller.animateTo(2),
        );
      // case 2:
      //   return PermissionWidget(
      //     title: "Allow location access.",
      //     imageString: Images.locationImage,
      //     onSure: controller.isLocationLoading.value
      //         ? null
      //         : () => controller.requestLocationPermission(),
      //     notNow: controller.isLocationLoading.value
      //         ? null
      //         : () => controller.animateTo(3),
      //   );
      case 2:
        return PermissionWidget(
          title: "Allow Notification access.",
          imageString: Images.notificationImage,
          onSure: controller.isNotificationLoading.value
              ? null
              : () => controller.requestNotificationPermission(),
          notNow: controller.isNotificationLoading.value
              ? null
              : () {
                  CommonFunctions().checkRouteAndRedirect();
                },
        );
      default:
        return Container();
    }
  }
}
