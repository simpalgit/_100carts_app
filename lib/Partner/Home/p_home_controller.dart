import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/dummy_order_stream.dart';
import 'package:carts_app/Screens/SplashScreen/permission_controller.dart';

class PartnerHomeController extends GetxController
//with GetSingleTickerProviderStateMixin
{
  // late AnimationController animationController;

  RxInt sliding = 0.obs;
  final StreamController<RxList<DummyOrderStream>> postStreamController =
      StreamController<RxList<DummyOrderStream>>.broadcast();

  // final StreamController<List<DummyOrderStream>> postStreamController =
  //     StreamController<List<DummyOrderStream>>.broadcast();

  RxList<DummyOrderStream> orderList = <DummyOrderStream>[].obs;
  RxDouble progress = 1.0.obs;

  @override
  void onInit() {
    PermissionController permissionController = Get.find();
    permissionController.requestLocationPermission();
    getOrders();
    // animationController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 5),
    // )..addListener(() {
    //     update();
    //   });
    // animationController.repeat(reverse: false);
    // Timer(const Duration(seconds: 5), () {
    //   animationController.stop();
    // });

    super.onInit();
  }

  onChangeSliding(int slide) {
    sliding.value = slide;
  }

  Future getOrders() async {
    String responce =
        await rootBundle.loadString('assets/dummy/allorders.json');
    List list = await json.decode(responce);
    orderList.value =
        list.map((element) => DummyOrderStream.fromJson(element)).toList();

    for (int i = 0; i < orderList.length; i++) {
      startTimer(i, orderList);
    }
    postStreamController.sink.add(orderList);
  }

  void startTimer(int index, RxList<DummyOrderStream> list) {
    const oneSecond = Duration(seconds: 1);
    list[index].timer = Timer.periodic(oneSecond, (timer) {
      if (list[index].duration.inSeconds > 0) {
        list[index].duration -= oneSecond;
      } else {
        list[index].timer!.cancel();
        //    list.removeAt(index);
      }
      update();
    });
  }

  // addElement() {
  //   RxList<DummyOrderStream> list = [
  //     DummyOrderStream(
  //         orderId: "ORD123457",
  //         customer: DummyCustomer(
  //           customerId: "CUST004",
  //           name: "Siddhant",
  //           email: "siddhanttest@gmail.com",
  //           phone: "9845154627",
  //           address: Address(
  //               street: "123 Elm St",
  //               city: "Springfield",
  //               state: "IL",
  //               zip: "62701"),
  //         ),
  //         orderDate: "2024-07-25",
  //         orderLocation:
  //             OrderLocation(latitude: 19.399887, longitude: 72.841490),
  //         items: [
  //           DummyItem(
  //               itemId: "ITEM001", name: "Widget A", quantity: 2, price: 19.99)
  //         ],
  //         totalAmount: 69.97,
  //         duration: const Duration(minutes: 1))
  //   ].obs;

  //   for (int i = 0; i < list.length; i++) {
  //     startTimer(i, orderList);
  //   }
  //   postStreamController.sink.add(list);
  // }

  @override
  void onClose() {
    postStreamController.close();
    super.onClose();
  }

  // @override
  // void dispose() {
  //   animationController.dispose();
  //   super.dispose();
  // }
}
