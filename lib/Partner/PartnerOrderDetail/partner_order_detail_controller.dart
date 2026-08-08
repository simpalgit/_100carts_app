import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:carts_app/Models/dummy_order_stream.dart';
import 'package:carts_app/Utils/appcolors.dart';
import 'package:carts_app/Utils/common_functions.dart';

class PartnerOrderDetailController extends GetxController {
  RxBool loadingMap = true.obs;
  final Completer<GoogleMapController> controllerGoogleMap = Completer();
  Rxn<GoogleMapController> mapController = Rxn<GoogleMapController>();

  late Position position;
  PolylinePoints polylinePoints = PolylinePoints();
  RxMap<PolylineId, Polyline> polylines = <PolylineId, Polyline>{}.obs;
  List<LatLng> polylineCoordinates = [];
  RxList<Marker> markerList = <Marker>[].obs;
  late LatLngBounds routeBounds;

  get request => null;

  loadingMapFun(bool val) {
    loadingMap.value = val;
  }

  bool get mapLoading => loadingMap.value;

  getInitData(DummyOrderStream orderData) async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    await createPolylinesonRoute(orderData);
  }

  onMapCreated(GoogleMapController controller) {
    controllerGoogleMap.complete(controller);
    mapController.value = controller;
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      infoWindow: const InfoWindow(
        title: 'My Location',
      ),
      position: LatLng(position.latitude, position.longitude),
    );

    markerList.add(marker);
  }

  createPolylinesonRoute(DummyOrderStream orderData) async {
    loadingMapFun(false);
    // try {
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   CommonFunctions().mapKey,
    //   PointLatLng(position.latitude, position.longitude),
    //   PointLatLng(orderData.orderLocation!.latitude!,
    //       orderData.orderLocation!.longitude!),
    //   //   // travelMode: TravelMode.transit,
    // );
    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   request: request,
    //   googleApiKey: CommonFunctions().mapKey, // Use your actual API key
    // );
    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationMarker"),
      position: LatLng(orderData.orderLocation!.latitude!,
          orderData.orderLocation!.longitude!),
      infoWindow: const InfoWindow(
        title: "Destination",
      ),
    );
    // } catch (error) {
    //   print(error);
    // }

    markerList.add(destinationMarker);

    Polyline polyline = Polyline(
      polylineId: const PolylineId("polyRouteId"),
      color: primaryPartnerColor,
      points: polylineCoordinates,
      width: 5,
    );

    polylines[const PolylineId("polyRouteId")] = polyline;

    // if (result.points.isNotEmpty) {
    //   for (var point in result.points) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   }
    // }

    routeBounds = CommonFunctions().calculateLatLngBounds(polylineCoordinates);

    mapController.value!
        .animateCamera(CameraUpdate.newLatLngBounds(routeBounds, 80));
  }

  viewRouteBounds() => mapController.value!
      .animateCamera(CameraUpdate.newLatLngBounds(routeBounds, 80));

  viewMyLocation() => mapController.value!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 15)));

  @override
  void dispose() {
    mapController.value!.dispose();
    super.dispose();
  }
}
