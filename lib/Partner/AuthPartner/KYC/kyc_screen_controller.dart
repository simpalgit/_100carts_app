import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carts_app/Models/state_city_model.dart';
import 'package:carts_app/Repositories/auth_repository.dart';
import 'package:carts_app/Utils/common_functions.dart';

class KycScreenController extends GetxController {
  AuthRepository authRepository = AuthRepository();
  final Rx<TextEditingController> ctlFullName = TextEditingController().obs;
  final Rx<TextEditingController> ctlDob = TextEditingController().obs;
  final Rx<TextEditingController> ctlMobile = TextEditingController().obs;
  final Rx<TextEditingController> ctlAltMobile = TextEditingController().obs;
  final Rx<TextEditingController> ctlState = TextEditingController().obs;
  final Rx<TextEditingController> ctlStateName = TextEditingController().obs;
  final Rx<TextEditingController> ctlDistrict = TextEditingController().obs;
  final Rx<TextEditingController> ctlDistrictName = TextEditingController().obs;
  final Rx<TextEditingController> ctlCity = TextEditingController().obs;
  final Rx<TextEditingController> ctlCityName = TextEditingController().obs;

  @override
  void onInit() {
    getStates();
    super.onInit();
  }

  RxBool stateLoading = true.obs;

  loadingState(bool val) => stateLoading.value = val;

  DateTime? callDate;
  Future<void> geDateOfBirth(BuildContext context) async {
    List pickedDate = await CommonFunctions().pickDate(
      context,
      callDate,
    );

    ctlDob.value.text = pickedDate[0] == "null" ? "" : pickedDate[0];
    callDate = pickedDate[1];
  }

  // ! -------------------------------- State -------------------------------- //

  RxList<StatesModel> stateList = <StatesModel>[].obs;
  RxList<StatesModel> filteredStateList = <StatesModel>[].obs;

  Future<void> getStates() async {
    final result = await authRepository.getStates();

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(error.message);
        loadingState(false);
      },
      (data) {
        stateList.value = data;
        filteredStateList.value = stateList;
        loadingState(false);
      },
    );
  }

  StatesModel selectedStateModel = StatesModel();

  void searchState(String query) {
    List<StatesModel> results = [];
    if (query.isEmpty) {
      results = stateList;
    } else {
      results = stateList
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    filteredStateList.value = results;
  }

  void onSelectState(
    StatesModel selectedModel,
  ) {
    selectedStateModel =
        stateList.firstWhere((element) => element.name == selectedModel.name);

    ctlState.value.text = selectedModel.name!;
    ctlStateName.value.text = selectedModel.name!;
    Get.back();

    getDistrictsByStateId(selectedModel.id!);
  }

  // ! -------------------------------- District -------------------------------- //

  RxList<DistrictModel> districtList = <DistrictModel>[].obs;
  RxList<DistrictModel> filteredDistrictList = <DistrictModel>[].obs;

  RxBool districtVisible = false.obs;

  Future<void> getDistrictsByStateId(int stateId) async {
    districtVisible.value = false;
    filteredDistrictList.clear();
    districtList.clear();
    ctlDistrict.value.clear();
    ctlDistrictName.value.clear();
    final result = await authRepository.getDistrict(stateId: stateId);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(error.message);
        districtVisible.value = false;
      },
      (data) {
        districtList.value = data;
        filteredDistrictList.value = data;
        districtVisible.value = true;
      },
    );
  }

  void searchDistrict(String query) {
    List<DistrictModel> results = [];
    if (query.isEmpty) {
      results = districtList;
    } else {
      results = districtList
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    filteredDistrictList.value = results;
  }

  DistrictModel selectedDistrictModel = DistrictModel();
  void onSelectDistrict(
    DistrictModel selectedModel,
  ) {
    selectedDistrictModel = districtList
        .firstWhere((element) => element.name == selectedModel.name);

    ctlDistrict.value.text = selectedModel.name!;
    ctlDistrictName.value.text = selectedModel.name!;
    Get.back();

    getCityByStateId(selectedDistrictModel.id!);
  }

  // ! -------------------------------- City -------------------------------- //

  RxList<CityModel> cityList = <CityModel>[].obs;
  RxList<CityModel> filteredCityList = <CityModel>[].obs;

  RxBool cityVisible = false.obs;

  Future<void> getCityByStateId(int districtId) async {
    cityVisible.value = false;
    filteredCityList.clear();
    cityList.clear();
    ctlCity.value.clear();
    ctlCityName.value.clear();
    final result = await authRepository.getCity(districtId: districtId);

    result.fold(
      (error) {
        CommonFunctions.showErrorSnackbar(error.message);
        cityVisible.value = false;
      },
      (data) {
        cityList.value = data;
        filteredCityList.value = data;
        cityVisible.value = true;
      },
    );
  }

  void searchCity(String query) {
    List<CityModel> results = [];
    if (query.isEmpty) {
      results = cityList;
    } else {
      results = cityList
          .where(
              (item) => item.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    filteredCityList.value = results;
  }

  CityModel selectedCityModel = CityModel();
  void onSelectCity(
    CityModel selectedModel,
  ) {
    selectedCityModel =
        cityList.firstWhere((element) => element.name == selectedModel.name);

    ctlCity.value.text = selectedModel.name!;
    ctlCityName.value.text = selectedModel.name!;
    Get.back();
  }

  @override
  void dispose() {
    ctlFullName.value.dispose();
    ctlDob.value.dispose();
    ctlMobile.value.dispose();
    ctlAltMobile.value.dispose();
    ctlState.value.dispose();
    ctlStateName.value.dispose();
    ctlDistrict.value.dispose();
    ctlDistrictName.value.dispose();
    super.dispose();
  }
}
