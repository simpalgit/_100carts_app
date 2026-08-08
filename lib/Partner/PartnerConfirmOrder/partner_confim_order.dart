import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/dummy_order_stream.dart';

class PartnerConfimOrder extends GetxController {
  RxBool isLoading = false.obs;
  final Rx<TextEditingController> otpController = TextEditingController().obs;

  loadingFun(bool val) => isLoading.value = false;
  Rxn<DummyOrderStream> order = Rxn<DummyOrderStream>();

  @override
  void onInit() {
    var data = Get.arguments;
    order.value = data['order'] as DummyOrderStream;

    super.onInit();
  }
}
