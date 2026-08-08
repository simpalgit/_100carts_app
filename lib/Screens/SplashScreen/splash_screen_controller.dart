import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carts_app/Screens/Cart/cart_controller.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Screens/WishList/wishlist_controller.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';
import 'package:carts_app/Utils/route_names.dart';

import '../BottomExplore/explore_controller.dart';
import 'permission_controller.dart';

class SplashScreenController extends GetxController {
  RxBool loading = false.obs;
  RxDouble progress = 0.0.obs;

  initData() {
    loading.value = false;
    progress.value = 0.0;
  }

  getInitData() async {
    final HomeScreenController controller = Get.put(HomeScreenController());
    final WishListController wishList = Get.put(WishListController());
    Get.put(PermissionController());
    Get.put(ExploreController());

    wishList.initData();
    final CartController cart = Get.put(CartController());
    cart.initData();
    // String latitude = "", longitude = "";
    // await permission.requestLocationPermission();
    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //     .then((Position position) {
    //   latitude = position.latitude.toString();
    //   longitude = position.longitude.toString();
    // }).catchError((e) {
    //   debugPrint(e);
    // });
    //  progress.value = 0.3;
    await controller.getHomeData("72.8397", "19.3919");

    //   exploreController.getParentCategory();
    //  progress.value = 1.0;
  }

  checkData() async {
    final plugin = DeviceInfoPlugin();
    PermissionStatus storageStatus;
    if (Platform.isAndroid) {
      final android = await plugin.androidInfo;
      if (android.version.sdkInt < 33) {
        storageStatus = await Permission.storage.status;
      } else {
        storageStatus = PermissionStatus.granted;
      }
    } else {
      storageStatus = await Permission.storage.status;
    }

    PermissionStatus notificationStatus = await Permission.notification.status;

    PermissionStatus cameraStatus = await Permission.camera.status;

    bool isPartnerLogin =
        await LocalPreferences().getPartnerLoginBool() ?? false;

    if (!isPartnerLogin) {
      await getInitData();
    }

    if (notificationStatus.isGranted &&
        cameraStatus.isGranted &&
        storageStatus.isGranted) {
      CommonFunctions().checkRouteAndRedirect();

      loading.value = true;
      progress.value = 0.1;
    } else {
      Get.offAllNamed(RouteName.permissionScreen);
    }
  }
}
