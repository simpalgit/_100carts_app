import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carts_app/Utils/common_functions.dart';

class PermissionController extends GetxController {
  var page = 0.obs;
  var pageController = PageController();
  RxBool isStorageLoading = false.obs;
  RxBool isCameraLoading = false.obs;
  // RxBool isLocationLoading = false.obs;
  RxBool isNotificationLoading = false.obs;

  RxString storage = "".obs;
  RxString notification = "".obs;
  RxString camera = "".obs;
  // RxString location = "".obs;
  // RxString latitude = "".obs;
  // RxString longitude = "".obs;

  onPageChanged(input) {
    page.value = input;
  }

  animateTo(int page) {
    if (pageController.hasClients) {
      pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  Future checkNotificationStatus() async {
    final plugin = DeviceInfoPlugin();
    PermissionStatus storageStatus;
    if (Platform.isAndroid) {
      final android = await plugin.androidInfo;
      storageStatus = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
    } else {
      storageStatus = await Permission.storage.status;
    }

    PermissionStatus notificationStatus = await Permission.notification.status;
    PermissionStatus cameraStatus = await Permission.camera.status;
    //   PermissionStatus locationStatus = await Permission.location.status;
    isCameraLoading.value = true;
    if (cameraStatus.isGranted) {
      camera.value = "Granted";
      page.value = 1;
    } else if (cameraStatus.isDenied) {
      camera.value = "Denied";
    } else {
      camera.value = "Permenantly Denied";
    }
    isCameraLoading.value = false;
    isStorageLoading.value = true;
    if (storageStatus.isGranted) {
      storage.value = "Granted";
      page.value = 2;
    } else if (storageStatus.isDenied) {
      storage.value = "Denied";
    } else {
      storage.value = "Permenantly Denied";
    }
    isStorageLoading.value = false;
    // isLocationLoading.value = true;
    // if (locationStatus.isGranted) {
    //   await Geolocator.getCurrentPosition(
    //           desiredAccuracy: LocationAccuracy.high)
    //       .then((Position position) {
    //     latitude.value = position.latitude.toString();
    //     longitude.value = position.longitude.toString();
    //   }).catchError((e) {
    //     debugPrint(e);
    //   });
    //   location.value = "Granted";
    //   page.value = 3;
    // } else if (locationStatus.isDenied) {
    //   location.value = "Denied";
    // } else {
    //   location.value = "Permenantly Denied";
    // }
    // isLocationLoading.value = false;
    isNotificationLoading.value = true;
    if (notificationStatus.isGranted) {
      notification.value = "Granted";

      CommonFunctions().checkRouteAndRedirect();
    } else if (notificationStatus.isDenied) {
      notification.value = "Denied";
    } else {
      notification.value = "Permenantly Denied";
    }
    isNotificationLoading.value = false;
  }

  Future requestCameraPermission() async {
    isCameraLoading.value = true;
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      camera.value = "Granted";
    } else if (status.isPermanentlyDenied) {
      camera.value = "Denied";
      await Permission.camera.request();
    } else {
      openAppSettings();
      camera.value = "Permenantly Denied";
    }

    isCameraLoading.value = false;

    if (camera.value == "Granted") {
      animateTo(1);
    }
  }

  Future requestStoragePermission() async {
    isStorageLoading.value = true;
    // PermissionStatus status = await Permission.storage.request();
    final plugin = DeviceInfoPlugin();

    PermissionStatus storageStatus;
    if (Platform.isAndroid) {
      final android = await plugin.androidInfo;
      storageStatus = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
    } else {
      storageStatus = await Permission.storage.status;
    }
    if (storageStatus.isGranted) {
      storage.value = "Granted";
    } else if (storageStatus.isPermanentlyDenied) {
      await Permission.storage.status;
    } else {
      storage.value = "Permenantly Denied";
      openAppSettings();
    }
    isStorageLoading.value = false;
    if (storage.value == "Granted") {
      animateTo(2);
    }
  }

  Future requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
    } else if (status.isDenied) {
      await Permission.location.request();
    } else {
      openAppSettings();
    }
  }

  Future requestNotificationPermission() async {
    isNotificationLoading.value = true;
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      notification.value = "Granted";
    } else if (status.isDenied) {
      notification.value = "Denied";
      await Permission.notification.request();
    } else {
      openAppSettings();
      notification.value = "Permenantly Denied";
    }
    isNotificationLoading.value = false;
    if (notification.value == "Granted") {
      // navigate to next page
      CommonFunctions().checkRouteAndRedirect();
    }
  }
}
