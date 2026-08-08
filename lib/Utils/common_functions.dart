import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Models/product_id_model.dart';
import 'package:carts_app/Models/user_profile_model.dart';
import 'package:carts_app/Screens/MainHomeScreen/main_home_screen_controller.dart';
import 'package:carts_app/Screens/WishList/wishlist_controller.dart';
import 'package:carts_app/Utils/images.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';
import 'package:carts_app/main.dart';

import 'appcolors.dart';
import 'route_names.dart';

class CommonFunctions {
  String mapKey = "AIzaSyBAy4wuelv36fwFPBBjQRvEjRkQE_f0ruA";
  static var globalContext = NavigationService.navigatorKey.currentContext!;
  String selectedVisitDate = "";

  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future pickDate(BuildContext context, DateTime? pickedDate) async {
    final initalDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: pickedDate ?? initalDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (newDate == null) {
      return ["null", null];
    } else {
      selectedVisitDate = DateFormat('dd-MM-yyyy').format(newDate);
      return [selectedVisitDate, newDate];
    }
  }

  static void showErrorSnackbar(String msg) {
    ScaffoldMessenger.of(globalContext).clearSnackBars();
    ScaffoldMessenger.of(globalContext).showSnackBar(SnackBar(
        margin: const EdgeInsets.only(bottom: 70.0, left: 20, right: 20),
        content: Text(
          msg,
          style: GoogleFonts.mukta(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5),
        ),
        backgroundColor: Colors.red.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }

  static void showSuccessSnackbar(String msg) {
    ScaffoldMessenger.of(globalContext).clearSnackBars();
    ScaffoldMessenger.of(globalContext).showSnackBar(SnackBar(
        margin: const EdgeInsets.only(bottom: 70.0, left: 20, right: 20),
        content: Text(
          msg,
          style: GoogleFonts.mukta(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5),
        ),
        backgroundColor: Colors.green.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }

  static void showWarningSnackbar(String msg) {
    ScaffoldMessenger.of(globalContext).clearSnackBars();
    ScaffoldMessenger.of(globalContext).showSnackBar(SnackBar(
        margin: const EdgeInsets.only(bottom: 70.0, left: 20, right: 20),
        content: Text(
          msg,
          style: GoogleFonts.mukta(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5),
        ),
        backgroundColor: blackColor,
        behavior: SnackBarBehavior.floating));
  }

  launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> makePhoneCall(String phone) async {
    String phoneNumber =
        'tel:+91$phone'; // Replace with the desired phone number

    // Check if the phone call can be launched
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      // Launch the phone call
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      CommonFunctions.showErrorSnackbar("Something went wrong.");
    }
  }

  Future<bool> loginInfo() async {
    bool isLogin = await LocalPreferences().getLoginBool() ?? false;

    return isLogin;
  }

  Future addRemoveCheckCart(
      String from, ProductDetailModel? product, ProductModel? homeModel) async {
    var isLogin = await CommonFunctions().loginInfo();

    bool isFav = false;
    dynamic model;

    if (from == "detail") {
      isFav = product!.data!.isFavourite == true;
      model = product;
    } else {
      isFav = homeModel!.isFavorite == true;
      model = homeModel;
    }

    WishListController wishListController = Get.find();
    if (isLogin) {
      if (isFav) {
        wishListController.removeWishList(
          from,
          model,
        );
      } else {
        wishListController.addWishList(
          from,
          model,
        );
      }
    } else {
      Get.toNamed(RouteName.signInScreen, arguments: {"fromMainBottom": false});
    }
  }

  Future<dynamic> pickAndCropImage({required String from}) async {
    final picker = ImagePicker();
    final XFile? pickedFile;
    if (from == "camera") {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      // Crop the picked image
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ],
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        // Do something with the cropped image (e.g., display it or upload it)

        return croppedFile;
      } else {
        return null;
      }
    }
  }

  showPopUp({
    required BuildContext context,
    required double screenHeight,
    required double screenWidth,
    required VoidCallback onCameraClick,
    required VoidCallback onGalleryClick,
  }) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Wrap(children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '____',
                      style: GoogleFonts.mukta(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 17),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ColumnImageTextHelper(
                          imagePath: Images.bycamera,
                          title: 'Camera',
                          onCLicked: onCameraClick,
                          sHeight: screenHeight,
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        ColumnImageTextHelper(
                          imagePath: Images.bygallery,
                          title: 'Gallery',
                          onCLicked: onGalleryClick,
                          sHeight: screenHeight,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]);
        });
  }

  dynamic getCurrentLatAndLong() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      var position =
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      return position;
    } else if (status.isDenied) {
      CommonFunctions.showErrorSnackbar("Enable location first from settings.");
      await Permission.location.request();
      return "error";
    } else {
      CommonFunctions.showErrorSnackbar("Enable location first from settings.");

      return "error";
      // openAppSettings();
    }
  }

  checkIfLogin(String from) async {
    final HomeScreenController controller = Get.find();
    bool isLogin = await LocalPreferences().getLoginBool() ?? false;

    if (isLogin) {
      if (from == "Cart") {
        Get.toNamed(RouteName.cartScreen)!
            .then((value) => controller.getNearbyHomeData());
      } else if (from == "WishList") {
        Get.toNamed(RouteName.wishListScreen)!
            .then((value) => controller.getNearbyHomeData());
      } else if (from == "OrderList") {
        Get.toNamed(RouteName.orderListScreen)!
            .then((value) => controller.getNearbyHomeData());
      }
    } else {
      Get.toNamed(RouteName.signInScreen,
          arguments: {"fromMainBottom": false, "from": from});
    }
  }

  double gstAmtCalculater(String gstType, String subtotal, String tax) {
    if (gstType == "Add") {
      return (double.parse(subtotal) * int.parse(tax)) / 100;
    } else {
      var gstAmt = (double.parse(subtotal) -
          (double.parse(subtotal) * (100 / (100 + int.parse(tax)))));
      return gstAmt;
    }
  }

  double calculateDiscount(num mrp, num price) {
    if (mrp <= 0 || price < 0 || price > mrp) {
      // throw ArgumentError("Invalid MRP or price values");

      return 0.0;
    }
    double discount = ((mrp - price) / mrp) * 100;
    return double.parse(discount.toStringAsFixed(2));
  }

  Future<UserProfileModel> getProfileData() async {
    String helper = await LocalPreferences().getProfileData() ?? "";
    Map<String, dynamic> userMap = jsonDecode(helper);
    return UserProfileModel.fromJson(userMap);
  }

  checkRouteAndRedirect() async {
    bool isPartnerLogin =
        await LocalPreferences().getPartnerLoginBool() ?? false;

    if (isPartnerLogin) {
      Get.offAllNamed(
        RouteName.partnerHomeScreen,
      );
    } else {
      Get.offAllNamed(RouteName.mainHomeScreen, arguments: {"initPage": 0});
    }
  }

  String formatDuration(Duration duration) {
    return DateFormat('mm:ss')
        .format(DateTime(0, 0, 0, 0, 0, duration.inSeconds));
  }

  // Future<ArtistUserModel> getArtistProfileData() async {
  //   String helper = await LocalPreferences().getProfileData() ?? "";

  //   Map<String, dynamic> userMap = jsonDecode(helper);
  //   ArtistUserModel empModel = ArtistUserModel.fromProfileJson(userMap);
  //   return empModel;
  // }

  dynamic convertToDouble(dynamic value) {
    value ??= 0;
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      throw ArgumentError('Value must be either int or double');
    }
  }

  LatLngBounds calculateLatLngBounds(List<LatLng> points) {
    double southWestLat = points[0].latitude;
    double southWestLng = points[0].longitude;
    double northEastLat = points[0].latitude;
    double northEastLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < southWestLat) southWestLat = point.latitude;
      if (point.longitude < southWestLng) southWestLng = point.longitude;
      if (point.latitude > northEastLat) northEastLat = point.latitude;
      if (point.longitude > northEastLng) northEastLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  stateCityAreaDialogue(
      {required BuildContext context,
      required String title,
      required TextEditingController controller,
      required Function(String)? onChange,
      required listWidget}) {
    return Get.dialog(
      GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          color: whiteColor,
          child: SizedBox(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios)),
                    Expanded(
                      child: Text(title,
                          style: GoogleFonts.mukta(
                              color: blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    const Icon(
                      CupertinoIcons.location_solid,
                      color: primaryPartnerColor,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  autofocus: true,
                  style: GoogleFonts.mukta(fontSize: 14),
                  maxLength: 15,
                  onChanged: onChange,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Required*';
                    } else {
                      return null;
                    }
                  },
                  controller: controller,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(
                        CupertinoIcons.search,
                        size: 12,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: blackColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: blackColor)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: blackColor)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.red)),
                      hintText: title,
                      helperStyle: GoogleFonts.mukta(fontSize: 14),
                      counterText: ""),
                ),
                const SizedBox(
                  height: 5,
                ),
                listWidget
              ],
            ),
          ),
        ),
      ),
      transitionCurve: Curves.easeInOut,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<List<ProductIdModel>> getLocalWishListId() async {
    List<String> idList = await LocalPreferences().getStoredWishList() ?? [];

    List<ProductIdModel> productIdModelList = [];

    for (var element in idList) {
      var split = element.split("-");

      productIdModelList.add(ProductIdModel(id: split[0], productId: split[1]));
    }

    return productIdModelList;
  }

  addOrRemoveLocalWishListProduct(
      {required String operation, required String val}) async {
    List<String> idList = await LocalPreferences().getStoredWishList() ?? [];
    if (operation == "add") {
      idList.add(val);
    } else {
      idList.removeWhere((e) => e == val);
    }

    LocalPreferences().setStoredWishList(idList.toList());
  }

  checkForProductIsWishList(
      ProductModel product, List<ProductIdModel> prodIdList) async {
    List<ProductIdModel> prodIdList = await getLocalWishListId();

    if (prodIdList.isEmpty) {
      product.isFavorite = false;
    }
    for (var element in prodIdList) {
      if (int.parse(element.id) == product.id &&
          int.parse(element.productId) == product.productId) {
        product.isFavorite = true;
      } else {
        product.isFavorite = false;
      }
    }

    return product;
  }

  void sessionTimeOut() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    Get.offAllNamed(RouteName.splashScreen);
  }

  void logOut() => Get.offAllNamed(RouteName.splashScreen);
}

class ColumnImageTextHelper extends StatelessWidget {
  final double? sHeight;
  final String? imagePath;
  final String? title;
  final VoidCallback? onCLicked;
  const ColumnImageTextHelper(
      {super.key, this.sHeight, this.imagePath, this.onCLicked, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCLicked,
      child: Row(
        children: [
          SvgPicture.asset(
            imagePath!,
            height: sHeight! * 0.04,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            title!,
            style: GoogleFonts.mukta(
                color: blackColor, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}

class ColumnAssetsImageTextHelper extends StatelessWidget {
  final double? sHeight;
  final String? imagePath;
  final String? title;
  final VoidCallback? onCLicked;
  const ColumnAssetsImageTextHelper(
      {super.key, this.sHeight, this.imagePath, this.onCLicked, this.title});

  get secondary => null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCLicked,
      child: Column(
        children: [
          Image.asset(
            imagePath!,
            height: sHeight! * 0.1,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            title!,
            style: TextStyle(color: secondary, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
