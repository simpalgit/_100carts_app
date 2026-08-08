import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carts_app/Models/dummy_order_stream.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/route_names.dart';
import 'package:carts_app/Widgets/custom_image.dart';
import 'package:carts_app/Widgets/detail_widget_helper.dart';
import 'package:carts_app/Widgets/mrp_widget.dart';
import 'package:carts_app/Widgets/shimmer_helper.dart';

import 'partner_order_detail_controller.dart';

class PartnerOrderDetail extends StatefulWidget {
  const PartnerOrderDetail({super.key});

  @override
  State<PartnerOrderDetail> createState() => _PartnerOrderDetailState();
}

class _PartnerOrderDetailState extends State<PartnerOrderDetail>
    with WidgetsBindingObserver {
  final controller = Get.put(PartnerOrderDetailController());
  late DummyOrderStream order;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var data = Get.arguments;
      order = data['order'] as DummyOrderStream;
      controller.getInitData(order);
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // print('\n\ndidChangeAppLifecycleState');

    if (state == AppLifecycleState.resumed) {
      // final GoogleMapController controller1 =
      //     await controller.controllerGoogleMap.future;
    }
  }

  @override
  void dispose() {
    Get.delete<PartnerOrderDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
                height: constraints.maxHeight / 2,
                child: Obx(
                  () => controller.mapLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: primaryColor,
                        ))
                      : Stack(
                          children: [
                            GoogleMap(
                              zoomControlsEnabled: false,
                              initialCameraPosition: CameraPosition(
                                zoom: 19,
                                target: LatLng(controller.position.latitude,
                                    controller.position.longitude),
                              ),
                              mapType: MapType.normal,
                              markers: controller.markerList.toSet(),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              polylines:
                                  Set<Polyline>.of(controller.polylines.values),
                              onMapCreated: (mapCtl) =>
                                  controller.onMapCreated(mapCtl),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 0,
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.black87,
                                        backgroundColor: whiteColor,
                                        shape: const CircleBorder(
                                            side:
                                                BorderSide(color: blackColor))),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.route_outlined,
                                        color: blackColor,
                                      ),
                                    ),
                                    onPressed: () =>
                                        controller.viewRouteBounds(),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.black87,
                                        backgroundColor: whiteColor,
                                        shape: const CircleBorder(
                                            side:
                                                BorderSide(color: blackColor))),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Icon(
                                        Icons.my_location_rounded,
                                        color: blackColor,
                                      ),
                                    ),
                                    onPressed: () =>
                                        controller.viewMyLocation(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ));
          }),
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 1,
            snapSizes: const [0.5, 1],
            snap: true,
            builder: (BuildContext context, scrollSheetController) {
              return Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SingleChildScrollView(
                    controller: scrollSheetController,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => controller.mapLoading
                                ? ShimmerHelper(
                                    height: 10,
                                    width: size.width * 0.4,
                                    borderRadius: 8,
                                  )
                                : DetailWidgetHelper(
                                    heading: "Order No",
                                    value: checkNullOperatorFun(order.orderId),
                                  ),
                          ),
                          SizedBox(
                            height: controller.mapLoading ? 10 : 5,
                          ),
                          Obx(
                            () => controller.mapLoading
                                ? ShimmerHelper(
                                    height: 10,
                                    width: size.width * 0.3,
                                    borderRadius: 8,
                                  )
                                : Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.person_alt_circle,
                                        color: blackColor,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          order.customer == null
                                              ? ""
                                              : checkNullOperatorFun(
                                                  order.customer!.name),
                                          style: GoogleFonts.mukta(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: blackColor),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        CupertinoIcons.phone_circle_fill,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(
                            height: controller.mapLoading ? 10 : 5,
                          ),
                          Obx(() => controller.mapLoading
                              ? ShimmerHelper(
                                  height: 10,
                                  width: size.width * 0.3,
                                  borderRadius: 8,
                                )
                              : Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.location_solid,
                                      color: blackColor,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Text(
                                        order.customer == null
                                            ? ""
                                            : checkNullOperatorFun(order
                                                .customer!
                                                .address!
                                                .fullAddress),
                                        style: GoogleFonts.mukta(
                                            fontSize: 13, color: blackColor),
                                      ),
                                    ),
                                  ],
                                )),
                          SizedBox(
                            height: controller.mapLoading ? 10 : 5,
                          ),
                          Obx(() => controller.mapLoading
                              ? ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return shimmerCard();
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemCount: 3)
                              : ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomImage(
                                              image:
                                                  "https://picsum.photos/200",
                                              imgHeight: size.height * 0.08,
                                              imgWidth: size.height * 0.08),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "product name",
                                                  style: GoogleFonts.mukta(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    const Expanded(
                                                      child: MrpWidget(
                                                        cost: 240,
                                                        offerCost: 150,
                                                        offerSize: 14,
                                                        costSize: 13,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Quantity : ",
                                                          style: GoogleFonts.mukta(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  primaryColor),
                                                        ),
                                                        Text(
                                                          "2",
                                                          style:
                                                              GoogleFonts.mukta(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Total : \u{20B9} 240",
                                                      style: GoogleFonts.mukta(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 5,
                                    );
                                  },
                                  itemCount: 2)),
                          SizedBox(
                            height: controller.mapLoading ? 10 : 20,
                          ),
                          Obx(() => controller.mapLoading
                              ? const ShimmerHelper(
                                  height: 50,
                                  width: double.infinity,
                                  borderRadius: 25,
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryPartnerColor),
                                      onPressed: () {
                                        Get.toNamed(
                                            RouteName.partnerConfirmOrder,
                                            arguments: {"order": order});
                                      },
                                      child: Text(
                                        "Confirm Pickup",
                                        style: GoogleFonts.mukta(
                                            color: whiteColor),
                                      )),
                                )),
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }

  Widget shimmerCard() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            ShimmerHelper(
              height: size.height * 0.1,
              width: size.width * 0.3,
              borderRadius: 8,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  ShimmerHelper(
                    height: 12,
                    width: size.width,
                    borderRadius: 15,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const Row(
                    children: [
                      ShimmerHelper(
                        height: 15,
                        width: 30,
                        borderRadius: 5,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      ShimmerHelper(
                        height: 15,
                        width: 30,
                        borderRadius: 5,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ShimmerHelper(
                      height: 12,
                      width: size.width * 0.3,
                      borderRadius: 15,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
