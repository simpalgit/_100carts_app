import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:carts_app/Models/dummy_order_stream.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/detail_widget_helper.dart';
import 'package:carts_app/Widgets/drawer_screen.dart';

import 'p_home_controller.dart';

class PartnerHomeScreen extends StatefulWidget {
  const PartnerHomeScreen({super.key});

  @override
  State<PartnerHomeScreen> createState() => _PartnerHomeScreenState();
}

class _PartnerHomeScreenState extends State<PartnerHomeScreen> {
  final controller = Get.put(PartnerHomeController());
  late StreamSubscription<List<DummyOrderStream>> subscription;
  GlobalKey<ScaffoldState> homeKey = GlobalKey();
  @override
  void initState() {
    subscription = controller.postStreamController.stream.listen((data) {
      // print(data);
    });
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<PartnerHomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeKey,
      endDrawer: SideMenu(
        homekey: homeKey,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Obx(() => CupertinoSlidingSegmentedControl(
                    thumbColor: controller.sliding.value == 0
                        ? Colors.red
                        : Colors.green,
                    children: {
                      0: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Offline",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: controller.sliding.value == 0
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                      1: Text(
                        "Online",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: controller.sliding.value == 0
                                ? Colors.black
                                : Colors.white),
                      ),
                    },
                    groupValue: controller.sliding.value,
                    onValueChanged: (int? newValue) {
                      if (newValue == 1) {
                        Get.dialog(
                          barrierDismissible: false,
                          PopScope(
                            canPop: false,
                            onPopInvoked: (bool didPop) async {},
                            child: AlertDialog(
                              backgroundColor: whiteColor,
                              icon: Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      controller.onChangeSliding(0);
                                      Get.back();
                                      setState(() {});
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: blackColor),
                                          color: whiteColor,
                                        ),
                                        child: const Icon(Icons.close)),
                                  )),
                              titleTextStyle: GoogleFonts.mukta(
                                  color: blackColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              title: Column(
                                children: [
                                  Image.asset(Images.goOnline),
                                  Text(
                                    "You want to go online and start receiving orders.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.mukta(
                                        color: secondaryColor),
                                  ),
                                ],
                              ),
                              content: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: blackColor),
                                    onPressed: () {
                                      controller.onChangeSliding(0);
                                      Get.back();
                                      setState(() {});
                                    },
                                    child: Text(
                                      "Not now..",
                                      style:
                                          GoogleFonts.mukta(color: whiteColor),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                    onPressed: () {
                                      Get.back();
                                      controller.onChangeSliding(newValue!);
                                    },
                                    child: Text(
                                      "Yes Sure..",
                                      style:
                                          GoogleFonts.mukta(color: whiteColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        controller.onChangeSliding(newValue!);
                      }
                    },
                  )),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<DummyOrderStream>>(
        stream: controller.postStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found'));
          } else {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DummyOrderStream post = snapshot.data![index];
                String address = "";
                if (post.customer != null && post.customer!.address != null) {
                  address =
                      "${post.customer!.address!.street} ${post.customer!.address!.city} ${post.customer!.address!.state} ${post.customer!.address!.zip}";
                }

                return InkWell(
                  onTap: () => Get.toNamed(RouteName.partnerOrderDetail,
                      arguments: {"order": post}),
                  child: Card(
                    shadowColor: blackColor,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: borderColor),
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 7,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GetBuilder<PartnerHomeController>(
                            builder: (_) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  CommonFunctions()
                                      .formatDuration(post.duration),
                                  style: GoogleFonts.mukta(fontSize: 15),
                                ),
                              );
                            },
                          ),
                          LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            barRadius: const Radius.circular(8),
                            restartAnimation: false,
                            animation: true,
                            isRTL: true,
                            fillColor: Colors.transparent,
                            progressColor: greyColor,
                            backgroundColor: primaryPartnerColor,
                            animateFromLastPercent: true,
                            animationDuration: post.duration.inMilliseconds,
                            lineHeight: 5.0,
                            percent: controller.progress.value,
                          ),
                          //     GetBuilder<PartnerHomeController>(
                          //   builder: (_) {
                          //     return LinearProgressIndicator(
                          //       value: controller.animationController.value,
                          //       semanticsLabel: 'Linear progress indicator',
                          //     );
                          //   },
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MultiDetailHelper(
                                heading: "Order Id",
                                value: checkNullOperatorFun(post.orderId),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              MultiDetailHelper(
                                heading: "Order Date",
                                value: checkNullOperatorFun(post.orderDate),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.person,
                                color: primaryPartnerColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                post.customer == null
                                    ? ""
                                    : checkNullOperatorFun(post.customer!.name),
                                style: GoogleFonts.mukta(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.normal,
                                    color: blackColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.location_solid,
                                color: primaryPartnerColor,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                address,
                                style: GoogleFonts.mukta(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.normal,
                                    color: blackColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
