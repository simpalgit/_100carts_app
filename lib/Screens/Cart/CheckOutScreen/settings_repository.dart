import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:carts_app/Utils/app_base_api_services.dart';
import 'package:carts_app/Utils/app_exceptions.dart';
import 'package:carts_app/Utils/app_failure.dart';
import 'package:carts_app/Utils/app_network_api_services.dart';
import 'package:carts_app/Utils/remote_urls.dart';

class SettingsRepository {
  BaseApiService apiService = NetworkAPIService();

  Future<Either<Failure, dynamic>> startSomthing(
      BuildContext context, var passedData, String sha256) async {
    try {
      var response = await apiService.getPostPaymentGatewayResponse(
          RemoteUrl.startTrasactionLive, passedData, context, sha256);
      dynamic data;
      if (response.statusCode == 200) {
        var decodeData = json.decode(response.body);
        // data = InitPaymentModel.fromJson(decodeData);
      } else {
        data = "error";
      }

      return right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
