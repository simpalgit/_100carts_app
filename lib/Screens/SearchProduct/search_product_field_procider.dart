import 'package:get/get.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Repositories/main_home_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class SearchProductController extends GetxController {
  MainHomeRepository productRepository = MainHomeRepository();
  RxBool isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    debounce(searchQuery, (_) {
      fetchData(searchQuery.value);
    }, time: const Duration(milliseconds: 500));
    super.onInit();
  }

  loadingFun(bool val) {
    isLoading.value = val;
  }

  int off = 0;

  initData() {
    productList.clear();
  }

  RxList<ProductModel> productList = <ProductModel>[].obs;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  Future fetchData(String query) async {
    initData();
    loadingFun(true);
    var result = await productRepository.getProductOnQuery(query);

    result.fold((error) {
      CommonFunctions.showErrorSnackbar(error.message);
      loadingFun(false);
    }, (data) {
      productList.value = data;
      if (query.isEmpty) {
        productList.clear();
      }
      loadingFun(false);
    });
  }
}
