import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:carts_app/Models/create_pay_order_model.dart';
import 'package:carts_app/Models/home_model.dart';
import 'package:carts_app/Models/product_detail_model.dart';
import 'package:carts_app/Models/review_paginated_model.dart';
import 'package:carts_app/Models/user_address_model.dart';
import 'package:carts_app/Screens/ProductDetail/Components/product_detail_component.dart';
import 'package:carts_app/Utils/app_base_api_services.dart';
import 'package:carts_app/Utils/app_exceptions.dart';
import 'package:carts_app/Utils/app_failure.dart';
import 'package:carts_app/Utils/app_network_api_services.dart';
import 'package:carts_app/Utils/common_functions.dart';
import 'package:carts_app/Utils/remote_urls.dart';

class ProductRepository {
  BaseApiService apiService = NetworkAPIService();
  Future<Either<Failure, ProductDetailModel>> getProductDetail(
      String prodId, ProductModel productModel) async {
    try {
      var response = await apiService.getGetApiResponse(
        "${RemoteUrl.getVariationDetail}/$prodId",
      );

      ProductDetailModel productDetail = ProductDetailModel.fromJson(
          response, productModel.isFavorite ?? false);

      return right(productDetail);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, ReviewPaginatedModel>> getFirstReviewLoad(
      String prodId, String varId, String offset) async {
    try {
      var response = await apiService.getGetApiResponse(
        "${RemoteUrl.getReviews}$offset&product_id=$prodId&variation_id=$varId",
      );

      ReviewPaginatedModel reviewPaginatedModel =
          ReviewPaginatedModel.fromJson(response);

      return right(reviewPaginatedModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, ReviewPaginatedModel>> getReviewList(
      String prodId, String varId, String offset) async {
    try {
      var response = await apiService.getGetApiResponse(
        "${RemoteUrl.getReviews}$offset&product_id=$prodId&variation_id=$varId",
      );

      ReviewPaginatedModel reviewPaginatedModel =
          ReviewPaginatedModel.fromJson(response);

      return right(reviewPaginatedModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addReview(
    var passedBody,
  ) async {
    try {
      var response = await apiService.getPostApiResponse(
        RemoteUrl.addReview,
        passedBody,
      );

      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<ProductModel>>> getCartData() async {
    try {
      var response = await apiService.getGetApiResponse(
        RemoteUrl.getCart,
      );
      List<ProductModel> cartList = [];
      if (response['response'] == true) {
        cartList = response["data"]
            .map<ProductModel>(
              (e) => ProductModel.fromJson(e['variation'], e["quantity"]),
            )
            .toList();
      }

      return right(cartList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> addCartData(
      String prodId, String variationId, int currentQuantity) async {
    var jsonBody = json.encode({
      "product_id": prodId,
      "quantity": currentQuantity,
      "variation_id": variationId,
    });
    try {
      var response = await apiService.getPostApiResponse(
        RemoteUrl.addToCart,
        jsonBody,
      );
      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> removeCartData(
      ProductModel productModel) async {
    var jsonBody = json.encode({
      "product_id": productModel.productId,
      "quantity": "1",
      "variation_id": productModel.id,
    });
    try {
      var response = await apiService.getDeleteWithBodyApiResponse(
        RemoteUrl.deleteFromCart,
        jsonBody,
      );
      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<ProductModel>>> getWishListData() async {
    try {
      var response = await apiService.getGetApiResponse(
        RemoteUrl.getWishlist,
      );
      List<ProductModel> wishList = [];
      if (response['response'] == true) {
        wishList = response["data"]
            .map<ProductModel>(
              (e) => ProductModel.fromJson(e['variation']),
            )
            .toList();
      }

      return right(wishList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<OrderListModel>>> getOrderListData() async {
    try {
      // Fetch the response from the API
      var response = await apiService.getGetApiResponse(
        RemoteUrl.getUserOrder,
      );
      print("orderList${response["data"]}");

      List<OrderListModel> orderList = [];

      // Check if the response is valid
      if (response['response'] == true && response['data'] != null) {
        // Map the response data to a list of OrderListModel
        orderList = response["data"]
            .map<OrderListModel>((e) => OrderListModel.fromJson(e))
            .toList();
      }

      // Return the list of order models
      return right(orderList);
    } on ServerException catch (e) {
      // Handle server exceptions
      return Left(ServerFailure(e.message, e.statusCode));
    } catch (e) {
      // Catch any other exceptions and log them
      print("Unexpected error: $e");
      return const Left(ServerFailure("Unexpected error occurred", 500));
    }
  }

  Future<Either<Failure, dynamic>> addWishListData(
      String from, dynamic productModel) async {
    String productId = from == "home"
        ? productModel.productId.toString()
        : productModel.data!.productId!.toString();
    String id = from == "home"
        ? productModel.id.toString()
        : productModel.data!.id!.toString();
    var jsonBody = json.encode({"product_id": productId, "variation_id": id});
    try {
      var response = await apiService.getPostApiResponse(
        RemoteUrl.addToWishlist,
        jsonBody,
      );

      CommonFunctions().addOrRemoveLocalWishListProduct(
          operation: "add", val: "$id-$productId");
      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> removeWishListData(
    dynamic productModel,
    String from,
  ) async {
    String productId = from == "detail"
        ? productModel.data!.productId!.toString()
        : productModel.productId!.toString();
    String id = from == "detail"
        ? productModel.data!.id.toString()
        : productModel.id.toString();

    var passedBody = json.encode({
      "product_id": productId,
      "variation_id": id,
    });

    try {
      var response = await apiService.getDeleteWithBodyApiResponse(
        RemoteUrl.deleteFromWishlist,
        passedBody,
      );
      CommonFunctions().addOrRemoveLocalWishListProduct(
          operation: "remove", val: "$id-$productId");
      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, List<UserAddressModel>>> getSavedAddress() async {
    try {
      var response = await apiService.getGetApiResponse(
        RemoteUrl.getUserSavedAddress,
      );

      List<UserAddressModel> userAddressList = [];
      if (response['response'] == true) {
        userAddressList = response["data"]
            .map<UserAddressModel>(
              (e) => UserAddressModel.fromJson(e),
            )
            .toList();
      }

      return right(userAddressList);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, CreatePayOrderModel>> cretePaymentOrder(
      passedBody) async {
    try {
      var response = await apiService.getPostApiResponse(
        RemoteUrl.createPaymentOrder,
        passedBody,
      );

      var extractedData = json.decode(response.body);

      CreatePayOrderModel createPayOrderModel = CreatePayOrderModel();

      if (extractedData["response"]) {
        createPayOrderModel = CreatePayOrderModel.fromJson(extractedData);
      }

      return right(createPayOrderModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  // copy
  Future cretePaymentOrderAndroid(passedBody) async {
    try {
      var response = await apiService.getPostApiResponse(
        RemoteUrl.createPaymentOrderAndroid,
        passedBody,
      );
      print("response or create payment order$response");
      // if (response['response'] == true) {
      //   await apiService.getPutApiResponse(
      //     RemoteUrl.emptyCart,
      //     "",
      //   );
      // }
      return json.decode(response.body);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  Future<Either<Failure, dynamic>> updateUserOrder(passedBody) async {
    try {
      var response = await apiService.getPostApiResponse(
        RemoteUrl.updateUserOrder,
        passedBody,
      );
      return right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
