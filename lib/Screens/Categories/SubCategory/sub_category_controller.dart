import 'package:get/get.dart';
import 'package:carts_app/Models/category_model.dart';
import 'package:carts_app/Repositories/main_home_repository.dart';

class SubCategoryController extends GetxController {
  MainHomeRepository mainHomeRepository = MainHomeRepository();
  RxBool isLoading = false.obs;
  Rxn<CategoryModel> categoryModel = Rxn<CategoryModel>();

  loadingFun(bool val) => isLoading.value = val;

  getInit(CategoryModel catModel) {
    // catModel.children!.removeWhere((e) => e.children!.isEmpty);
    categoryModel.value = catModel;
  }
}

class SubSubCategoryController extends GetxController {
  MainHomeRepository mainHomeRepository = MainHomeRepository();
  RxBool isLoading = false.obs;
  Rxn<CategoryModel> categoryModel = Rxn<CategoryModel>();

  loadingFun(bool val) => isLoading.value = val;

  getInit(CategoryModel catModel) {
    // catModel.children!.removeWhere((e) => e.children!.isEmpty);
    categoryModel.value = catModel;
  }
}
