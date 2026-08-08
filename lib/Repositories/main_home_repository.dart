import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:carts_app/Models/category_model.dart';
import 'package:carts_app/Models/explore_paginated_model.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/order_attribute_model.dart';
import 'package:carts_app/Models/user_order_model.dart';
import 'package:carts_app/Models/user_profile_model.dart';
import 'package:carts_app/Utils/app_base_api_services.dart';
import 'package:carts_app/Utils/app_exceptions.dart';
import 'package:carts_app/Utils/app_failure.dart';
import 'package:carts_app/Utils/app_network_api_services.dart';
import 'package:carts_app/Utils/local_shared_preferences.dart';
import 'package:carts_app/Utils/remote_urls.dart';

class MainHomeRepository {
  BaseApiService apiService = NetworkAPIService();

  Future<Either<Failure, HomeModel>> getHomeList(
    String lat,
    String long,
  ) async {
    log("${RemoteUrl.getHomeData}$lat&latitude=$long&limit=4");
    try {
      final response = await apiService.getGetApiResponse(
        "${RemoteUrl.getHomeData}$lat&latitude=$long&limit=4",
      );

      var homeModel = HomeModel.fromJson(response);

      return right(homeModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, UserProfileModel>> getProfile() async {
    try {
      final response = await apiService.getGetApiResponse(
        RemoteUrl.partnerProfile,
      );

      String profileData = jsonEncode(response['data']);
      await LocalPreferences().setProfileData(profileData);

      var userProfile = UserProfileModel.fromJson(response["data"]);

      return right(userProfile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, UserProductPaginatedModel>>
      getAllProductListWithPagination(
          int offset, String catId, String query) async {
    String finalQuery = "";
    if (query.isEmpty) {
      finalQuery = "offset=$offset&limit=20&categoryId=$catId";
    } else {
      finalQuery = "$query&offset=$offset&limit=20&categoryId=$catId";
    }

    log("${RemoteUrl.getProductFilter}$finalQuery");
    try {
      var response = await apiService
          .getGetApiResponse("${RemoteUrl.getProductFilter}$finalQuery");

      return right(UserProductPaginatedModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<OrderAttribute>>> getAttributeListCategory(
    int catId,
  ) async {
    try {
      final response = await apiService.getGetApiResponse(
        "${RemoteUrl.getCategoryWiseAttribute}?categoryId=$catId",
      );
      List<OrderAttribute> list = [];
      if (response['data'].isNotEmpty) {
        list = response['data']
            .entries
            .map<OrderAttribute>(
              (element) => OrderAttribute(
                  attributeName: element.key,
                  attributeValues: element.value.entries
                      .map<FilterModel>((entry) =>
                          FilterModel(value: entry.value.toString().trim()))
                      .toList()),
            )
            .toList();
      }

      return right(list);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<CategoryModel>>> getParentCategory() async {
    try {
      final response =
          await apiService.getGetApiResponse(RemoteUrl.getParentCategory);

      List<CategoryModel> parentCatList = [];
      parentCatList = response["data"]
          .map<CategoryModel>(
            (e) => CategoryModel.fromJson(e, "main"),
          )
          .toList();

      return right(parentCatList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<ProductModel>>> getProductOnQuery(
    String query,
  ) async {
    try {
      var response = await apiService.getGetApiResponse(
        "${RemoteUrl.getProductOnSearch}$query",
      );

      List<ProductModel> productList = [];

      productList = response["data"]
          .map<ProductModel>(
            (e) => ProductModel.fromJson(e),
          )
          .toList();

      return right(productList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<ProductModel>>> getSubCategory(
      String catId) async {
    try {
      var response = await apiService.getGetApiResponse(
        "${RemoteUrl.getSubCategory}$catId",
      );

      // List<ProductModel> productList = [];

      // productList = response["data"]
      //     .map<ProductModel>(
      //       (e) => ProductModel.fromJson(e),
      //     )
      //     .toList();

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, UserOrderPaginatedModel>> getOrderList(
    int offset,
  ) async {
    try {
      var response = await apiService.getGetApiResponse(
        "${RemoteUrl.getUserOrder}offset=$offset&limit=20",
      );

      return right(UserOrderPaginatedModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
