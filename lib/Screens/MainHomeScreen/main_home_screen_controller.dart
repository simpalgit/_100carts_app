import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/category_model.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/slider_model.dart';
import 'package:carts_app/Repositories/main_home_repository.dart';
import 'package:carts_app/Screens/BottomExplore/explore_products.dart';
import 'package:carts_app/Screens/BottomHome/bottom_home.dart';
import 'package:carts_app/Screens/BottomOrder/Components/orders_appbar.dart';
import 'package:carts_app/Screens/BottomOrder/order_screen.dart';
import 'package:carts_app/Screens/BottomProfile/bottom_profile.dart';
import 'package:carts_app/Screens/OrderList/Components/orderlist_list.dart';
import 'package:carts_app/Screens/OrderList/orderist_screen.dart';
import 'package:carts_app/Utils/common_functions.dart';

import 'Component/navigation_bar_controller.dart';

class HomeScreenController extends GetxController {
  MainHomeRepository mainHomeRepository = MainHomeRepository();

  RxBool isLoading = true.obs;
  RxBool isNearLoading = false.obs;
  RxInt bottomNavIndex = 0.obs;
  final RxList<SliderModel> sliderList = <SliderModel>[].obs;
  final RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  final RxList<ProductModel> topRatedProductList = <ProductModel>[].obs;
  final RxList<ProductModel> bestSellerProductList = <ProductModel>[].obs;
  final RxList<ProductModel> allProductList = <ProductModel>[].obs;
  final RxList<CategoryModel> topSellingBrandsList = <CategoryModel>[].obs;

  void isLoadingFun(bool val) {
    isLoading.value = val;
  }

  void isNearLoadingFun(bool val) {
    isNearLoading.value = val;
  }

  onChangeIndex(int val) {
    bottomNavIndex.value = val;
  }

  List items = [];
  RxInt initPage = 0.obs;
  final _homeController = BottomNavigiationController();
  initData(int initPageNumber) async {
    isLoadingFun(true);
    initPage.value = initPageNumber;
    bottomNavIndex.value = initPageNumber;
    _homeController.navListener.sink.add(initPageNumber);

    items = [
      const BottomHomeScreen(),
      const ExploreScreen(
        fromBottomSheet: true,
      ),
      // const MyOrderCustomAppBar(
      //   fromBottomSheet: true,
      // ),
      const OrderListScreen(),
      const BottomProfileScreen(
        fromBottomSheet: true,
      ),
    ];

    isLoadingFun(false);
  }

  // checkLoginIndex() {
  //   if (_bottomNavIndex == 4 && !_isLogin) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future getHomeData(
    String lat,
    String long,
  ) async {
    var result = await mainHomeRepository.getHomeList(lat, long);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      EasyLoading.dismiss();
    }, (data) {
      sliderList.assignAll(data.slider ?? []);
      categoryList.assignAll(data.categories ?? []);
      topRatedProductList.assignAll(data.topRatedProduct ?? []);
      bestSellerProductList.assignAll(data.bestSellerProduct ?? []);
      allProductList.assignAll(data.products ?? []);
      topSellingBrandsList.assignAll(data.topSellingBrands ?? []);
    });
  }

  getNearbyHomeData() async {
    topRatedProductList.clear();
    bestSellerProductList.clear();
    allProductList.clear();
    isNearLoadingFun(true);
    var result = await mainHomeRepository.getHomeList("72.8397", "19.3919");

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      EasyLoading.dismiss();
      isNearLoadingFun(false);
    }, (data) {
      topRatedProductList.assignAll(data.topRatedProduct ?? []);
      bestSellerProductList.assignAll(data.bestSellerProduct ?? []);
      allProductList.assignAll(data.products ?? []);
      isNearLoadingFun(false);
    });
  }

  Future getProfile() async {
    var result = await mainHomeRepository.getProfile();

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
    }, (data) {});
  }
}
