import 'package:get/get.dart';

class QuantityController extends GetxController {
  RxInt currentQuantity = 1.obs;

  void increaseQuantity() {
    currentQuantity.value++;
  }

  void decreaseQuantity() {
    if (currentQuantity.value > 1) {
      currentQuantity.value--;
    }
  }

  void resetQuantity() {
    currentQuantity.value == 0;
  }
}
