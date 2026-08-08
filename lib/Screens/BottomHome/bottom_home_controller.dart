import 'package:get/get.dart';

class BottomHomeController extends GetxController {
  RxBool isLoad = false.obs;

  loadingBool(bool val) {
    isLoad.value = val;
  }

  refreshProducts() {
    loadingBool(true);

    loadingBool(false);
  }
}
